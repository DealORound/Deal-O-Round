import 'package:flutter/material.dart';

import '../services/size.dart';
import 'home_page.dart';
import 'swipe_animation.dart';

class LeftExample extends StatelessWidget {
  const LeftExample({super.key});

  @override
  Widget build(BuildContext context) {
    final state = HomePage.of(context);
    if (state == null) {
      return Container();
    }

    final highlightSecond = state.rightNow.second % 3 == 0;
    final radius = chipRadius(context);
    final textStyle = TextStyle(
      fontSize: radius * 0.65, // ~26
      fontFamily: 'Musicals',
      color: highlightSecond ? Colors.lightGreenAccent : Colors.green,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SwipeAnimation(),
        SizedBox(height: radius / 4), // ~10
        Text("Full House!", style: textStyle),
      ],
    );
  }
}
