import 'package:flutter/material.dart';

class AnimationApp {
  static final AnimationApp i = AnimationApp._internal();

  AnimationApp._internal();

  AnimationController _createController(
      {required TickerProvider vsync, required Duration duration}) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    );
  }

  AnimationController createControllerA(
      {required TickerProvider vsync, required Duration duration}) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    );
  }

  void disposeController(AnimationController controller) {
    if (controller.isAnimating) {
      controller.stop();
    }
    controller.dispose();
  }

  void _startAnimation({
    required AnimationController controller,
    bool repeat = false,
  }) {
    controller.forward();
    if (repeat) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    }
  }

  void startAnimation({
    required AnimationController controller,
    bool repeat = false,
  }) {
    controller.forward();
    if (repeat) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    }
  }

  // Attention Seekers
  Widget bounce(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2)
          .chain(CurveTween(curve: Curves.bounceInOut))
          .animate(controller),
      child: child,
    );
  }

  // Flash animation: Fades in and out

  //
  Widget flash(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return FadeTransition(
      opacity: TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      ]).animate(controller),
      child: child,
    );
  }

  Widget pulse(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.1)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(controller),
      child: child,
    );
  }

  Widget rubberBand(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
      ]).animate(controller),
      child: child,
    );
  }

  Widget shakeX(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(controller.value * 10, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget shakeY(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, controller.value * 10),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget headShake(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 0.3,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget swing(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 0.5,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget tada(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
      ]).animate(controller),
      child: child,
    );
  }

  Widget wobble(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(controller.value * 5, 0),
          child: Transform.rotate(
            angle: controller.value * 0.1,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget jello(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.skewX(controller.value * 0.2),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget heartBeat(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
      ]).animate(controller),
      child: child,
    );
  }

  // Back Entrances
  Widget backInDown(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(controller),
      child: child,
    );
  }

  Widget backInLeft(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controller),
      child: child,
    );
  }

  Widget backInRight(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(controller),
      child: child,
    );
  }

  Widget backInUp(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(controller),
      child: child,
    );
  }

  // Back Exits
  Widget backOutDown(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(0, 1)).animate(controller),
      child: child,
    );
  }

  Widget backOutLeft(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(-1, 0)).animate(controller),
      child: child,
    );
  }

  Widget backOutRight(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(1, 0)).animate(controller),
      child: child,
    );
  }

  Widget backOutUp(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(0, -1)).animate(controller),
      child: child,
    );
  }

  // Bouncing Entrances
  Widget bounceIn(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.3, end: 1.0)
          .chain(CurveTween(curve: Curves.bounceOut))
          .animate(controller),
      child: child,
    );
  }

  Widget bounceInDown(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(controller),
      child: bounceIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget bounceInLeft(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controller),
      child: bounceIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget bounceInRight(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(controller),
      child: bounceIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget bounceInUp(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(controller),
      child: bounceIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  // Bouncing Exits
  Widget bounceOut(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 0.3)
          .chain(CurveTween(curve: Curves.bounceIn))
          .animate(controller),
      child: child,
    );
  }

  Widget bounceOutDown(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(0, 1)).animate(controller),
      child: bounceOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget bounceOutLeft(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(-1, 0)).animate(controller),
      child: bounceOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget bounceOutRight(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(1, 0)).animate(controller),
      child: bounceOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget bounceOutUp(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(0, -1)).animate(controller),
      child: bounceOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  // Fading Entrances
  Widget fadeIn(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: child,
    );
  }

  Widget fadeInDown(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(controller),
      child: fadeIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget fadeInLeft(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controller),
      child: fadeIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget fadeInRight(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(controller),
      child: fadeIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget fadeInUp(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(controller),
      child: fadeIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  // Fading Exits
  Widget fadeOut(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
      child: child,
    );
  }

  Widget fadeOutDown(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(0, 1)).animate(controller),
      child: fadeOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget fadeOutLeft(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(-1, 0)).animate(controller),
      child: fadeOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget fadeOutRight(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(1, 0)).animate(controller),
      child: fadeOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget fadeOutUp(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position:
          Tween(begin: Offset(0, 0), end: Offset(0, -1)).animate(controller),
      child: fadeOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  // Flippers
  Widget flip(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: child,
    );
  }

  Widget flipInX(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(controller.value * 3.1416),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipInY(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(controller.value * 3.1416),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipOutX(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(controller.value * 3.1416),
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipOutY(
      {required Widget child,
      required TickerProvider vsync,
      Duration duration = const Duration(seconds: 1),
      bool repeat = false}) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(controller.value * 3.1416),
          child: child,
        );
      },
      child: child,
    );
  }

// Lightspeed
  Widget lightSpeedInRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: child,
      ),
    );
  }

  Widget lightSpeedInLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: child,
      ),
    );
  }

  Widget lightSpeedOutRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 0))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
        child: child,
      ),
    );
  }

  Widget lightSpeedOutLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
        child: child,
      ),
    );
  }

// Rotating Entrances
  Widget rotateIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: -1.0, end: 0.0).animate(controller),
      child: child,
    );
  }

  Widget rotateInDownLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: -1.0, end: 0.0).animate(controller),
      child: child,
    );
  }

  Widget rotateInUpRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 1.0, end: 0.0).animate(controller),
      child: child,
    );
  }

// Rotating Exits
  Widget rotateOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: child,
    );
  }

  Widget rotateOutDownLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: child,
    );
  }

  Widget rotateOutUpRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: -1.0).animate(controller),
      child: child,
    );
  }

// Specials
  Widget hinge({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: child,
    );
  }

  Widget jackInTheBox({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: child,
    );
  }

  Widget rollIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(controller),
      child: RotationTransition(
          turns: Tween(begin: -1.0, end: 0.0).animate(controller),
          child: child),
    );
  }

  Widget rollOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 0))
          .animate(controller),
      child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(controller), child: child),
    );
  }

// Zooming Entrances
  Widget zoomIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.3, end: 1.0).animate(controller),
      child: child,
    );
  }

  Widget zoomInDown({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
          .animate(controller),
      child: zoomIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget zoomInLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(controller),
      child: zoomIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget zoomInRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(controller),
      child: zoomIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget zoomInUp({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
          .animate(controller),
      child: zoomIn(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

// Zooming Exits
  Widget zoomOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 0.3).animate(controller),
      child: child,
    );
  }

  Widget zoomOutDown({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1))
          .animate(controller),
      child: zoomOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget zoomOutLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
          .animate(controller),
      child: zoomOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget zoomOutRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 0))
          .animate(controller),
      child: zoomOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

  Widget zoomOutUp({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
          .animate(controller),
      child: zoomOut(
          child: child, vsync: vsync, duration: duration, repeat: repeat),
    );
  }

// Sliding Entrances
  Widget slideInDown({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
          .animate(controller),
      child: child,
    );
  }

  Widget slideInLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(controller),
      child: child,
    );
  }

  Widget slideInRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(controller),
      child: child,
    );
  }

  Widget slideInUp({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
          .animate(controller),
      child: child,
    );
  }

// Sliding Exits
  Widget slideOutDown({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1))
          .animate(controller),
      child: child,
    );
  }

  Widget slideOutLeft({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
          .animate(controller),
      child: child,
    );
  }

  Widget slideOutRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 0))
          .animate(controller),
      child: child,
    );
  }

  Widget slideOutUp({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
          .animate(controller),
      child: child,
    );
  }
  // AnimationApp

// Zoom and Rotate In
  Widget zoomRotateIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: RotationTransition(
        turns: Tween(begin: -1.0, end: 0.0).animate(controller),
        child: child,
      ),
    );
  }

// Bounce and Fade Out
  Widget bounceFadeOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.3)
            .chain(CurveTween(curve: Curves.bounceInOut))
            .animate(controller),
        child: child,
      ),
    );
  }

// Slide Left with 3D Rotate
  Widget slideRotate3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(controller.value * 3.1416)
            ..translate(controller.value * 300),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // مجموعة جديدة من الأنيميشنات

  // Shake with Rotation
  Widget shakeWithRotate({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(controller.value * 10, 0),
          child: Transform.rotate(
            angle: controller.value * 0.3,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // 3D Flip with Scale
  Widget flipScale3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(controller.value * 3.1416),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  // Custom Path Animation
  Widget customPathAnimation({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(controller.value * 100, controller.value * 50),
          child: child,
        );
      },
      child: child,
    );
  }
  // Attention Seekers (مكمل الأنيميشنات الحالية)
  // مثال لمزيد من الأنيميشنات

  // Zoom and Shake
  Widget zoomAndShake({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2).animate(controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(controller.value * 5, controller.value * 5),
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  // Rotate with Fade In
  Widget rotateFadeIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: child,
      ),
    );
  }

  // 3D Rotation along Z Axis
  Widget rotateZ3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationZ(controller.value * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // Custom Bounce Path
  // Widget customBouncePath({
  //   required Widget child,
  //   required TickerProvider vsync,
  //   Duration duration = const Duration(seconds: 2),
  //   bool repeat = false,
  // }) {
  //   AnimationController controller =
  //   _createController(vsync: vsync, duration: duration);
  //   _startAnimation(controller: controller, repeat: repeat);
  //
  //   return AnimatedBuilder(
  //     animation: controller,
  //     builder: (context, child) {
  //       return Transform.translate(
  //         offset: Offset(controller.value * 100, controller.value * 150)
  //           ..rotateZ(controller.value * 2 * 3.1416),
  //         child: child,
  //       );
  //     },
  //     child: child,
  //   );
  // }

  // Translation with Scaling
  Widget translateAndScale({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.5).animate(controller),
      child: Transform.translate(
        offset: Offset(controller.value * 50, 0),
        child: child,
      ),
    );
  }

  // Rotate with Elastic In Curve
  Widget rotateElastic({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.elasticIn))
          .animate(controller),
      child: child,
    );
  }

  // Zoom, Fade, and Rotate
  Widget zoomFadeRotate({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: RotationTransition(
          turns: Tween(begin: -0.5, end: 0.0).animate(controller),
          child: child,
        ),
      ),
    );
  }

  // Multiple Rotation in X and Y
  Widget rotateXY({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationX(controller.value * 3.1416)
            ..rotateY(controller.value * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide, Fade, and Rotate Together
  Widget slideFadeRotate({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: RotationTransition(
          turns: Tween(begin: -1.0, end: 0.0).animate(controller),
          child: child,
        ),
      ),
    );
  }

  // Shake, Rotate, and Scale
  Widget shakeRotateScale({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(controller.value * 5, 0),
          child: Transform.rotate(
            angle: controller.value * 3.1416,
            child: ScaleTransition(
              scale: Tween(begin: 0.5, end: 1.0).animate(controller),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  // Zoom, Slide, and Skew
  Widget zoomSlideSkew({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
            .animate(controller),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.skewX(controller.value * 0.5),
              child: child,
            );
          },
          child: child,
        ),
      ),
    );
  }

  // Rotation and Zigzag Translation
  Widget rotateZigzag({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              controller.value * 100 * (controller.value % 2 == 0 ? 1 : -1),
              controller.value * 50),
          child: RotationTransition(
            turns: Tween(begin: -1.0, end: 1.0).animate(controller),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Flip with Fade Out
  Widget flipFadeOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
        child: child,
      ),
    );
  }

  // Expand and Contract Animation
  Widget expandContract({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.5)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(controller),
      child: child,
    );
  }

  // Slide and Rotate 360 Degrees
  Widget slideRotate360({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(controller),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: child,
      ),
    );
  }

  // 3D Flip and Slide
  Widget flip3DAndSlide({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 0))
          .animate(controller),
      child: Transform(
        transform: Matrix4.rotationY(controller.value * 3.1416),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  // Zoom Out with Rotation
  Widget zoomOutRotate({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 0.0).animate(controller),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: child,
      ),
    );
  }

  // Slide, Fade, and Bounce Together
  Widget slideFadeBounce({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2)
              .chain(CurveTween(curve: Curves.bounceInOut))
              .animate(controller),
          child: child,
        ),
      ),
    );
  }

  // Zoom, Slide, and Rotate in 3D
  Widget zoomSlideRotate3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
            .animate(controller),
        child: Transform(
          transform: Matrix4.rotationY(controller.value * 3.1416),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  // Slide and Expand with Rotation
  Widget slideExpandRotate({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(controller),
      child: ScaleTransition(
        scale: Tween(begin: 0.5, end: 1.0).animate(controller),
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(controller),
          child: child,
        ),
      ),
    );
  }

  // Spiral In and Scale
  Widget spiralInScale({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 2.0).animate(controller),
      child: ScaleTransition(
        scale: Tween(begin: 0.5, end: 1.0).animate(controller),
        child: child,
      ),
    );
  }

  // Rotate and Skew with Bounce
  Widget rotateSkewBounce({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: Transform(
        transform: Matrix4.skewX(controller.value * 0.5),
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2)
              .chain(CurveTween(curve: Curves.bounceInOut))
              .animate(controller),
          child: child,
        ),
      ),
    );
  }

  // Flip, Slide, and Skew Animation
  Widget flipSlideSkew({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
            .animate(controller),
        child: Transform(
          transform: Matrix4.skewY(controller.value * 0.5),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  // Scale with Bounce and Fade
  Widget scaleBounceFade({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.5)
            .chain(CurveTween(curve: Curves.bounceInOut))
            .animate(controller),
        child: child,
      ),
    );
  }

  // 3D Zoom with Rotate
  Widget zoom3DRotate({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 2.0).animate(controller),
        child: child,
      ),
    );
  }

  // Rotate 3D around X-axis
  Widget rotate3DX({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationX(controller.value * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // Rotate 3D around Y-axis with zoom
  Widget rotate3DYZoom({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(controller.value * 3.1416)
            ..scale(1 + controller.value),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // Rotate 3D around Z-axis with skew
  Widget rotate3DZSkew({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Create the matrix for skew transformation
        Matrix4 skewMatrix = Matrix4.identity();
        skewMatrix.setEntry(3, 2, 0.002); // Add depth (perspective)
        skewMatrix.setEntry(0, 1, controller.value * 0.5); // Skew on X axis

        return Transform(
          transform: skewMatrix..rotateZ(controller.value * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // 3D Flip with depth effect
  Widget flip3DWithDepth({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(controller.value * 3.1416)
            ..setEntry(3, 2, 0.002), // Add depth perspective
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // Swing with 3D rotation
  Widget swing3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(controller.value * 1.5 * 3.1416),
          alignment: Alignment.bottomCenter,
          child: child,
        );
      },
      child: child,
    );
  }

  // Bounce with 3D rotate on X and Y axis
  Widget bounce3DRotateXY({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2)
          .chain(CurveTween(curve: Curves.bounceInOut))
          .animate(controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationX(controller.value * 3.1416)
              ..rotateY(controller.value * 3.1416),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  // Slide with depth scaling
  Widget slideDepthScale({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(controller),
      child: ScaleTransition(
        scale: Tween(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(controller),
        child: child,
      ),
    );
  }

  // Rotate and Scale with perspective
  Widget rotateScale3DPerspective({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationX(controller.value * 3.1416)
            ..rotateY(controller.value * 3.1416)
            ..scale(1.0 + controller.value)
            ..setEntry(3, 2, 0.002), // Perspective for depth
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // 3D Zoom with Flip and Rotate
  Widget zoomFlipRotate3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 2.0).animate(controller),
        child: Transform(
          transform: Matrix4.rotationY(controller.value * 3.1416)
            ..rotateX(controller.value * 3.1416)
            ..setEntry(3, 2, 0.002), // Depth perspective
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  // 3D Skew and Slide
  Widget skewSlide3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.skewX(controller.value * 0.5)
            ..rotateY(controller.value * 3.1416),
          alignment: Alignment.center,
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                .animate(controller),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Spiral 3D Rotate with Scale
  Widget spiral3DScale({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(controller.value * 3.1416)
              ..rotateZ(controller.value * 3.1416)
              ..setEntry(3, 2, 0.002), // Perspective for depth
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  Widget rotate3DPulse({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Create a rotation matrix for 3D rotation
        Matrix4 rotationMatrix = Matrix4.identity();
        rotationMatrix.setEntry(3, 2, 0.002); // Add perspective depth
        rotationMatrix
            .rotateX(controller.value * 2 * 3.1416); // Rotate on X axis
        rotationMatrix
            .rotateY(controller.value * 2 * 3.1416); // Rotate on Y axis

        return Transform(
          transform: rotationMatrix,
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.2)
                .animate(controller), // Add pulsing scale
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget flipZigzagPath({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Create the matrix for 3D flip rotation
        Matrix4 flipMatrix = Matrix4.identity();
        flipMatrix.setEntry(3, 2, 0.002); // Add perspective depth
        flipMatrix.rotateX(controller.value * 2 * 3.1416); // Flip on X axis

        return Transform(
          transform: flipMatrix,
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(
              controller.value *
                  200 *
                  (controller.value % 2 == 0 ? 1 : -1), // Zigzag path
              controller.value * 100,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget flipX360({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()..rotateX(controller.value * 2 * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipY360({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()..rotateY(controller.value * 2 * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipScale360({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(controller.value * 2 * 3.1416)
            ..scale(controller.value + 0.5),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget roll360({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()..rotateZ(controller.value * 2 * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget shake3DDepth({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Depth
            ..translate(controller.value * 30, 0),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget scaleIn3DRotate({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateY(controller.value * 3.1416)
            ..scale(controller.value),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipZoomOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(controller.value * 2 * 3.1416)
            ..scale(1 - controller.value * 0.5),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget rotate3DFade({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateY(controller.value * 2 * 3.1416),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  Widget rollBounce3D({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateZ(controller.value * 3.1416)
            ..translate(0, (1 - controller.value) * 30),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipXOpacity({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.5).animate(controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()..rotateX(controller.value * 3.1416),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  Widget flipYSkew({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()..rotateY(controller.value * 3.1416),
          // ..skewX(controller.value * 0.5),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget flipZigzag({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller = _createController(
      vsync: vsync,
      duration: duration,
    );
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(controller.value * 2 * 3.1416)
            ..translate(
                (controller.value % 2 == 0 ? 1 : -1) * controller.value * 100,
                0),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  // Fade In Top
  Widget fadeInTop({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
        child: child,
      ),
    );
  }

// Fade Out Bottom
  Widget fadeOutBottom({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1))
          .animate(controller),
      child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
        child: child,
      ),
    );
  }

// Bounce Zoom In
  Widget bounceZoomIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.3, end: 1.0)
          .chain(CurveTween(curve: Curves.bounceOut))
          .animate(controller),
      child: child,
    );
  }

// Roll In Right
  Widget rollInRight({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
          .animate(controller),
      child: RotationTransition(
        turns: Tween(begin: -1.0, end: 0.0).animate(controller),
        child: child,
      ),
    );
  }

// Flip Y Zoom In
  Widget flipYZoomIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return ScaleTransition(
      scale: Tween(begin: 0.3, end: 1.0).animate(controller),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(controller.value * 3.1416),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  // One after One Rotate In
  Widget oaoRotateIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: -1.0, end: 0.0).animate(controller),
      child: child,
    );
  }

// One after One Rotate Out
  Widget oaoRotateOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: child,
    );
  }

// One after One Rotate X In
  Widget oaoRotateXIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationX(controller.value * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

// One after One Rotate X Out
  Widget oaoRotateXOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationX(controller.value * -3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

// One after One Rotate Y In
  Widget oaoRotateYIn({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(controller.value * 3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

// One after One Rotate Y Out
  Widget oaoRotateYOut({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(controller.value * -3.1416),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget warpPortalEffect({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..scale(controller.value) // تكبير العنصر
            ..rotateY(controller.value * 3.1416), // تدوير حول المحور Y
          alignment: Alignment.center,
          child: Opacity(
            opacity: 1.0 - controller.value, // تلاشي العنصر
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget quantumLeapEffect({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..scale(controller.value * 1.5) // تكبير سريع
            ..rotateX(controller.value * 3.1416), // تدوير حول المحور X
          alignment: Alignment.center,
          child: Opacity(
            opacity: controller.value, // تلاشي العنصر
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget matrixRotation({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(controller.value * 3.1416) // تدوير حول المحور X
            ..rotateY(controller.value * 3.1416), // تدوير حول المحور Y
          alignment: Alignment.center,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.green.withOpacity(controller.value), // تأثير ألوان ماتريكس
              BlendMode.modulate,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget timeFreezeEffect({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value <= 0.5
            ? controller.value * 2 // تباطؤ الحركة في النصف الأول
            : (1 - controller.value) * 2; // تسارع في النصف الثاني
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget blackHolePullEffect({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(controller.value * 50,
                controller.value * 50) // سحب نحو "ثقب أسود"
            ..scale(1 - controller.value), // تقليص العنصر
          alignment: Alignment.center,
          child: Opacity(
            opacity: 1.0 - controller.value, // تلاشي العنصر
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget explosionRebuildEffect({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 3),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final explode = controller.value < 0.5;
        final scaleValue =
            explode ? controller.value * 4 : (1 - controller.value) * 4;
        return Transform.scale(
          scale: scaleValue, // انفجار العنصر ثم إعادة بناءه
          child: Opacity(
            opacity:
                explode ? 0 : controller.value, // تلاشي العنصر خلال الانفجار
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget twistVortexEffect({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateZ(controller.value * 3.1416) // دوران حول المحور Z
            ..scale(1 + controller.value), // زوم داخلي وخارجي
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget futuristicGridShift({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(controller.value * 100, controller.value * 100,
                controller.value * 200), // نقل على المحور Z
          alignment: Alignment.center,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.blue.withOpacity(controller.value), // تأثير ليزري
              BlendMode.modulate,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget parallelUniverseShift({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final colorShift = Color.lerp(
            Colors.red, Colors.blue, controller.value); // تغيير اللون
        return Transform(
          transform: Matrix4.identity()
            ..translate(controller.value * 100,
                controller.value * 100), // التحرك خلال "عوالم موازية"
          alignment: Alignment.center,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              colorShift ?? Colors.white,
              BlendMode.modulate,
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget hyperJumpZoom({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.value < 0.5
              ? controller.value * 3
              : (1 - controller.value) * 3, // تكبير سريع ثم تصغير
          child: child,
        );
      },
      child: child,
    );
  }

  Widget lightSpeedWarp({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 1),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(controller.value * 500, 0, 0), // تحرك بسرعة الضوء
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget dimensionFlip({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(controller.value * 3.1416)
            ..rotateY(controller.value * 3.1416)
            ..rotateZ(controller.value * 3.1416), // تقلب على جميع المحاور
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget ghostPhaseEffect({
    required Widget child,
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    AnimationController controller =
        _createController(vsync: vsync, duration: duration);
    _startAnimation(controller: controller, repeat: repeat);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: controller.value < 0.5
              ? controller.value * 2
              : (1 - controller.value) * 2, // تلاشي وظهور العنصر كـ "شبح"
          child: child,
        );
      },
      child: child,
    );
  }
}
