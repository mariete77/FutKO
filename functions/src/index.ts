import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

const MIN_ELO = 100;
const K_NEW = 32;
const K_ESTABLISHED = 16;
const NEW_PLAYER_THRESHOLD = 30;

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
    if (!result || !result.scores || !result.eloChanges) return null;

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

    const score1 = result.scores[p1] ?? 0;
    const score2 = result.scores[p2] ?? 0;

    let s1: number;
    if (score1 > score2) s1 = 1.0;
    else if (score1 < score2) s1 = 0.0;
    else s1 = 0.5;
    const s2 = 1.0 - s1;

    const change1 = eloChange(elo1, elo2, s1, games1);
    const change2 = eloChange(elo2, elo1, s2, games2);

    const newElo1 = Math.max(MIN_ELO, elo1 + change1);
    const newElo2 = Math.max(MIN_ELO, elo2 + change2);

    const batch = db.batch();

    batch.update(db.collection("users").doc(p1), {
      elo: newElo1,
      "stats.totalGames": admin.firestore.FieldValue.increment(1),
      "stats.wins": admin.firestore.FieldValue.increment(s1 === 1.0 ? 1 : 0),
      "stats.losses": admin.firestore.FieldValue.increment(
        s1 === 0.0 ? 1 : 0
      ),
      "stats.draws": admin.firestore.FieldValue.increment(s1 === 0.5 ? 1 : 0),
    });

    batch.update(db.collection("users").doc(p2), {
      elo: newElo2,
      "stats.totalGames": admin.firestore.FieldValue.increment(1),
      "stats.wins": admin.firestore.FieldValue.increment(s2 === 1.0 ? 1 : 0),
      "stats.losses": admin.firestore.FieldValue.increment(
        s2 === 0.0 ? 1 : 0
      ),
      "stats.draws": admin.firestore.FieldValue.increment(s2 === 0.5 ? 1 : 0),
    });

    batch.update(change.after.ref, {
      "result.eloChanges": { [p1]: change1, [p2]: change2 },
      "result.newElo": { [p1]: newElo1, [p2]: newElo2 },
    });

    await batch.commit();

    functions.logger.info(
      `Match ${context.params.matchId} ELO updated: ${p1} ${elo1}→${newElo1}, ${p2} ${elo2}→${newElo2}`
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
      data: { type: "friend_request" },
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

    const { questionId, userAnswer } = data;
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

    return { isCorrect, questionId };
  }
);
