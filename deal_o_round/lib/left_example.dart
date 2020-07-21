import 'package:flutter/material.dart';
import 'home_page.dart';
import 'swipe_animation.dart';

class LeftExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomePageState state = HomePage.of(context);
    final highlightSecond = state.rightNow.second % 3 == 0;
    final textStyle = TextStyle(
      fontSize: 26,
      fontFamily: 'Musicals',
      color: highlightSecond ? Colors.lightGreenAccent: Colors.green
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SwipeAnimation(),
        SizedBox(height: 10),
        Text("Full House!", style: textStyle)
      ]
    );
  }
}
