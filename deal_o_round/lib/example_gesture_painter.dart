import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExampleGesturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0x668BC34A)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 70.0;

    final xQ = size.width / 4;
    final yS = size.height / 6;
    Path path = Path()
      ..moveTo(xQ, yS)
      ..quadraticBezierTo(3 * xQ, yS, 3 * xQ, 3 * yS)
      ..quadraticBezierTo(3 * xQ, 5 * yS, xQ, 5 * yS);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
