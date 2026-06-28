// FutKO — Seed desde questions_seed.json (Node.js + fetch + batching)
const https = require('https');
const fs = require('fs');
const path = require('path');

const projectId = 'futko-battle';
const apiKey = 'AIzaSyAprAmk1hPhlNbkQhgTSjIeEfmFIlfK18M';

const jsonPath = path.join(__dirname, 'questions_seed.json');
const questions = require('./questions_seed.json');

console.log(`📋 Cargadas ${questions.length} preguntas desde questions_seed.json`);

function serializeExtraData(data) {
  if (!data) return null;
  const fields = {};
  for (const [key, value] of Object.entries(data)) {
    if (typeof value === 'boolean') fields[key] = { booleanValue: value };
    else if (typeof value === 'number') fields[key] = { doubleValue: value };
    else fields[key] = { stringValue: String(value) };
  }
  return { mapValue: { fields } };
}

function uploadQuestion(q, idx) {
  return new Promise((resolve) => {
    const docId = String(q.id || q._id || `q_${idx}`);
    const data = JSON.stringify({
      fields: {
        id: { stringValue: docId },
        type: { stringValue: q.type || 'unknown' },
        difficulty: { stringValue: q.difficulty || 'medium' },
        questionText: { stringValue: q.questionText || q.text || '' },
        correctAnswer: { stringValue: q.correctAnswer || q.answer || '' },
        options: { arrayValue: { values: (q.options || []).map(o => ({ stringValue: o })) } },
        imageUrl: q.imageUrl ? { stringValue: q.imageUrl } : { nullValue: null },
        extraData: serializeExtraData(q.extraData),
      }
    });

    const options = {
      hostname: 'firestore.googleapis.com',
      path: `/v1/projects/${projectId}/databases/(default)/documents/questions/${docId}?key=${apiKey}`,
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) }
    };

    const req = https.request(options, (res) => {
      let responseData = '';
      res.on('data', chunk => responseData += chunk);
      res.on('end', () => {
        if (res.statusCode === 200 || res.statusCode === 201) {
          resolve({ ok: true, docId });
        } else {
          resolve({ ok: false, docId, status: res.statusCode, error: responseData.substring(0, 100) });
        }
      });
    });

    req.on('error', (e) => resolve({ ok: false, docId, error: e.message }));
    req.write(data);
    req.end();
  });
}

async function runBatch(batch, startIdx, total) {
  const results = await Promise.all(batch.map((q, bi) => uploadQuestion(q, startIdx + bi).then(r => ({ ...r, idx: startIdx + bi }))));
  for (const r of results) {
    if (r.ok) {
      process.stdout.write(`  ✅ [${r.idx + 1}/${total}] ${r.docId}\n`);
    } else {
      process.stdout.write(`  ❌ [${r.idx + 1}/${total}] ${r.docId}: ${r.status} ${r.error}\n`);
    }
  }
  return results;
}

async function seed() {
  const BATCH_SIZE = 25;
  let ok = 0, fail = 0;

  console.log(`🚀 Subiendo ${questions.length} preguntas a Firestore (batch size: ${BATCH_SIZE})...\n`);

  for (let i = 0; i < questions.length; i += BATCH_SIZE) {
    const batch = questions.slice(i, i + BATCH_SIZE);
    const results = await runBatch(batch, i, questions.length);
    ok += results.filter(r => r.ok).length;
    fail += results.filter(r => !r.ok).length;

    // Brief pause between batches to avoid rate limiting
    if (i + BATCH_SIZE < questions.length) {
      await new Promise(r => setTimeout(r, 200));
    }
  }

  console.log(`\n🎉 Seed completado!`);
  console.log(`   ✅ OK: ${ok}`);
  console.log(`   ❌ Fallos: ${fail}`);
}

seed().catch(err => {
  console.error('❌ Error fatal:', err);
  process.exit(1);
});