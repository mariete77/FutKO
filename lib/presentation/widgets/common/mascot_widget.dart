import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../../core/theme/app_colors.dart';

/// Mascot states for the Rive animation
enum MascotState {
  idle,
  happy,
  excited,
  thinking,
  celebrating,
  sad,
}

/// Rive mascot widget for FutKO
/// Displays an animated football character that reacts to game events
class MascotWidget extends StatefulWidget {
  final MascotState state;
  final double size;
  final VoidCallback? onTap;

  const MascotWidget({
    super.key,
    this.state = MascotState.idle,
    this.size = 120,
    this.onTap,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget> {
  Artboard? _artboard;
  StateMachineController? _controller;
  SMITrigger? _triggerHappy;
  SMITrigger? _triggerExcited;
  SMITrigger? _triggerThinking;
  SMITrigger? _triggerCelebrating;
  SMITrigger? _triggerSad;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    try {
      final file = await RiveFile.asset('assets/rive/mascot.riv');
      final artboard = file.mainArtboard.instance();
      
      var controller = StateMachineController.fromArtboard(artboard, 'State Machine');
      if (controller != null) {
        artboard.addController(controller);
        _triggerHappy = controller.findSMI('happy');
        _triggerExcited = controller.findSMI('excited');
        _triggerThinking = controller.findSMI('thinking');
        _triggerCelebrating = controller.findSMI('celebrating');
        _triggerSad = controller.findSMI('sad');
      }

      setState(() {
        _artboard = artboard;
        _controller = controller;
      });
    } catch (e) {
      // Fallback if Rive file doesn't exist
      debugPrint('Error loading mascot: $e');
    }
  }

  @override
  void didUpdateWidget(MascotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      _triggerAnimation(widget.state);
    }
  }

  void _triggerAnimation(MascotState state) {
    switch (state) {
      case MascotState.happy:
        _triggerHappy?.fire();
        break;
      case MascotState.excited:
        _triggerExcited?.fire();
        break;
      case MascotState.thinking:
        _triggerThinking?.fire();
        break;
      case MascotState.celebrating:
        _triggerCelebrating?.fire();
        break;
      case MascotState.sad:
        _triggerSad?.fire();
        break;
      case MascotState.idle:
        // Idle is the default state
        break;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_artboard == null) {
      // Fallback widget while loading or if Rive fails
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.yellow500,
              width: 3,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.sports_soccer,
              size: widget.size * 0.5,
              color: AppColors.yellow500,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _triggerHappy?.fire();
        widget.onTap?.call();
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Rive(artboard: _artboard!),
      ),
    );
  }
}

/// Floating mascot button that appears in game screens
class FloatingMascot extends StatelessWidget {
  final MascotState state;
  final VoidCallback? onTap;

  const FloatingMascot({
    super.key,
    this.state = MascotState.idle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Hero(
        tag: 'mascot',
        child: Material(
          color: Colors.transparent,
          child: MascotWidget(
            state: state,
            size: 80,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
