import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:get/get.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import '../game/game_page.dart';
import '../game/game_widget.dart';
import '../services/size.dart';
import '../settings/settings_page.dart';
import 'title_line.dart';

class HomeCenter extends StatelessWidget {
  final Color sbText = Colors.white;
  final Color sbBack = Colors.redAccent.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    const aboutUrl = "http://dealoround.com/about.html";
    const helpUrl = "http://dealoround.com/help.html";
    final radius = chipRadius(context); // ~40
    final size = context.mediaQuerySize;
    final buttonWidth = size.width / 3.8; // 210
    final bigSpacing = radius / 2; // ~20
    final spacing = bigSpacing / 2; // ~10
    final buttonPadding = EdgeInsets.all(spacing);
    final textStyle = TextStyle(
        fontSize: radius, fontFamily: 'Musicals', color: Colors.white);
    var buttonShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: Colors.green.shade700, width: 3.0));
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleLine(),
          SizedBox(height: bigSpacing),
          Row(children: <Widget>[
            Column(children: <Widget>[
              ButtonTheme(
                  minWidth: buttonWidth,
                  child: RaisedButton.icon(
                      onPressed: () async {
                        if (UniversalPlatform.isAndroid ||
                            UniversalPlatform.isIOS) {
                          try {
                            await GamesServices.signIn();
                          } catch (e) {
                            Get.snackbar("Error", "Could not sign in",
                                colorText: sbText, backgroundColor: sbBack);
                          }
                        } else {
                          Get.snackbar(
                              "Sign In",
                              "Game Services is only available on Android and " +
                                  "Game Center is only available on iOS",
                              colorText: sbText,
                              backgroundColor: sbBack);
                        }
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: buttonShape,
                      padding: buttonPadding,
                      icon: Icon(Icons.person, size: radius),
                      label: Text("Login", style: textStyle))),
              SizedBox(height: spacing),
              ButtonTheme(
                  minWidth: buttonWidth,
                  child: RaisedButton.icon(
                      onPressed: () async {
                        if (UniversalPlatform.isAndroid ||
                            UniversalPlatform.isIOS) {
                          try {
                            await GamesServices.showLeaderboards();
                            // TODO: iOS requires iOSLeaderboardID
                          } catch (e) {
                            Get.snackbar("Error", "Could not fetch leaderboard",
                                colorText: sbText, backgroundColor: sbBack);
                          }
                        } else {
                          Get.snackbar("Scores",
                              "Only available on Android or iOS devices",
                              colorText: sbText, backgroundColor: sbBack);
                        }
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: buttonShape,
                      padding: buttonPadding,
                      icon: Icon(Icons.format_list_numbered, size: radius),
                      label: Text("Scores", style: textStyle))),
              SizedBox(height: spacing),
              ButtonTheme(
                  minWidth: buttonWidth,
                  child: RaisedButton.icon(
                      onPressed: () => Get.to(SettingsPage()),
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: buttonShape,
                      padding: buttonPadding,
                      icon: Icon(Icons.settings, size: radius),
                      label: Text("Config", style: textStyle)))
            ]),
            SizedBox(width: spacing),
            Column(children: <Widget>[
              ButtonTheme(
                  minWidth: buttonWidth,
                  child: RaisedButton.icon(
                      onPressed: () => Get.to(GamePage(child: GameWidget())),
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: buttonShape,
                      padding: buttonPadding,
                      icon: Icon(Icons.play_arrow, size: radius),
                      label: Text("Play", style: textStyle))),
              SizedBox(height: spacing),
              ButtonTheme(
                  minWidth: buttonWidth,
                  child: RaisedButton.icon(
                      onPressed: () async => {
                            if (await canLaunch(aboutUrl))
                              {launch(aboutUrl)}
                            else
                              {
                                Get.snackbar("Attention", "Cannot open URL",
                                    colorText: sbText, backgroundColor: sbBack)
                              }
                          },
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: buttonShape,
                      padding: buttonPadding,
                      icon: Icon(Icons.info, size: radius),
                      label: Text("About", style: textStyle))),
              SizedBox(height: spacing),
              ButtonTheme(
                  minWidth: buttonWidth,
                  child: RaisedButton.icon(
                      onPressed: () async => {
                            if (await canLaunch(helpUrl))
                              {launch(helpUrl)}
                            else
                              {
                                Get.snackbar("Attention", "Cannot open URL",
                                    colorText: sbText, backgroundColor: sbBack)
                              }
                          },
                      color: Colors.green,
                      textColor: Colors.white,
                      shape: buttonShape,
                      padding: buttonPadding,
                      icon: Icon(Icons.help, size: radius),
                      label: Text("Help", style: textStyle)))
            ])
          ])
        ]);
  }
}
