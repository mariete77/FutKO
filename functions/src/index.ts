import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

const MIN_ELO = 100;
const K_NEW = 32;
const K_ESTABLISHED = 16;
const NEW_PLAYER_THRESHOLD = 30;

// ── League system (mirrors lib/core/utils/league_system.dart) ──────────────
// ELO stays as a hidden MMR used to matchmake and to modulate league points;
// the visible progression is league tier (1..5) + league points (0..99).
const LEAGUE_COUNT = 5;
const LEAGUE_START_TIER = 2;
const LP_TO_PROMOTE = 100;
const LP_BASE_DELTA = 24;
const LP_WIN_FLOOR = 10;
const LP_LOSS_FLOOR = 10;
const LP_CLAMP_MIN = -30;
const LP_CLAMP_MAX = 34;
const LP_PROMOTE_START = 20;
const LP_RELEGATE_START = 75;
const PLACEMENT_GAMES = 5;

function expectedScore(playerElo: number, opponentElo: number): number {
  return 1.0 / (1.0 + Math.pow(10, (opponentElo - playerElo) / 400.0));
}

function eloChange(
  playerElo: number,
  opponentElo: number,
  score: number,
  gamesPlayed: number
): number {
  const k = gamesPlayed < NEW_PLAYER_THRESHOLD ? K_NEW : K_ESTABLISHED;
  return Math.round(k * (score - expectedScore(playerElo, opponentElo)));
}

// League points delta for a match, modulated by the ELO expectation.
// Mirrors LeagueSystem.lpDelta (margin bonus omitted to match client v1).
function leagueLpDelta(
  playerElo: number,
  opponentElo: number,
  score: number
): number {
  const expected = expectedScore(playerElo, opponentElo);
  const core = Math.round(LP_BASE_DELTA * (score - expected));
  let floor = 0;
  if (score === 1.0) floor = LP_WIN_FLOOR;
  else if (score === 0.0) floor = -LP_LOSS_FLOOR;
  const delta = core + floor;
  return Math.max(LP_CLAMP_MIN, Math.min(LP_CLAMP_MAX, delta));
}

interface LeagueOutcome {
  tier: number;
  leaguePoints: number;
  promoted: boolean;
  relegated: boolean;
}

// Resolves promotion/relegation after applying an LP delta. Mirrors
// LeagueSystem.applyMatch. [protectedFromRelegation] = placement shield.
function applyLeague(
  tier: number,
  leaguePoints: number,
  lpDelta: number,
  protectedFromRelegation: boolean
): LeagueOutcome {
  let t = tier;
  let lp = leaguePoints + lpDelta;
  let promoted = false;
  let relegated = false;

  if (lp >= LP_TO_PROMOTE) {
    if (t < LEAGUE_COUNT) {
      t += 1;
      lp = LP_PROMOTE_START;
      promoted = true;
    } else {
      lp = LP_TO_PROMOTE - 1; // cap at Primera División
    }
  } else if (lp < 0) {
    if (protectedFromRelegation || t <= 1) {
      lp = 0; // absolute floor
    } else {
      t -= 1;
      lp = LP_RELEGATE_START;
      relegated = true;
    }
  }

  const clamped = Math.max(0, Math.min(LP_TO_PROMOTE - 1, lp));
  return {tier: t, leaguePoints: clamped, promoted, relegated};
}

// Authoritative ELO + league resolution when a match finishes. Runs once per
// match (guarded on the status transition). Casual / friend matches do NOT
// touch ELO or league. The client reports scores + winnerId; this function is
// the single source of truth for elo/leagueTier/leaguePoints (stats stay
// client-owned).
export const onMatchFinished = functions.firestore
  .document("matches/{matchId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    if (!before || !after) return null;
    if (before.status === "finished" || after.status !== "finished") return null;

    const players: string[] = after.players || [];
    if (players.length < 2) return null;

    const result = after.result;
    if (!result || !result.scores) return null;

    const matchType: string = after.type || "casual";
    const isRanked = matchType === "ranked";

    // Casual / friend challenges must not affect ELO or league.
    if (!isRanked) {
      functions.logger.info(
        `Match ${context.params.matchId} finished (casual) — no ELO/league change.`
      );
      return null;
    }

    const [p1, p2] = players;
    const userDocs = await Promise.all([
      db.collection("users").doc(p1).get(),
      db.collection("users").doc(p2).get(),
    ]);

    if (!userDocs[0].exists || !userDocs[1].exists) return null;

    const u1 = userDocs[0].data()!;
    const u2 = userDocs[1].data()!;

    const elo1 = u1.elo ?? 1000;
    const elo2 = u2.elo ?? 1000;
    const games1 = u1.stats?.totalGames ?? 0;
    const games2 = u2.stats?.totalGames ?? 0;

    // The winner is authoritative from the client (it has full answer timings,
    // including speed tie-breakers). Fall back to raw score comparison.
    const score1 = result.scores[p1] ?? 0;
    const score2 = result.scores[p2] ?? 0;
    const winnerId: string | null = result.winnerId ?? null;

    let s1: number;
    if (winnerId === p1) s1 = 1.0;
    else if (winnerId === p2) s1 = 0.0;
    else if (score1 > score2) s1 = 1.0;
    else if (score1 < score2) s1 = 0.0;
    else s1 = 0.5;
    const s2 = 1.0 - s1;

    // Authoritative ELO change.
    const change1 = eloChange(elo1, elo2, s1, games1);
    const change2 = eloChange(elo2, elo1, s2, games2);
    const newElo1 = Math.max(MIN_ELO, elo1 + change1);
    const newElo2 = Math.max(MIN_ELO, elo2 + change2);

    // League points computed from the SAME authoritative ELO, so deltas stay
    // coherent with the ELO change above.
    const lp1 = u1.leaguePoints ?? 0;
    const lp2 = u2.leaguePoints ?? 0;
    const tier1 = u1.leagueTier ?? LEAGUE_START_TIER;
    const tier2 = u2.leagueTier ?? LEAGUE_START_TIER;

    const lpDelta1 = leagueLpDelta(elo1, elo2, s1);
    const lpDelta2 = leagueLpDelta(elo2, elo1, s2);

    const league1 = applyLeague(tier1, lp1, lpDelta1, games1 < PLACEMENT_GAMES);
    const league2 = applyLeague(tier2, lp2, lpDelta2, games2 < PLACEMENT_GAMES);

    const batch = db.batch();

    batch.update(db.collection("users").doc(p1), {
      elo: newElo1,
      leagueTier: league1.tier,
      leaguePoints: league1.leaguePoints,
    });
    batch.update(db.collection("users").doc(p2), {
      elo: newElo2,
      leagueTier: league2.tier,
      leaguePoints: league2.leaguePoints,
    });

    // Merge authoritative outcome into the match result without wiping the
    // scores/winnerId reported by the client.
    batch.update(change.after.ref, {
      "result.eloChanges": {[p1]: change1, [p2]: change2},
      "result.newElo": {[p1]: newElo1, [p2]: newElo2},
      "result.lpChanges": {[p1]: lpDelta1, [p2]: lpDelta2},
      "result.league": {
        [p1]: {
          tier: league1.tier,
          leaguePoints: league1.leaguePoints,
          promoted: league1.promoted,
          relegated: league1.relegated,
        },
        [p2]: {
          tier: league2.tier,
          leaguePoints: league2.leaguePoints,
          promoted: league2.promoted,
          relegated: league2.relegated,
        },
      },
    });

    await batch.commit();

    functions.logger.info(
      `Match ${context.params.matchId} resolved: ${p1} ELO ${elo1}→${newElo1} ` +
        `(LP ${lp1}→${league1.leaguePoints}, tier ${tier1}→${league1.tier}), ` +
        `${p2} ELO ${elo2}→${newElo2} (LP ${lp2}→${league2.leaguePoints}, ` +
        `tier ${tier2}→${league2.tier})`
    );
    return null;
  });

export const resetDailyGames = functions.pubsub
  .schedule("0 0 * * *")
  .timeZone("UTC")
  .onRun(async () => {
    const snapshot = await db
      .collection("users")
      .where("dailyGames.played", ">", 0)
      .get();

    const batch = db.batch();
    for (const doc of snapshot.docs) {
      batch.update(doc.ref, {
        "dailyGames.played": 0,
        "dailyGames.date": admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    functions.logger.info(`Reset dailyGames for ${snapshot.size} users`);
    return null;
  });

export const onFriendRequest = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (!before || !after) return null;

    const prev: string[] = before.pending_requests || [];
    const curr: string[] = after.pending_requests || [];
    const added = curr.filter((uid) => !prev.includes(uid));
    if (added.length === 0) return null;

    const tokens: string[] = after.fcmTokens || [];
    if (tokens.length === 0) return null;

    // Nombre del último solicitante para el cuerpo de la notificación.
    const requesterDoc = await db
      .collection("users")
      .doc(added[added.length - 1])
      .get();
    const requesterName = requesterDoc.data()?.displayName ?? "Alguien";

    await admin.messaging().sendEachForMulticast({
      tokens,
      notification: {
        title: "Nueva solicitud de amistad",
        body: `${requesterName} quiere ser tu amigo en FutKO`,
      },
      data: {type: "friend_request"},
    });

    functions.logger.info(
      `Friend request push sent to ${context.params.userId} (${tokens.length} tokens)`
    );
    return null;
  });

export const validateAnswer = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Debes iniciar sesión"
      );
    }

    const {questionId, userAnswer} = data;
    if (!questionId || userAnswer === undefined) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "questionId y userAnswer son obligatorios"
      );
    }

    const questionDoc = await db.collection("questions").doc(questionId).get();
    if (!questionDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Pregunta no encontrada");
    }

    const question = questionDoc.data()!;
    const correctAnswer: string = question.correctAnswer ?? "";

    const isCorrect =
      correctAnswer.toLowerCase().trim() ===
      String(userAnswer).toLowerCase().trim();

    return {isCorrect, questionId};
  }
);
