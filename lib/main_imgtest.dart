import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Diagnóstico aislado de carga de imágenes de Firebase Storage.
/// Ejecutar:  flutter run -t lib/main_imgtest.dart -d <device>
/// No requiere login ni partida. Si las imágenes salen -> la carga funciona.
void main() => runApp(const ImgTestApp());

const _badgeUrl =
    'https://firebasestorage.googleapis.com/v0/b/futko-battle.firebasestorage.app/o/question_images%2Fbadges%2Farsenal.png?alt=media&token=65a0055e-65cd-4945-8e37-98d7efb499d0';
const _playerUrl =
    'https://firebasestorage.googleapis.com/v0/b/futko-battle.firebasestorage.app/o/question_images%2Fsilhouettes%2Fpele.jpg?alt=media&token=7fe17e06-b1c2-4e16-b873-cd174c338158';

class ImgTestApp extends StatelessWidget {
  const ImgTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF121414),
        appBar: AppBar(title: const Text('Test imágenes Storage')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _Tile(label: 'CachedNetworkImage — escudo', url: _badgeUrl, cached: true),
            _Tile(label: 'CachedNetworkImage — jugador', url: _playerUrl, cached: true),
            _Tile(label: 'Image.network — escudo', url: _badgeUrl, cached: false),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.url, required this.cached});
  final String label;
  final String url;
  final bool cached;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          height: 200,
          color: Colors.white,
          alignment: Alignment.center,
          child: cached
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  placeholder: (c, u) => const CircularProgressIndicator(),
                  errorWidget: (c, u, e) =>
                      Text('ERROR cached:\n$e', textAlign: TextAlign.center),
                )
              : Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) =>
                      Text('ERROR network:\n$e', textAlign: TextAlign.center),
                ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
