import 'package:flutter/material.dart';

class AnimationApp {
  static final AnimationApp i = AnimationApp._internal();

  AnimationApp._internal();

  // Fade Animation
  Widget fade({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
          child: child,
        );
      },
      duration: duration,
    );
  }

  // Scale Animation
  Widget scale({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
        return ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2).animate(controller),
          child: child,
        );
      },
      duration: duration,
    );
  }

  // Slide Animation (from left)
  Widget slideFromLeft({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
              .animate(controller),
          child: child,
        );
      },
      duration: duration,
    );
  }

  // Slide Animation (from right)
  Widget slideFromRight({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
              .animate(controller),
          child: child,
        );
      },
      duration: duration,
    );
  }

  // Rotate Animation
  Widget rotate({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
        return RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(controller),
          child: child,
        );
      },
      duration: duration,
    );
  }

  // Scale and Rotate Animation
  Widget scaleAndRotate({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
        return ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2).animate(controller),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(controller),
            child: child,
          ),
        );
      },
      duration: duration,
    );
  }

  // Flip Animation (Horizontal)
  Widget flipHorizontal({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
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
      },
      duration: duration,
    );
  }

  // Flip Animation (Vertical)
  Widget flipVertical({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
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
      },
      duration: duration,
    );
  }

  // Shake Animation
  Widget shake({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
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
      },
      duration: duration,
    );
  }

  // Bounce Animation
  Widget bounce({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      animationBuilder: (context, controller) {
        if (repeat) {
          _setupRepeat(controller);
        }
        return ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2)
              .chain(CurveTween(curve: Curves.bounceInOut))
              .animate(controller),
          child: child,
        );
      },
      duration: duration,
    );
  }

  Widget flash({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return FadeTransition(
          opacity: TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
            TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
          ]).animate(controller),
          child: child,
        );
      },
    );
  }

  Widget pulse({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.1).animate(controller),
          child: child,
        );
      },
    );
  }

  Widget shakeX({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
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
      },
    );
  }

  // Sliding Entrances
  Widget slideInDown({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
              .animate(controller),
          child: child,
        );
      },
    );
  }

  // Sliding Exits
  Widget slideOutUp({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
              .animate(controller),
          child: child,
        );
      },
    );
  }

  // **Attention Seekers**
  Widget rubberBand({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return ScaleTransition(
          scale: TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
            TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 50),
            TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 50),
          ]).animate(controller),
          child: child,
        );
      },
    );
  }

  Widget swing({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
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
      },
    );
  }

  // **Back Entrances**
  Widget backInDown({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
              .animate(controller),
          child: child,
        );
      },
    );
  }

  Widget backInUp({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(controller),
          child: child,
        );
      },
    );
  }

  // **Back Exits**
  Widget backOutDown({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1))
              .animate(controller),
          child: child,
        );
      },
    );
  }

  // **Bouncing Entrances**
  Widget bounceIn({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return ScaleTransition(
          scale: Tween(begin: 0.3, end: 1.0)
              .chain(CurveTween(curve: Curves.bounceOut))
              .animate(controller),
          child: child,
        );
      },
    );
  }

  // **Fading Entrances**
  Widget fadeIn({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
          child: child,
        );
      },
    );
  }

  Widget fadeOut({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
          child: child,
        );
      },
    );
  }

  // **Sliding Entrances**
  Widget slideInLeft({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
              .animate(controller),
          child: child,
        );
      },
    );
  }

  // Zooming Entrances
  Widget zoomIn({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return ScaleTransition(
          scale: Tween(begin: 0.5, end: 1.0).animate(controller),
          child: child,
        );
      },
    );
  }

  // Zooming Exits
  Widget zoomOut({
    required Widget child,
    required Duration duration,
    bool repeat = false,
  }) {
    return _AnimationWidget(
      duration: duration,
      animationBuilder: (context, controller) {
        if (repeat) {
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
        }
        return ScaleTransition(
          scale: Tween(begin: 1.0, end: 0.5).animate(controller),
          child: child,
        );
      },
    );
  }

  void _setupRepeat(AnimationController controller) {
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }
}

class _AnimationWidget extends StatefulWidget {
  final Widget Function(BuildContext context, AnimationController controller)
      animationBuilder;
  final Duration duration;

  const _AnimationWidget({
    Key? key,
    required this.animationBuilder,
    required this.duration,
  }) : super(key: key);

  @override
  State<_AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<_AnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.animationBuilder(context, _controller);
  }
}

// import 'package:flutter/material.dart';
//
// class AnimationApp {
//   static final AnimationApp i = AnimationApp._internal();
//
//   AnimationApp._internal();
//
//   Widget fade({
//     required Widget child,
//     required Duration duration,
//     bool repeat = false,
//   }) {
//     return _AnimationWidget(
//       animationBuilder: (context, controller) {
//         if (repeat) {
//           controller.addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               controller.reverse();
//             } else if (status == AnimationStatus.dismissed) {
//               controller.forward();
//             }
//           });
//         }
//         return FadeTransition(
//           opacity: Tween(begin: 0.0, end: 1.0).animate(controller),
//           child: child,
//         );
//       },
//       duration: duration,
//     );
//   }
// }
//
// class _AnimationWidget extends StatefulWidget {
//   final Widget Function(BuildContext context, AnimationController controller)
//       animationBuilder;
//   final Duration duration;
//
//   const _AnimationWidget({
//     Key? key,
//     required this.animationBuilder,
//     required this.duration,
//   }) : super(key: key);
//
//   @override
//   State<_AnimationWidget> createState() => _AnimationWidgetState();
// }
//
// class _AnimationWidgetState extends State<_AnimationWidget>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     )..forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.animationBuilder(context, _controller);
//   }
// }
