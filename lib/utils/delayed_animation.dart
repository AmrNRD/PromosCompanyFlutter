import 'dart:async';

import 'package:flutter/material.dart';

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final AnimationController animationController;
  DelayedAnimation({@required this.child, this.delay, this.animationController});

  @override
  _DelayedAnimationState createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animOffset;
  CurvedAnimation curve;

  @override
  void initState() {

    _controller = widget.animationController??AnimationController(vsync: this, duration: Duration(milliseconds: 800));
     curve = CurvedAnimation(curve: Curves.decelerate, parent: _controller);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(curve);

    if (widget.delay == null) {
      _controller.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _controller.forward();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.animationController==null)
      _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: ScaleTransition(
        scale:curve,
        child: widget.child,
      ),
      opacity: _controller,
    );
  }
}