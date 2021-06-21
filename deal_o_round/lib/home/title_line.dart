import 'package:flutter/material.dart';
import '../services/size.dart';
import 'home_page.dart';

class TitleLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = HomePage.of(context);
    if (state == null) {
      return Container();
    }

    final List<Widget> titleCharacters = [];
    const title = "Deal-O-Round";
    final rightNow = state.rightNow;
    final animationTick = rightNow.second;
    final prePreHighlight = animationTick % title.length;
    final preHighlight = (animationTick + 1) % title.length;
    final highlightIdx = (animationTick + 2) % title.length;
    final postHighlight = (animationTick + 3) % title.length;
    final postPostHighlight = (animationTick + 4) % title.length;
    final radius = chipRadius(context); // ~40
    final fontSize = radius * 1.5; // ~60

    title.split('').asMap().forEach((idx, char) => titleCharacters.add(Text(
          char,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Musicals',
            color: idx == highlightIdx
                ? Colors.white
                : ((idx == preHighlight || idx == postHighlight)
                    ? Colors.lightGreenAccent
                    : ((idx == prePreHighlight || idx == postPostHighlight)
                        ? Colors.lightGreen
                        : Colors.green)),
          ),
        )));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: titleCharacters,
    );
  }
}
