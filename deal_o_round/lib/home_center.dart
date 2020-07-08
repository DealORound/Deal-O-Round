import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String aboutUrl = "http://dealoround.com/about.html";
    const String helpUrl = "http://dealoround.com/help.html";
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
                RaisedButton.icon(
                  onPressed: null,
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.person),
                  label: Text("Login"),
                ),
                RaisedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.format_list_numbered),
                  label: Text("Top Scores"),
                ),
                RaisedButton.icon(
                  onPressed: () => {
                    debugPrint('Play!')
                  },
                  icon: Icon(Icons.settings),
                  label: Text("Settings"),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () => {
                    debugPrint('Play!')
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Play"),
                ),
                RaisedButton.icon(
                  onPressed: () async => {
                    if (await canLaunch(aboutUrl)) {
                      launch(aboutUrl)
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Cannot open URL'),
                      ))
                    }
                  },
                  icon: Icon(Icons.info),
                  label: Text("About"),
                ),
                RaisedButton.icon(
                  onPressed: () async => {
                    if (await canLaunch(helpUrl)) {
                      launch(helpUrl)
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Cannot open URL'),
                      ))
                    }
                  },
                  icon: Icon(Icons.help),
                  label: Text("Help"),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
