// FutKO — Aloja las imágenes de preguntas en Firebase Storage.
//
// Descarga cada imagen de image_urls.json (Wikimedia / TheSportsDB) y la sube
// al bucket del proyecto con una URL de descarga PERMANENTE (token), para no
// depender de hosts externos (que en el móvil a veces no cargan).
//
// Salida: scripts/image_urls_storage.json  (mismo formato, URLs de Storage).
//
// Uso:  node scripts/host_images.js

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

admin.initializeApp({
  credential: admin.credential.cert(require('./serviceAccount.json')),
  storageBucket: 'futko-battle.firebasestorage.app',
});
const bucket = admin.storage().bucket();

const CONTENT_TYPE = { png: 'image/png', jpg: 'image/jpeg', jpeg: 'image/jpeg' };

// Wikimedia exige un User-Agent descriptivo con contacto; si no, devuelve 429/403.
const UA = 'FutKO/1.0 (https://futko.app; admin@futko.app) seed-script';
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function download(srcUrl, tries = 4) {
  for (let i = 0; i < tries; i++) {
    const res = await fetch(srcUrl, { headers: { 'User-Agent': UA } });
    if (res.ok) return Buffer.from(await res.arrayBuffer());
    if (res.status === 429 || res.status >= 500) {
      await sleep(1500 * (i + 1)); // backoff
      continue;
    }
    throw new Error(`download ${res.status}`);
  }
  throw new Error('download 429 (agotados reintentos)');
}

async function hostOne(category, slug, srcUrl) {
  const buf = await download(srcUrl);
  const ext = (srcUrl.split('?')[0].match(/\.(png|jpe?g)$/i)?.[1] || 'jpg').toLowerCase();
  const dest = `question_images/${category}/${slug}.${ext}`;
  const token = crypto.randomUUID();
  await bucket.file(dest).save(buf, {
    resumable: false,
    metadata: {
      contentType: CONTENT_TYPE[ext] || 'image/jpeg',
      metadata: { firebaseStorageDownloadTokens: token },
    },
  });
  return `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/`
    + `${encodeURIComponent(dest)}?alt=media&token=${token}`;
}

async function main() {
  const src = require('./image_urls.json');
  const outPath = path.join(__dirname, 'image_urls_storage.json');
  // Reanudar: conserva lo ya alojado para no repetir.
  const out = fs.existsSync(outPath) ? JSON.parse(fs.readFileSync(outPath, 'utf-8')) : {};
  let ok = 0, fail = 0, skip = 0;
  for (const category of Object.keys(src)) {
    out[category] = out[category] || {};
    for (const [slug, url] of Object.entries(src[category])) {
      if (out[category][slug]) { skip++; continue; }
      try {
        out[category][slug] = await hostOne(category, slug, url);
        ok++;
        process.stdout.write(`\r⬆️  alojadas ${ok} · saltadas ${skip} (${category}/${slug})...        `);
        await sleep(250); // throttle anti-429
      } catch (e) {
        fail++;
        console.error(`\n  ❌ ${category}/${slug}: ${e.message}`);
      }
    }
  }
  fs.writeFileSync(
    path.join(__dirname, 'image_urls_storage.json'),
    JSON.stringify(out, null, 2));
  console.log(`\n✅ ${ok} imágenes en Storage.${fail ? ` ❌ ${fail} fallos.` : ''} `
    + '-> scripts/image_urls_storage.json');
}

main().then(() => process.exit(0)).catch((e) => {
  console.error('Error fatal:', e);
  process.exit(1);
});
