import 'package:flutter/material.dart';
import 'home_page.dart';

class TitleLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> titleCharacters = [];
    final HomePageState state = HomePage.of(context);
    const title = "Deal-O-Round";
    var highlightIdx = state.rightNow.second % title.length;

    title.split('').asMap().forEach((idx, char) => titleCharacters.add(
      Text(
        char,
        style: TextStyle(
          fontSize: 60,
          fontFamily: 'Musicals',
          color: highlightIdx == idx ? Colors.lightGreenAccent : Colors.white
        )
      )
    ));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: titleCharacters,
    );
  }
}
