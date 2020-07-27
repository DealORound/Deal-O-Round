import 'package:flutter/material.dart';
import 'game_page.dart';

class RightDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameState state = GamePage.of(context);
    final score = state.score;
    final level = state.level;
    final info = state.info;
    const size = 32.0;
    const textStyle = TextStyle(
      fontSize: size,
      fontFamily: 'Roboto Condensed',
      color: Colors.white
    );

    final greenDecoration = BoxDecoration(
      color: Colors.green.shade900,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.green.shade700,
        width: 3.0
      )
    );
    final blueDecoration = BoxDecoration(
      color: Colors.blue.shade900,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.blue.shade700,
        width: 3.0
      )
    );
    const spacing = 10.0;
    const width = 160.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Center(
              child: Text("$score", style: textStyle)
            )
          )
        ),
        SizedBox(height: spacing),
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Center(
              child: Text("Level $level", style: textStyle)
            )
          )
        ),
        SizedBox(height: spacing),
        Container(
          decoration: blueDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: info,
                style: textStyle
              )
            )
          )
        )
      ]
    );
  }
}
