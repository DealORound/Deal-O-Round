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
      children: <Widget>[
        Row(
          children: <Widget>[
            ChipWidget(card: PlayCard(suit: Suit.Hearts, value: Value.Two)),
          ]
        ),
        Row(
          children: <Widget>[
            ChipWidget(card: PlayCard(suit: Suit.Spades, value: Value.Ace)),
            ChipWidget(card: PlayCard(suit: Suit.Clubs, value: Value.Jack))
          ]
        ),
        Row(
          children: <Widget>[
            ChipWidget(card: PlayCard(suit: Suit.Diamonds, value: Value.King))
          ]
        )
      ]
    );
  }
}
