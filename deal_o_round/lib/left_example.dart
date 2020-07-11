import 'package:flutter/material.dart';
import 'chip_widget.dart';
import 'home_page.dart';

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
        Row(
          children: <Widget>[
            ChipWidget(suit: '3', value: 'Q'),
            ChipWidget(suit: 'C', value: '6')
          ]
        ),
        Row(
          children: <Widget>[
            ChipWidget(suit: 'S', value: 'Q'),
            ChipWidget(suit: '3', value: '10')
          ]
        ),
        Row(
          children: <Widget>[
            ChipWidget(suit: 'C', value: 'Q'),
            ChipWidget(suit: '4', value: '6')
          ]
        ),
        SizedBox(height: 10),
        Text("Full House!", style: textStyle)
      ]
    );
  }
}
