import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwipePainter extends CustomPainter {
  static Path swipePath(double width, double height) {
    final wQ = width / 4;
    final hS = height / 6;
    return Path()
      ..moveTo(wQ, hS)
      ..lineTo(2 * wQ, hS)
      ..quadraticBezierTo(3 * wQ, hS, 3 * wQ, 2 * hS)
      ..lineTo(3 * wQ, 4 * hS)
      ..quadraticBezierTo(3 * wQ, 5 * hS, 2 * wQ, 5 * hS)
      ..lineTo(wQ, 5 * hS);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0x668BC34A)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 70.0;

    canvas.drawPath(swipePath(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
