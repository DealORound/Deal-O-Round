import 'package:flutter/material.dart';

import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import '../game/chip_widget.dart';
import 'swipe_painter.dart';

class LeftExampleChips extends StatelessWidget {
  const LeftExampleChips({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: SwipePainter(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ChipWidget(card: PlayCard(Suit.hearts, Value.queen)),
              ChipWidget(card: PlayCard(Suit.clubs, Value.six)),
            ],
          ),
          Row(
            children: [
              ChipWidget(card: PlayCard(Suit.spades, Value.queen)),
              ChipWidget(card: PlayCard(Suit.hearts, Value.ten)),
            ],
          ),
          Row(
            children: [
              ChipWidget(card: PlayCard(Suit.clubs, Value.queen)),
              ChipWidget(card: PlayCard(Suit.diamonds, Value.six)),
            ],
          ),
        ],
      ),
    );
  }
}
