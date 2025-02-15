import 'package:flutter/material.dart';

import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import '../game/chip_widget.dart';

class RightExample extends StatelessWidget {
  const RightExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: [ChipWidget(card: PlayCard(Suit.hearts, Value.two))]),
        Row(
          children: [
            ChipWidget(card: PlayCard(Suit.spades, Value.ace)),
            ChipWidget(card: PlayCard(Suit.clubs, Value.jack)),
          ],
        ),
        Row(children: [ChipWidget(card: PlayCard(Suit.diamonds, Value.king))]),
      ],
    );
  }
}
