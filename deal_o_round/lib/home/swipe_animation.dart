import 'dart:ui';

import 'package:flutter/material.dart';
import 'left_example_chips.dart';
import 'swipe_painter.dart';

class SwipeAnimation extends StatefulWidget {
  SwipeAnimation({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SwipeAnimationState();
  }
}

class SwipeAnimationState extends State<SwipeAnimation> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  Path _path;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
      reverseDuration: Duration(milliseconds: 1000),
    );
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
    _path = SwipePainter.swipePath(160, 240);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 240,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: LeftExampleChips(),
          ),
          Positioned(
            top: calculate(_animation.value).dy - 35,
            left: calculate(_animation.value).dx - 35,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0x99B2FF59),
                borderRadius: BorderRadius.circular(35)
              ),
              width: 70,
              height: 70
            )
          )
        ]
      )
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}
