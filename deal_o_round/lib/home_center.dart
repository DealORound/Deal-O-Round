import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const aboutUrl = "http://dealoround.com/about.html";
    const helpUrl = "http://dealoround.com/help.html";
    const size = 48.0;
    const textStyle = TextStyle(
      fontSize: size,
      fontFamily: 'Musicals',
      color: Colors.white
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Deal-O-Round',
          style: TextStyle(
              fontSize: 72,
              fontFamily: 'Musicals',
              color: Colors.white
          )
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () => {
                    debugPrint('Login!')
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.person, size: size),
                  label: Text("Login", style: textStyle)
                ),
                SizedBox(height: 10),
                RaisedButton.icon(
                  onPressed: () => {
                    debugPrint('Scores!')
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.format_list_numbered, size: size),
                  label: Text("Scores", style: textStyle)
                ),
                SizedBox(height: 10),
                RaisedButton.icon(
                  onPressed: () => {
                    debugPrint('Settings!')
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.settings, size: size),
                  label: Text("Config", style: textStyle)
                )
              ]
            ),
            SizedBox(width: 20),
            Column(
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () => {
                    debugPrint('Play!')
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.play_arrow, size: size),
                  label: Text("Play", style: textStyle)
                ),
                SizedBox(height: 10),
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
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.info, size: size),
                  label: Text("About", style: textStyle)
                ),
                SizedBox(height: 10),
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
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icon(Icons.help, size: size),
                  label: Text("Help", style: textStyle)
                )
              ]
            )
          ]
        )
      ]
    );
  }
}
