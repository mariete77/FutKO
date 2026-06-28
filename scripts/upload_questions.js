// FutKO — Sube las preguntas generadas (coherentes) a Firestore vía REST.
//
// Lee scripts/questions_seed.json (exportado con:
//   flutter test test/question_export_test.dart)
// borra la colección `questions` y sube las nuevas.
//
// Requisitos:
//   - Node 18+ (usa fetch nativo).
//   - Regla de Firestore para `questions` con escritura permitida mientras se
//     siembra. Recomendado (seguro): `allow write: if request.auth != null;`
//     y autenticarse con un usuario vía las variables de entorno de abajo.
//     Sin auth y con la regla por defecto (`if false`) recibirás 403.
//
// Uso (autenticado, recomendado):
//   FUTKO_EMAIL=tu@email.com FUTKO_PASSWORD=tuclave node scripts/upload_questions.js
//
// Uso (sin auth — solo si la regla está temporalmente en `if true`):
//   node scripts/upload_questions.js

const fs = require('fs');
const path = require('path');

const projectId = 'futko-battle';
const apiKey = 'AIzaSyAprAmk1hPhlNbkQhgTSjIeEfmFIlfK18M'; // Web API key (pública)
const base = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents`;

let authHeader = {};

async function signIn() {
  const email = process.env.FUTKO_EMAIL;
  const password = process.env.FUTKO_PASSWORD;
  if (!email || !password) {
    console.log('ℹ️  Sin FUTKO_EMAIL/FUTKO_PASSWORD: subiendo sin autenticar '
      + '(requiere regla `questions` abierta temporalmente).');
    return;
  }
  const res = await fetch(
    `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${apiKey}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password, returnSecureToken: true }),
    });
  if (!res.ok) throw new Error(`login falló: ${res.status} ${await res.text()}`);
  const data = await res.json();
  authHeader = { Authorization: `Bearer ${data.idToken}` };
  console.log(`🔑 Autenticado como ${email}`);
}

function toValue(v) {
  if (v === null || v === undefined) return { nullValue: null };
  if (typeof v === 'string') return { stringValue: v };
  if (typeof v === 'boolean') return { booleanValue: v };
  if (typeof v === 'number') {
    return Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
  }
  if (Array.isArray(v)) return { arrayValue: { values: v.map(toValue) } };
  if (typeof v === 'object') {
    const fields = {};
    for (const [k, val] of Object.entries(v)) fields[k] = toValue(val);
    return { mapValue: { fields } };
  }
  return { stringValue: String(v) };
}

function toFields(obj) {
  const fields = {};
  for (const [k, v] of Object.entries(obj)) fields[k] = toValue(v);
  return fields;
}

async function deleteAll() {
  let removed = 0;
  while (true) {
    const res = await fetch(`${base}/questions?pageSize=300&key=${apiKey}`, { headers: authHeader });
    if (!res.ok) throw new Error(`list falló: ${res.status} ${await res.text()}`);
    const data = await res.json();
    const docs = data.documents || [];
    if (docs.length === 0) break;
    for (const doc of docs) {
      const name = doc.name.split('/databases/(default)/documents/')[1];
      const del = await fetch(`${base}/${name}?key=${apiKey}`, { method: 'DELETE', headers: authHeader });
      if (del.ok) removed++;
      else console.error(`  ⚠️ delete ${name}: ${del.status}`);
    }
    process.stdout.write(`\r🗑️  borradas ${removed}...`);
  }
  console.log(`\r🗑️  borradas ${removed} preguntas antiguas.`);
}

async function upload() {
  const file = path.join(__dirname, 'questions_seed.json');
  const questions = JSON.parse(fs.readFileSync(file, 'utf-8'));
  console.log(`📋 ${questions.length} preguntas desde ${file}`);
  console.log(`🔥 Proyecto: ${projectId}`);

  await signIn();
  await deleteAll();

  let ok = 0, fail = 0;
  for (let i = 0; i < questions.length; i++) {
    const res = await fetch(`${base}/questions?key=${apiKey}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', ...authHeader },
      body: JSON.stringify({ fields: toFields(questions[i]) }),
    });
    if (res.ok) ok++;
    else {
      fail++;
      if (fail <= 3) console.error(`\n  ❌ [${i + 1}] ${res.status}: ${await res.text()}`);
    }
    if (i % 25 === 0) process.stdout.write(`\r⬆️  subidas ${ok}/${questions.length}...`);
  }
  console.log(`\r✅ Subidas ${ok} preguntas.${fail ? ` ❌ ${fail} fallos.` : ''}`);
}

upload().catch((e) => {
  console.error('Error fatal:', e);
  process.exit(1);
});
