import 'package:flutter/material.dart';
import 'home_center.dart';
import 'left_example.dart';
import 'right_example.dart';

class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            LeftExample(),
            HomeCenter(),
            RightExample()
          ]
        )
      )
    );
  }
}
