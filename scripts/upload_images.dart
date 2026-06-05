// FutKO — Upload Images to Firebase Storage
//
// Usage:
//   dart run scripts/upload_images.dart --input ./assets/images
//
// Expected input directory structure (matches storage.rules):
//   assets/images/
//     badges/           ← Team badge/crest PNGs
//       real_madrid.png
//       fc_barcelona.png
//       ...
//     stadiums/         ← Stadium photos JPG
//       santiago_bernabeu.jpg
//       camp_nou.jpg
//       ...
//     silhouettes/      ← Player silhouette PNGs (for playerImage questions)
//       lionel_messi.png
//       cristiano_ronaldo.png
//       ...
//     competitions/     ← Competition logos PNGs
//       fifa_world_cup.png
//       uefa_champions_league.png
//       ...
//
// Prerequisites:
//   1. Firebase Storage activated in Firebase Console.
//   2. Firebase Admin SDK credentials (service account JSON).
//   3. The storage.rules allow NO client writes — use this script or
//      Firebase Console to upload.
//
// Alternatively, use `firebase storage:upload` or gsutil:
//   gsutil -m cp -r assets/images/badges/* gs://geoquiz-7790d.appspot.com/badges/
//   gsutil -m cp -r assets/images/stadiums/* gs://geoquiz-7790d.appspot.com/stadiums/
//   gsutil -m cp -r assets/images/silhouettes/* gs://geoquiz-7790d.appspot.com/silhouettes/
//   gsutil -m cp -r assets/images/competitions/* gs://geoquiz-7790d.appspot.com/competitions/

import 'dart:io';

const _bucket = 'geoquiz-7790d.appspot.com';

const _categories = {
  'badges': '.png',
  'stadiums': '.jpg',
  'silhouettes': '.png',
  'competitions': '.png',
};

void main(List<String> args) async {
  if (args.isEmpty || args.contains('--help')) {
    _printHelp();
    return;
  }

  String? inputDir;
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--input' && i + 1 < args.length) {
      inputDir = args[i + 1];
    }
  }

  if (inputDir == null) {
    print('❌ Falta --input <directorio>');
    _printHelp();
    exit(1);
  }

  final input = Directory(inputDir);
  if (!await input.exists()) {
    print('❌ Directorio no encontrado: $inputDir');
    exit(1);
  }

  print('''
╔══════════════════════════════════════════════╗
║  FutKO — Upload de Imágenes a Storage       ║
║  Bucket: $_bucket     ║
╚══════════════════════════════════════════════╝
''');

  // Check what we have
  for (final entry in _categories.entries) {
    final category = entry.key;
    final extension = entry.value;
    final categoryDir = Directory('$inputDir/$category');

    if (!await categoryDir.exists()) {
      print('⚠️  Directorio no encontrado: $categoryDir');
      print('   Créalo y coloca archivos *$extension dentro.');
      continue;
    }

    final files = await categoryDir
        .list()
        .where((f) => f.path.endsWith(extension))
        .toList();

    if (files.isEmpty) {
      print('⚠️  Sin archivos *$extension en $categoryDir');
      continue;
    }

    print('📁 $category/: ${files.length} archivos');

    // Print gsutil commands for upload
    for (final file in files) {
      final fileName = file.uri.pathSegments.last;
      final dest = 'gs://$_bucket/$category/$fileName';
      print('   gsutil cp ${file.path} $dest');
    }
  }

  print('''

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Para subir con gsutil (recomendado):
''');

  for (final entry in _categories.entries) {
    final category = entry.key;
    final extension = entry.value;
    final categoryDir = '$inputDir/$category';
    print(
        '  gsutil -m cp $categoryDir/*$extension gs://$_bucket/$category/');
  }

  print('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Para subir desde Firebase Console:
  1. Ir a Storage en Firebase Console
  2. Crear las carpetas: badges/, stadiums/, silhouettes/, competitions/
  3. Subir archivos manualmente

⚠️  IMPORTANTE: Las storage.rules deniegan escritura desde el cliente.
    Solo el Admin SDK o gsutil pueden subir archivos.
''');
}

void _printHelp() {
  print('''
FutKO — Upload de Imágenes a Firebase Storage

Uso:
  dart run scripts/upload_images.dart --input <directorio>

Opciones:
  --input <dir>   Directorio base con las imágenes (default: ./assets/images)
  --help          Mostrar esta ayuda

Estructura esperada:
  <input>/
    badges/*.png          → /badges/{slug}.png
    stadiums/*.jpg        → /stadiums/{slug}.jpg
    silhouettes/*.png     → /silhouettes/{slug}.png
    competitions/*.png    → /competitions/{slug}.png

Ejemplo con gsutil:
  gsutil -m cp -r assets/images/badges/* gs://$_bucket/badges/
''');
}
