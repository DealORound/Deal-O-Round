import 'package:flutter/widgets.dart';

class BackgroundPainter extends CustomPainter {
  Path _diamondShape(Canvas canvas, Size size) {
    final padding = 10.0;
    final halfHeight = (size.height - 2 * padding) / 2;
    final verticalCenter = size.height / 2;
    final horizontalCenter = size.width / 2;
    return Path()
      ..moveTo(horizontalCenter, padding)
      ..lineTo(horizontalCenter + halfHeight, verticalCenter)
      ..lineTo(horizontalCenter, padding + 2 * halfHeight)
      ..lineTo(horizontalCenter - halfHeight, verticalCenter);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final diamondPath = _diamondShape(canvas, size);
    diamondPath.close();
    final diamondStrokePaint = Paint()
      ..color = Color(0xCCFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..isAntiAlias = true;
    canvas.drawPath(diamondPath, diamondStrokePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
