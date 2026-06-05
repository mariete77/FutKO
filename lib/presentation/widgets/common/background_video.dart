import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';

/// Looping muted background video used behind login & home screens.
/// Falls back to the dark stadium background while the video initializes.
class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({
    super.key,
    this.asset = 'assets/Fondo.mp4',
    this.overlayOpacity = 0.45,
  });

  final String asset;
  final double overlayOpacity;

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        _controller.play();
        setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.background),
          if (_ready)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          Container(color: Colors.black.withOpacity(widget.overlayOpacity)),
        ],
      ),
    );
  }
}
