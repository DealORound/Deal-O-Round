import 'package:flutter/material.dart';
import 'game_page.dart';

class LeftDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = GamePage.of(context);
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
    const spacing = 10.0;
    const width = 160.0;
    const buttonPadding = const EdgeInsets.all(4.0);

    var buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: BorderSide(color: Colors.grey.shade700, width: 3.0)
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Center(
              child: Text("${state.countDown}", style: textStyle)
            )
          )
        ),
        SizedBox(height: spacing),
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Next level", style: textStyle),
                Text("${state.nextLevel}", style: textStyle)
              ]
            )
          )
        ),
        SizedBox(height: spacing),
        ButtonTheme(
          minWidth: width,
          child: RaisedButton.icon(
            onPressed: () => state.togglePause(),
            color: Colors.grey,
            textColor: Colors.white,
            shape: buttonShape,
            padding: buttonPadding,
            icon: Icon(state.paused ? Icons.play_arrow : Icons.pause, size: size),
            label: Text(state.paused ? "Play" : "Pause", style: textStyle)
          )
        ),
        SizedBox(height: spacing),
        ButtonTheme(
          minWidth: width,
          child: RaisedButton.icon(
            onPressed: () => state.spin(),
            color: Colors.grey,
            textColor: Colors.white,
            shape: buttonShape,
            padding: buttonPadding,
            icon: const Icon(Icons.loop, size: size),
            label: const Text("Spin", style: textStyle)
          )
        ),
        SizedBox(height: spacing),
        ButtonTheme(
          minWidth: width,
          child: RaisedButton.icon(
            onPressed: () => state.evaluateAndProcessHand(),
            color: Colors.grey,
            textColor: Colors.white,
            shape: buttonShape,
            padding: buttonPadding,
            icon: const Icon(Icons.functions, size: size),
            label: const Text("Eval", style: textStyle)
          )
        )
      ]
    );
  }
}
