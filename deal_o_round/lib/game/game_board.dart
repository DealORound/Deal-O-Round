import 'dart:math';

import 'package:deal_o_round/settings/settings_constants.dart';
import 'package:flutter/material.dart';
import 'logic/shoe.dart';
import 'chip_widget.dart';
import 'game_page.dart';

class GameBoard extends StatelessWidget {
  // list.toList()..shuffle()
  static const chipCount = 5;
  Shoe shoe;

  GameBoard() {
    shoe = Shoe(4);
  }

  Column getRandomColumn(int chipCount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        for(var i = 0; i < chipCount; i += 1)
          ChipWidget(card: shoe.dealCard())
      ]
    );
  }

  Row getRandomColumns(int chipCount, BoardLayout layout) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for(var i = 0; i < chipCount; i += 1)
          getRandomColumn(chipCount + (layout == BoardLayout.Hexagonal && i % 2 == 0 ? -1 : 0))
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameState state = GamePage.of(context);
    final BoardLayout layout = state.layout;
    final greenDecoration = BoxDecoration(
      color: Colors.green.shade900,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.green.shade700,
        width: 3.0
      )
    );
    const size = 400.0;

    return Container(
      decoration: greenDecoration,
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: size,
        height: size,
        child: getRandomColumns(chipCount, layout)
      )
    );
  }
}
