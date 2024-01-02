import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../game/logic/game_constants.dart';
import '../services/size.dart';
import 'game_page.dart';

class LeftDisplay extends StatelessWidget {
  const LeftDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GamePage.of(context);
    if (state == null) {
      return Container();
    }

    final radius = chipRadius(context); // ~40
    final size = radius * 0.7; // ~28
    final textStyle = TextStyle(
      fontSize: size,
      fontFamily: 'Roboto Condensed',
      color: Colors.white,
    );

    final greenDecoration = BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.green.shade700, width: 3.0));
    final spacing = radius / 8; // ~5
    final width = radius * 4; // ~160
    const buttonPadding = EdgeInsets.all(4.0);
    var buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: BorderSide(color: Colors.grey.shade700, width: 3.0),
    );
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.grey,
      textStyle: textStyle,
      shape: buttonShape,
      padding: buttonPadding,
      minimumSize: Size(width, spacing),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Center(
              child: Text("${state.countDown}", style: textStyle),
            ),
          ),
        ),
        SizedBox(height: spacing),
        Container(
          decoration: greenDecoration,
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Next level", style: textStyle),
                Text("${state.nextLevel}", style: textStyle)
              ],
            ),
          ),
        ),
        SizedBox(height: spacing),
        ElevatedButton.icon(
          onPressed: () => state.togglePause(),
          style: buttonStyle,
          icon: Icon(
            state.paused ? Icons.play_arrow : Icons.pause,
            size: size,
            color: Colors.white,
          ),
          label: Text(state.paused ? "Play" : "Pause", style: textStyle),
        ),
        SizedBox(height: spacing),
        ElevatedButton.icon(
          onPressed: () => state.spin(),
          style: buttonStyle,
          icon: Icon(Icons.loop, size: size, color: Colors.white),
          label: Text("Spin", style: textStyle),
        ),
        SizedBox(height: spacing),
        ElevatedButton.icon(
          onPressed: () => state.evaluateAndProcessHand(),
          style: buttonStyle,
          icon: Icon(Icons.functions, size: size, color: Colors.white),
          label: Text("Eval", style: textStyle),
        ),
        SizedBox(height: spacing),
        ElevatedButton.icon(
          onPressed: () async {
            if (await canLaunchUrlString(helpUrl)) {
              state.togglePause();
              launchUrlString(helpUrl);
            } else {
              Get.snackbar("Attention", "Cannot open URL",
                  colorText: snackTextColor, backgroundColor: snackBgColor);
            }
          },
          style: buttonStyle,
          icon: Icon(Icons.help_outline, size: size, color: Colors.white),
          label: Text("Help", style: textStyle),
        ),
      ],
    );
  }
}
