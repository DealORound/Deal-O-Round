import 'package:flutter/widgets.dart';

class ChipSelectionPainter extends CustomPainter {
  final bool selected;
  final bool neighbor;

  ChipSelectionPainter({this.selected, this.neighbor});

  @override
  paint(Canvas canvas, Size size) {
    if (!selected && !neighbor) {
      return;
    }
    final verticalCenter = size.height / 2;
    final horizontalCenter = size.width / 2;
    final center = Offset(horizontalCenter, verticalCenter);

    final selectionFill = Paint()
      ..color = selected ? Color(0x55FFFF00) : Color(0x55FFA500)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(center, verticalCenter, selectionFill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
