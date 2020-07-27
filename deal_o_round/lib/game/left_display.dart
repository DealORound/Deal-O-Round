import 'package:flutter/material.dart';
import 'game_page.dart';

class LeftDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameState state = GamePage.of(context);
    final secondsLeft = state.rightNow.second;
    final textStyle = TextStyle(
      fontSize: 26,
      fontFamily: 'Roboto Condensed',
      color: Colors.white
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("$secondsLeft", style: textStyle)
      ]
    );
  }
}
