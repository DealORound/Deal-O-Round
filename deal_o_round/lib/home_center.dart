import 'package:flutter/material.dart';

class HomeCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'DEAL-O-ROUND',
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                RaisedButton.icon(onPressed: null, icon: null, label: null),
                RaisedButton.icon(onPressed: null, icon: null, label: null),
                RaisedButton.icon(onPressed: null, icon: null, label: null),
              ],
            )
          ],
        )
      ],
    );
  }
}
