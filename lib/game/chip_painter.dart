import 'dart:math';

import 'package:flutter/widgets.dart';

class ChipPainter extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    final verticalCenter = size.height / 2;
    final horizontalCenter = size.width / 2;
    final center = Offset(horizontalCenter, verticalCenter);
    final whiteFill = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(center, verticalCenter, whiteFill);

    final blackStroke = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true;
    canvas.drawCircle(center, verticalCenter - 4, blackStroke);

    final circleRect =
        Rect.fromCircle(center: center, radius: verticalCenter - 2);
    final blueStroke = Paint()
      ..color = const Color(0xFF0000FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..isAntiAlias = true;
    const sweepAngle = 2 * pi / 16;
    const stepAngle = sweepAngle * 2;
    const startAngle = sweepAngle * 1.5;
    const stopAngle = stepAngle + 2 * pi;
    for (var angle = startAngle; angle <= stopAngle; angle += stepAngle) {
      canvas.drawArc(circleRect, angle, sweepAngle, false, blueStroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
