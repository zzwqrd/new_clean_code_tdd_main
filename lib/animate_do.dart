import 'package:flutter/material.dart';

class AnimateDo extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final bool repeat;
  final bool reverse;
  final Curve curve;
  final AnimationType animationType;

  const AnimateDo({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.repeat = false,
    this.reverse = false,
    this.curve = Curves.easeInOut,
    required this.animationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AnimationHandler(
      child: child,
      duration: duration,
      repeat: repeat,
      reverse: reverse,
      curve: curve,
      animationType: animationType,
    );
  }
}

enum AnimationType {
  // Attention Seekers
  bounce,
  flash,
  pulse,
  rubberBand,
  shakeX,
  shakeY,
  headShake,
  swing,
  tada,
  wobble,
  jello,
  heartBeat,

  // Back Entrances
  backInDown,
  backInLeft,
  backInRight,
  backInUp,

  // Back Exits
  backOutDown,
  backOutLeft,
  backOutRight,
  backOutUp,

  // Bouncing Entrances
  bounceIn,
  bounceInDown,
  bounceInLeft,
  bounceInRight,
  bounceInUp,

  // Bouncing Exits
  bounceOut,
  bounceOutDown,
  bounceOutLeft,
  bounceOutRight,
  bounceOutUp,

  // Fading Entrances
  fadeIn,
  fadeInDown,
  fadeInDownBig,
  fadeInLeft,
  fadeInLeftBig,
  fadeInRight,
  fadeInRightBig,
  fadeInUp,
  fadeInUpBig,
  fadeInTopLeft,
  fadeInTopRight,
  fadeInBottomLeft,
  fadeInBottomRight,

  // Fading Exits
  fadeOut,
  fadeOutDown,
  fadeOutDownBig,
  fadeOutLeft,
  fadeOutLeftBig,
  fadeOutRight,
  fadeOutRightBig,
  fadeOutUp,
  fadeOutUpBig,
  fadeOutTopLeft,
  fadeOutTopRight,
  fadeOutBottomLeft,
  fadeOutBottomRight,

  // Flippers
  flip,
  flipInX,
  flipInY,
  flipOutX,
  flipOutY,

  // Lightspeed
  lightSpeedInRight,
  lightSpeedInLeft,
  lightSpeedOutRight,
  lightSpeedOutLeft,

  // Rotating Entrances
  rotateIn,
  rotateInDownLeft,
  rotateInDownRight,
  rotateInUpLeft,
  rotateInUpRight,

  // Rotating Exits
  rotateOut,
  rotateOutDownLeft,
  rotateOutDownRight,
  rotateOutUpLeft,
  rotateOutUpRight,

  // Specials
  hinge,
  jackInTheBox,
  rollIn,
  rollOut,

  // Zooming Entrances
  zoomIn,
  zoomInDown,
  zoomInLeft,
  zoomInRight,
  zoomInUp,

  // Zooming Exits
  zoomOut,
  zoomOutDown,
  zoomOutLeft,
  zoomOutRight,
  zoomOutUp,

  // Sliding Entrances
  slideInDown,
  slideInLeft,
  slideInRight,
  slideInUp,

  // Sliding Exits
  slideOutDown,
  slideOutLeft,
  slideOutRight,
  slideOutUp,
}

class _AnimationHandler extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool repeat;
  final bool reverse;
  final Curve curve;
  final AnimationType animationType;

  const _AnimationHandler({
    Key? key,
    required this.child,
    required this.duration,
    required this.repeat,
    required this.reverse,
    required this.curve,
    required this.animationType,
  }) : super(key: key);

  @override
  State<_AnimationHandler> createState() => _AnimationHandlerState();
}

class _AnimationHandlerState extends State<_AnimationHandler>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.repeat) {
      _controller.repeat(reverse: widget.reverse);
    } else {
      _controller.forward();
    }

    _animation = _buildAnimation();
  }

  Animation<double> _buildAnimation() {
    switch (widget.animationType) {
      case AnimationType.fadeIn:
      case AnimationType.fadeOut:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
      case AnimationType.zoomIn:
      case AnimationType.zoomOut:
        return Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
      case AnimationType.bounce:
      case AnimationType.pulse:
        return TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
        ]).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
      case AnimationType.rotateIn:
      case AnimationType.rotateOut:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
      case AnimationType.slideInLeft:
      case AnimationType.slideOutRight:
        return Tween<double>(begin: -1.0, end: 0.0).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
      case AnimationType.lightSpeedInRight:
      case AnimationType.lightSpeedOutLeft:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
      case AnimationType.flip:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: widget.curve),
        );
      default:
        return CurvedAnimation(parent: _controller, curve: widget.curve);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        switch (widget.animationType) {
          case AnimationType.fadeIn:
            return Opacity(
              opacity: _animation.value,
              child: widget.child,
            );
          case AnimationType.fadeOut:
            return Opacity(
              opacity: 1 - _animation.value,
              child: widget.child,
            );
          case AnimationType.zoomIn:
            return Transform.scale(
              scale: _animation.value,
              child: widget.child,
            );
          case AnimationType.zoomOut:
            return Transform.scale(
              scale: 1.5 - _animation.value,
              child: widget.child,
            );
          case AnimationType.bounce:
            return Transform.scale(
              scale: _animation.value,
              child: widget.child,
            );
          case AnimationType.rotateIn:
            return Transform.rotate(
              angle: _animation.value * 2 * 3.1416,
              child: widget.child,
            );
          case AnimationType.rotateOut:
            return Transform.rotate(
              angle: (1 - _animation.value) * 2 * 3.1416,
              child: widget.child,
            );
          case AnimationType.slideInLeft:
            return Transform.translate(
              offset: Offset(_animation.value * -300, 0),
              child: widget.child,
            );
          case AnimationType.slideOutRight:
            return Transform.translate(
              offset: Offset(_animation.value * 300, 0),
              child: widget.child,
            );
          case AnimationType.lightSpeedInRight:
            return Transform.translate(
              offset: Offset(_animation.value * 300, 0),
              child: Opacity(
                opacity: _animation.value,
                child: widget.child,
              ),
            );
          case AnimationType.lightSpeedOutLeft:
            return Transform.translate(
              offset: Offset(_animation.value * -300, 0),
              child: Opacity(
                opacity: 1 - _animation.value,
                child: widget.child,
              ),
            );
          case AnimationType.flip:
            return Transform(
              transform: Matrix4.rotationY(_animation.value * 3.1416),
              alignment: Alignment.center,
              child: widget.child,
            );
          default:
            return widget.child;
        }
      },
    );
  }
}
