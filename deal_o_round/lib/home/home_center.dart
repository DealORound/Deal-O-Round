import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:get/get.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../game/game_page.dart';
import '../game/game_widget.dart';
import '../game/logic/game_constants.dart';
import '../home/home_page.dart';
import '../services/size.dart';
import '../settings/settings_page.dart';
import 'title_line.dart';

class HomeCenter extends StatelessWidget {
  Widget _alertDialog() {
    final textStyle = TextStyle(fontSize: 18);
    return AlertDialog(
      title: Text('Game Services', style: textStyle),
      content: Text(
          'Without signing in the end score ' +
              'cannot be recorded and no achievement ' +
              'could be administered. ' +
              'Is it OK to continue?',
          style: textStyle),
      actions: [
        TextButton(
          child: Text('Yes', style: textStyle),
          onPressed: () async {
            Get.close(1);
            await Get.to(() => GamePage(child: GameWidget()));
          },
        ),
        TextButton(
          child: Text('No', style: textStyle),
          onPressed: () => Get.close(1), // Get.back(closeOverlays: true),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = HomePage.of(context);
    if (state == null) {
      return Container();
    }

    final radius = chipRadius(context); // ~40
    final size = context.mediaQuerySize;
    final buttonWidth = size.width / 3.8; // 210
    final bigSpacing = radius / 2; // ~20
    final spacing = bigSpacing / 2; // ~10
    final textStyle = TextStyle(
      fontSize: radius,
      fontFamily: 'Musicals',
      color: Colors.white,
    );
    final buttonPadding = EdgeInsets.all(spacing);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: BorderSide(color: Colors.green.shade700, width: 3.0),
    );
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      textStyle: textStyle,
      shape: buttonShape,
      padding: buttonPadding,
      minimumSize: Size(buttonWidth, spacing),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleLine(),
        SizedBox(height: bigSpacing),
        Row(
          children: [
            Column(children: [
              ElevatedButton.icon(
                onPressed: () async {
                  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
                    try {
                      await GamesServices.signIn().then((String? result) {
                        state.updateSignedIn(true);
                      });
                    } on Exception catch (e) {
                      debugPrint("Error signing in: $e");
                      Get.snackbar("Error", "Could not sign in",
                          colorText: SNACK_TEXT, backgroundColor: snackBack);
                      state.updateSignedIn(false);
                    }
                  } else {
                    Get.snackbar(
                      "Sign In",
                      "Game Services is only available on Android " +
                          "and Game Center is only available on iOS",
                      colorText: SNACK_TEXT,
                      backgroundColor: snackBack,
                    );
                  }
                },
                style: buttonStyle,
                icon: Icon(Icons.person, size: radius, color: Colors.white),
                label: Text("Login", style: textStyle),
              ),
              SizedBox(height: spacing),
              ElevatedButton.icon(
                onPressed: () async {
                  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
                    if (state.gameSignedIn) {
                      try {
                        await GamesServices.showLeaderboards();
                        // iOS requires iOSLeaderboardID
                      } on Exception catch (e) {
                        debugPrint("Error showing lb: $e");
                        Get.snackbar("Error", "Could not fetch board",
                            colorText: SNACK_TEXT, backgroundColor: snackBack);
                      }
                    } else {
                      Get.snackbar("Warning", "Sign-in needed",
                          colorText: SNACK_TEXT, backgroundColor: snackBack);
                    }
                  } else {
                    Get.snackbar("Leaderboards:", "Only available on Android or iOS devices",
                        colorText: SNACK_TEXT, backgroundColor: snackBack);
                  }
                },
                style: buttonStyle,
                icon: Icon(Icons.format_list_numbered, size: radius, color: Colors.white),
                label: Text("Scores", style: textStyle),
              ),
              SizedBox(height: spacing),
              ElevatedButton.icon(
                onPressed: () async {
                  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
                    if (state.gameSignedIn) {
                      try {
                        await GamesServices.showAchievements();
                      } on Exception catch (e) {
                        debugPrint("Error showing achievements: $e");
                        Get.snackbar("Error", "Could not fetch achievement",
                            colorText: SNACK_TEXT, backgroundColor: snackBack);
                      }
                    } else {
                      Get.snackbar("Warning", "Sign-in needed",
                          colorText: SNACK_TEXT, backgroundColor: snackBack);
                    }
                  } else {
                    Get.snackbar("Achievements:", "Only available on Android or iOS devices",
                        colorText: SNACK_TEXT, backgroundColor: snackBack);
                  }
                },
                style: buttonStyle,
                icon: Icon(Icons.grade, size: radius, color: Colors.white),
                label: Text("Grades", style: textStyle),
              ),
            ]),
            SizedBox(width: spacing),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    if (!state.gameSignedIn &&
                        (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
                      await Get.dialog(_alertDialog(), barrierDismissible: false);
                    } else {
                      await Get.to(() => GamePage(child: GameWidget()));
                    }
                  },
                  style: buttonStyle,
                  icon: Icon(Icons.play_arrow, size: radius, color: Colors.white),
                  label: Text("Play", style: textStyle),
                ),
                SizedBox(height: spacing),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => SettingsPage()),
                  style: buttonStyle,
                  icon: Icon(Icons.settings, size: radius, color: Colors.white),
                  label: Text("Config", style: textStyle),
                ),
                SizedBox(height: spacing),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (await canLaunchUrlString(HELP_URL)) {
                      launchUrlString(HELP_URL);
                    } else {
                      Get.snackbar("Attention", "Cannot open URL",
                          colorText: SNACK_TEXT, backgroundColor: snackBack);
                    }
                  },
                  style: buttonStyle,
                  icon: Icon(Icons.help, size: radius, color: Colors.white),
                  label: Text("Help", style: textStyle),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
