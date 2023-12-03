import 'package:flutter/material.dart';

import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import '../game/chip_widget.dart';

class RightExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: [
          ChipWidget(card: PlayCard(Suit.Hearts, Value.Two)),
        ]),
        Row(children: [
          ChipWidget(card: PlayCard(Suit.Spades, Value.Ace)),
          ChipWidget(card: PlayCard(Suit.Clubs, Value.Jack)),
        ]),
        Row(children: [
          ChipWidget(card: PlayCard(Suit.Diamonds, Value.King)),
        ]),
      ],
    );
  }
}
