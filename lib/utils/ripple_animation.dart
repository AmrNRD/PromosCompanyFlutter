
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'circle_painter.dart';
import 'curve_wave.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({Key key, this.size = 80.0, this.color = Colors.red, this.onPressed, @required this.child,}) : super(key: key);
  final double size;
  final Color color;
  final Widget child;
  final VoidCallback onPressed;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Ripple Demo"),
      ),
      body: Center(
        child: CustomPaint(
          painter: CirclePainter(_controller, color: widget.color),
          child: SizedBox(
            width: widget.size * 4.125,
            height: widget.size * 4.125,
            child: RipplesButton(controller: _controller,size: widget.size,color: widget.color),
          ),
        ),
      ),
    );
  }
}
class RipplesButton extends StatelessWidget {
  final double size;
  final Color color;
  final AnimationController controller;

  const RipplesButton({Key key,@required this.size,@required this.color,@required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                color,
                Color.lerp(color, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: const CurveWave(),
                ),
              ),
              child: Icon(FontAwesomeIcons.barcode)
          ),
        ),
      ),
    );
  }
}
