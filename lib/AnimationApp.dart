import 'package:flutter/material.dart';

import 'custom_AnimationApp.dart';

class AnimatedScreen extends StatefulWidget {
  @override
  _AnimatedScreenState createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Single Widget Animation')),
      body: Center(
        child: AnimationApp.i.backInLeft(
          // repeat: true,
          duration: const Duration(seconds: 1),
          child: Text('Hello!', style: TextStyle(fontSize: 24)),
          vsync: this,
        ),
      ),
    );
  }
}

/// https://animate.style/
