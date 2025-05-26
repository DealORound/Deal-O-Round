import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/size.dart';
import '../services/sound.dart';
import 'left_example_chips.dart';
import 'swipe_painter.dart';

class SwipeAnimation extends StatefulWidget {
  const SwipeAnimation({super.key});

  @override
  State<StatefulWidget> createState() => SwipeAnimationState();
}

class SwipeAnimationState extends State<SwipeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;
  Path? _path;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 1000),
    );
    super.initState();
    _animation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              await Get.find<SoundUtils>().playSoundEffect(
                SoundEffect.shortCardShuffle,
              );
              _animationController?.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController?.forward();
            }
          });
    _animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final diameter = chipSize(context); // ~80
    final dAdj = diameter - 10; // ~70
    final rAdj = dAdj / 2; // ~35
    final width = diameter * 2; // ~160
    final height = diameter * 3; // ~240
    _path ??= SwipePainter.swipePath(width, height);
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          const Positioned(top: 0, left: 0, child: LeftExampleChips()),
          Positioned(
            top: calculate(_animation?.value ?? 0.0).dy - rAdj,
            left: calculate(_animation?.value ?? 0.0).dx - rAdj,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x99B2FF59),
                borderRadius: BorderRadius.circular(rAdj),
              ),
              width: dAdj,
              height: dAdj,
            ),
          ),
        ],
      ),
    );
  }

  @override
  dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Offset calculate(double value) {
    PathMetrics? pathMetrics = _path?.computeMetrics();
    PathMetric? pathMetric = pathMetrics?.elementAt(0);
    value = (pathMetric?.length ?? 0.0) * value;
    Tangent? pos = pathMetric?.getTangentForOffset(value);
    return pos?.position ?? const Offset(0.0, 0.0);
  }
}
