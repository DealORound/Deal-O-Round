import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwipePainter extends CustomPainter {
  static Path swipePath(double width, double height) {
    final wQ = width / 4;
    final hS = height / 6;
    return Path()
      ..moveTo(3 * wQ, hS)
      ..lineTo(2 * wQ, hS)
      ..quadraticBezierTo(wQ, hS, wQ, 2 * hS)
      ..lineTo(wQ, 4 * hS)
      ..quadraticBezierTo(wQ, 5 * hS, 2 * wQ, 5 * hS)
      ..lineTo(3 * wQ, 5 * hS);
  }

  @override
  paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0x668BC34A)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 2 - 10; // ~70

    canvas.drawPath(swipePath(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
