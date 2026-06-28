// FutKO — Siembra de preguntas con Firebase Admin SDK.
//
// El Admin SDK usa una *service account*, así que IGNORA las reglas de
// seguridad: NO hace falta tocar firestore.rules ni desplegar nada. La regla
// `questions` puede quedarse en `allow write: if false;` para siempre.
//
// Setup (una sola vez):
//   1. Firebase Console -> Configuración del proyecto -> Cuentas de servicio
//      -> "Generar nueva clave privada" -> guarda el JSON como
//      scripts/serviceAccount.json  (ya está en .gitignore)
//   2. cd scripts && npm install
//
// Uso (cada vez que cambies preguntas):
//   flutter test test/question_export_test.dart   # regenera questions_seed.json
//   node scripts/seed_admin.js                     # borra y resiembra
//
// O todo de una con el atajo de package.json:
//   cd scripts && npm run seed

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const keyPath =
  process.env.GOOGLE_APPLICATION_CREDENTIALS ||
  path.join(__dirname, 'serviceAccount.json');

if (!fs.existsSync(keyPath)) {
  console.error(`❌ No encuentro la service account en: ${keyPath}\n` +
    '   Descárgala de Firebase Console -> Cuentas de servicio -> Generar clave privada\n' +
    '   y guárdala como scripts/serviceAccount.json (o exporta GOOGLE_APPLICATION_CREDENTIALS).');
  process.exit(1);
}

admin.initializeApp({ credential: admin.credential.cert(require(keyPath)) });
const db = admin.firestore();

async function deleteCollection(col) {
  let removed = 0;
  while (true) {
    const snap = await col.limit(400).get();
    if (snap.empty) break;
    const batch = db.batch();
    snap.docs.forEach((d) => batch.delete(d.ref));
    await batch.commit();
    removed += snap.size;
    process.stdout.write(`\r🗑️  borradas ${removed}...`);
  }
  console.log(`\r🗑️  borradas ${removed} preguntas antiguas.`);
}

// Resuelve las rutas de imagen tipo "/silhouettes/slug.png" a URLs reales
// (image_urls.json). Las preguntas con imagen pero SIN URL real se descartan
// para no sembrar preguntas-imagen rotas.
// Slug con transliteración completa (NFD), igual que las claves de
// image_urls.json: "Luka Modrić" -> "luka_modric", "São Paulo FC" -> "sao_paulo_fc".
function slugify(s) {
  return s
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '');
}

function resolveImages(questions) {
  // Prefiere las imágenes ya alojadas en Firebase Storage (cargan en el móvil
  // sin depender de hosts externos). Cae a image_urls.json si no existe.
  const storage = path.join(__dirname, 'image_urls_storage.json');
  const imageUrls = fs.existsSync(storage)
      ? require('./image_urls_storage.json')
      : require('./image_urls.json');
  const kept = [];
  let replaced = 0;
  let dropped = 0;
  for (const q of questions) {
    if (!q.imageUrl) {
      kept.push(q);
      continue;
    }
    const m = q.imageUrl.match(/^\/([^/]+)\//); // categoría: silhouettes/badges/...
    if (!m) {
      kept.push(q);
      continue;
    }
    // El nombre real (correctAnswer) da el slug fiable, no la ruta de Dart.
    const url = (imageUrls[m[1]] || {})[slugify(q.correctAnswer)];
    if (url) {
      kept.push({ ...q, imageUrl: url });
      replaced++;
    } else {
      dropped++;
    }
  }
  console.log(`🖼️  imágenes reales: ${replaced} · descartadas sin imagen: ${dropped}`);
  return kept;
}

async function main() {
  const file = path.join(__dirname, 'questions_seed.json');
  const raw = JSON.parse(fs.readFileSync(file, 'utf-8'));
  const questions = resolveImages(raw);
  console.log(`📋 ${questions.length} preguntas (de ${raw.length}) desde ${file}`);

  const col = db.collection('questions');
  await deleteCollection(col);

  let written = 0;
  for (let i = 0; i < questions.length; i += 400) {
    const batch = db.batch();
    for (const q of questions.slice(i, i + 400)) {
      batch.set(col.doc(), q); // Admin SDK serializa tipos automáticamente
    }
    await batch.commit();
    written += Math.min(400, questions.length - i);
    process.stdout.write(`\r⬆️  subidas ${written}/${questions.length}...`);
  }
  console.log(`\r✅ Sembradas ${written} preguntas. Reglas intactas.`);
}

main().catch((e) => {
  console.error('Error fatal:', e);
  process.exit(1);
});
