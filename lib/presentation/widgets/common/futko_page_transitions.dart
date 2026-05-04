import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Staggered Entrance Widgets ────────────────────────────────

/// Wrapper that groups [StaggeredItem] children for a staggered fade+slide entrance.
///
/// Usage:
/// ```dart
/// StaggeredEntrance(
///   staggerDelay: Duration(milliseconds: 100),
///   itemDuration: Duration(milliseconds: 450),
///   child: Column(children: [
///     StaggeredItem(index: 0, child: Widget1()),
///     StaggeredItem(index: 1, child: Widget2()),
///   ]),
/// )
/// ```
class StaggeredEntrance extends StatelessWidget {
  final Duration staggerDelay;
  final Duration itemDuration;
  final Widget child;

  const StaggeredEntrance({
    super.key,
    required this.staggerDelay,
    required this.itemDuration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => child;
}

/// A single staggered item that fades + slides in with a delay based on [index].
class StaggeredItem extends StatefulWidget {
  final int index;
  final Widget child;

  const StaggeredItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _offset = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

// ── Custom Page Transitions ───────────────────────────────────

/// Custom page transitions for FutKO app routes.
class FutKOTransitions {
  FutKOTransitions._();

  /// Splash screen — no animation, instant display.
  static CustomTransitionPage<void> splashPage({
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: ValueKey('splash'),
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  /// Fade + scale enter animation (used for login, home).
  static CustomTransitionPage<void> enterFadeScale({
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage<void>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Slide in from right (used for game, leaderboard, history).
  static CustomTransitionPage<void> slideInFromRight({
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage<void>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Slide in from bottom (used for matchmaking, multiplayer game).
  static CustomTransitionPage<void> slideInFromBottom({
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return CustomTransitionPage<void>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
      child: child,
    );
  }

  /// 3D slide from left — simulates a diagonal, football-like entrance.
  /// Creates a perspective effect with slight rotation on Y axis.
  static CustomTransitionPage<void> slideInFromLeft3D({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return CustomTransitionPage<void>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final slideTween = Tween<Offset>(
          begin: const Offset(-0.3, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        final rotateTween = Tween<double>(
          begin: -0.05,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return AnimatedBuilder(
          animation: curvedAnimation,
          builder: (context, child) {
            final value = curvedAnimation.value;
            return SlideTransition(
              position: slideTween.animate(curvedAnimation),
              child: Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotateTween.evaluate(curvedAnimation)),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              ),
            );
          },
          child: child,
        );
      },
      child: child,
    );
  }

  /// Football-style diagonal slide — enters from bottom-right with 3D perspective.
  /// Great for game results or match transitions.
  static CustomTransitionPage<void> diagonalFootball({
    required Widget child,
    Duration duration = const Duration(milliseconds: 450),
  }) {
    return CustomTransitionPage<void>(
      transitionDuration: duration,
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.15, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Cupertino-style horizontal slide — smooth iOS-like transition.
  /// Perfect for back navigation.
  static CustomTransitionPage<void> slideHorizontal({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    bool fromRight = true,
  }) {
    return CustomTransitionPage<void>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(fromRight ? 1.0 : -1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
      child: child,
    );
  }
}