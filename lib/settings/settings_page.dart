import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../game/logic/game_constants.dart';
import '../services/settings_constants.dart';
import '../services/size.dart';
import '../background_gradient.dart';
import 'boolean_settings.dart';
import 'enum_settings.dart';
import 'spinner_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final radius = chipRadius(context); // ~40
    final size = context.mediaQuerySize;
    final titleSize = radius * 1.2; // ~48
    final titleStyle = TextStyle(
      fontSize: titleSize, // ~48
      fontFamily: 'Roboto-Condensed',
      fontWeight: FontWeight.w400,
      color: Colors.lightGreenAccent,
    );
    final textStyle = TextStyle(
      fontSize: radius * 0.6, // ~24
      fontFamily: 'Roboto-Condensed',
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
    final boxDecoration = BoxDecoration(
      color: Colors.green.shade900.withOpacity(0.5),
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(color: Colors.green.shade900, width: 3.0),
    );
    final separatorSize = radius / 4; // ~ 10
    final halfWidth = size.width / 2 - 2 * separatorSize;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: radius * 1.5), // ~60
        child: SizedBox(
          width: titleSize,
          height: titleSize,
          child: FloatingActionButton(
            onPressed: () => Get.back(),
            backgroundColor: Colors.green,
            child: Icon(Icons.arrow_back, size: radius),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: getBackgroundGradient()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: boxDecoration,
              padding: const EdgeInsets.all(8.0),
              child: Text("Settings", style: titleStyle),
            ),
            SizedBox(height: separatorSize),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: halfWidth,
                  child: Container(
                    decoration: boxDecoration,
                    padding: const EdgeInsets.all(2.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      childAspectRatio: 4.0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 1.0,
                        horizontal: 10.0,
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Difficulty", style: textStyle),
                        ),
                        EnumSettings<Difficulty>(
                          values: Difficulty.values,
                          defaultValue: difficultyDefaultValue,
                          valueTag: difficultyTag,
                          textStyle: textStyle,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Layout", style: textStyle),
                        ),
                        EnumSettings<BoardLayout>(
                          values: BoardLayout.values,
                          defaultValue: boardLayoutDefaultValue,
                          valueTag: boardLayoutTag,
                          textStyle: textStyle,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Game Music", style: textStyle),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: separatorSize),
                          child: const BooleanSettings(
                              defaultValue: gameMusicDefault,
                              valueTag: gameMusicTag),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Sound Effects", style: textStyle),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: separatorSize),
                          child: const BooleanSettings(
                              defaultValue: soundEffectsDefault,
                              valueTag: soundEffectsTag),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: separatorSize),
                SizedBox(
                  width: halfWidth,
                  child: Container(
                    decoration: boxDecoration,
                    padding: const EdgeInsets.all(2.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      childAspectRatio: 4.0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 1.0,
                        horizontal: 4.0,
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Volume", style: textStyle),
                        ),
                        SpinnerSettings(
                          minValue: 0,
                          maxValue: 100,
                          defaultValue: volumeDefault,
                          valueTag: volumeTag,
                          textStyle: textStyle,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Screen Scale", style: textStyle),
                        ),
                        SpinnerSettings(
                          minValue: 0.2,
                          maxValue: 4.0,
                          stepValue: 0.05,
                          fractionDigits: 2,
                          defaultValue: screenScaleDefault,
                          valueTag: screenScaleTag,
                          textStyle: textStyle,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Anim. Speed", style: textStyle),
                        ),
                        SpinnerSettings(
                          minValue: 50,
                          maxValue: 500,
                          stepValue: 10,
                          defaultValue: animationSpeedDefault,
                          valueTag: animationSpeedTag,
                          textStyle: textStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
