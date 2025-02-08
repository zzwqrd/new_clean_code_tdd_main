import 'package:flutter/material.dart';

class AnimationappDialog extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool repeat;

  // Named constructor for Bounce animation
  const AnimationappDialog.bounce({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Flash animation
  const AnimationappDialog.flash({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Pulse animation
  const AnimationappDialog.pulse({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Shake X animation
  const AnimationappDialog.shakeX({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Shake Y animation
  const AnimationappDialog.shakeY({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Head Shake animation
  const AnimationappDialog.headShake({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Zoom In animation
  const AnimationappDialog.zoomIn({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Zoom Out animation
  const AnimationappDialog.zoomOut({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Slide from left animation
  const AnimationappDialog.slideFromLeft({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Named constructor for Slide from right animation
  const AnimationappDialog.slideFromRight({
    Key? key,
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) : this(
          key: key,
          child: child,
          duration: duration,
          repeat: repeat,
        );

  // Common properties used by all named constructors
  const AnimationappDialog({
    Key? key,
    required this.child,
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

  // Bounce Animation
  Widget _buildBounceAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2)
          .chain(CurveTween(curve: Curves.bounceInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Flash Animation
  Widget _buildFlashAnimation() {
    return FadeTransition(
      opacity: TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      ]).animate(_controller),
      child: widget.child,
    );
  }

  // Pulse Animation
  Widget _buildPulseAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.1)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Shake X Animation
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

  // Shake Y Animation
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

  // Head Shake Animation
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

  // Zoom In Animation
  Widget _buildZoomInAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Zoom Out Animation
  Widget _buildZoomOutAnimation() {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 0.5)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(_controller),
      child: widget.child,
    );
  }

  // Slide from Left Animation
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

  // Slide from Right Animation
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

  @override
  Widget build(BuildContext context) {
    if (widget.key == const Key('bounce')) {
      return _buildBounceAnimation();
    } else if (widget.key == const Key('flash')) {
      return _buildFlashAnimation();
    } else if (widget.key == const Key('pulse')) {
      return _buildPulseAnimation();
    } else if (widget.key == const Key('shakeX')) {
      return _buildShakeXAnimation();
    } else if (widget.key == const Key('shakeY')) {
      return _buildShakeYAnimation();
    } else if (widget.key == const Key('headShake')) {
      return _buildHeadShakeAnimation();
    } else if (widget.key == const Key('zoomIn')) {
      return _buildZoomInAnimation();
    } else if (widget.key == const Key('zoomOut')) {
      return _buildZoomOutAnimation();
    } else if (widget.key == const Key('slideFromLeft')) {
      return _buildSlideFromLeftAnimation();
    } else if (widget.key == const Key('slideFromRight')) {
      return _buildSlideFromRightAnimation();
    }
    return widget.child;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
