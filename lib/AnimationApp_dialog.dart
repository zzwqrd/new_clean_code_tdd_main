import 'package:flutter/material.dart';

class AnimationappDialog extends StatefulWidget {
  final Widget child;
  final String animationType; // نوع الرسوم المتحركة
  final Duration duration;
  final bool repeat;

  const AnimationappDialog({
    Key? key,
    required this.child,
    required this.animationType, // تمرير نوع الرسوم المتحركة
    this.duration = const Duration(seconds: 1),
    this.repeat = false,
  }) : super(key: key);

  @override
  _AnimationappDialogState createState() => _AnimationappDialogState();
}

class _AnimationappDialogState extends State<AnimationappDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward();
    if (widget.repeat) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    }
  }

  // Bounce Animation Widget
  Widget _buildBounceAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2)
          .chain(CurveTween(curve: Curves.bounceInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Flash Animation Widget
  Widget _buildFlashAnimation() {
    return FadeTransition(
      opacity: TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      ]).animate(_controller),
      child: widget.child,
    );
  }

  // Pulse Animation Widget
  Widget _buildPulseAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.1)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Shake X Animation Widget
  Widget _buildShakeXAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_controller.value * 10, 0),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  // Shake Y Animation Widget
  Widget _buildShakeYAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 10),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  // Head Shake Animation Widget
  Widget _buildHeadShakeAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 0.1,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  // Zoom In Animation Widget
  Widget _buildZoomInAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Zoom Out Animation Widget
  Widget _buildZoomOutAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 0.5)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Slide from left animation
  Widget _buildSlideFromLeftAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-100 * (1 - _controller.value), 0),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  // Slide from right animation
  Widget _buildSlideFromRightAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - _controller.value), 0),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  Widget _buildAnimation() {
    // اختيار الرسوم المتحركة بناءً على نوع الرسوم المتحركة باستخدام switch
    switch (widget.animationType) {
      case 'bounce':
        return _buildBounceAnimation();
      case 'flash':
        return _buildFlashAnimation();
      case 'pulse':
        return _buildPulseAnimation();
      case 'shakeX':
        return _buildShakeXAnimation();
      case 'shakeY':
        return _buildShakeYAnimation();
      case 'headShake':
        return _buildHeadShakeAnimation();
      case 'zoomIn':
        return _buildZoomInAnimation();
      case 'zoomOut':
        return _buildZoomOutAnimation();
      case 'slideFromLeft':
        return _buildSlideFromLeftAnimation();
      case 'slideFromRight':
        return _buildSlideFromRightAnimation();
      default:
        return widget.child;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimation();
  }
}
