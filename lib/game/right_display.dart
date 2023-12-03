import 'package:flutter/material.dart';

import '../services/size.dart';
import 'game_page.dart';

class RightDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = GamePage.of(context);
    if (state == null) {
      return Container();
    }

    final radius = chipRadius(context); // ~40
    final textStyle = TextStyle(
        fontSize: radius * 0.7, // ~28
        fontFamily: 'Roboto Condensed',
        color: Colors.white);
    final infoStyle = TextStyle(
        fontSize: radius * 0.5, // ~20
        fontFamily: 'Roboto Condensed',
        color: Colors.white);

    final greenDecoration = BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.green.shade700, width: 3.0));
    final blueDecoration = BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.blue.shade700, width: 3.0));
    final spacing = radius / 8; // ~5
    final width = radius * 4; // 160

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Center(child: Text("${state.score}", style: textStyle)),
          ),
        ),
        SizedBox(height: spacing),
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Center(child: Text("Level ${state.level}", style: textStyle)),
          ),
        ),
        SizedBox(height: spacing),
        Container(
          decoration: blueDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(text: state.info, style: infoStyle),
            ),
          ),
        ),
      ],
    );
  }
}
