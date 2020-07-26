import 'package:flutter/material.dart';
import '../game/chip_widget.dart';

class RightExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            ChipWidget(suit: '3', value: '2'),
          ]
        ),
        Row(
          children: <Widget>[
            ChipWidget(suit: 'S', value: 'A'),
            ChipWidget(suit: 'C', value: 'J')
          ]
        ),
        Row(
          children: <Widget>[
            ChipWidget(suit: '4', value: 'K')
          ]
        )
      ]
    );
  }
}
