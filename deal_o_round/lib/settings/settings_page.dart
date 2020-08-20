import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../background_gradient.dart';
import 'boolean_settings.dart';
import 'enum_settings.dart';
import 'settings_constants.dart';
import 'spinner_settings.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 56,
      fontFamily: 'Roboto-Condensed',
      fontWeight: FontWeight.w400,
      color: Colors.lightGreenAccent
    );
    const textStyle = TextStyle(
      fontSize: 32,
      fontFamily: 'Roboto-Condensed',
      fontWeight: FontWeight.w400,
      color: Colors.white
    );
    final size = Get.mediaQuery.size;
    final boxDecoration = BoxDecoration(
      color: Colors.green.shade900.withOpacity(0.5),
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.green.shade900,
        width: 3.0
      )
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: FloatingActionButton(
          onPressed: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 40),
          backgroundColor: Colors.green,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: getBackgroundGradient()
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: boxDecoration,
              padding: const EdgeInsets.all(8.0),
              child: const Text("Settings", style: titleStyle)
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: size.width / 2 - 10,
                  child: Container(
                    decoration: boxDecoration,
                    padding: const EdgeInsets.all(2.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      childAspectRatio: 4.0,
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                      children: <Widget>[
                        const Text("Difficulty", style: textStyle),
                        EnumSettings<Difficulty>(
                          values: Difficulty.values,
                          defaultValue: Difficulty.Easy,
                          valueTag: DIFFICULTY,
                          textStyle: textStyle,
                        ),
                        const Text("Layout", style: textStyle),
                        EnumSettings<BoardLayout>(
                          values: BoardLayout.values,
                          defaultValue: BoardLayout.Hexagonal,
                          valueTag: BOARD_LAYOUT,
                          textStyle: textStyle,
                        ),
                        const Text("Game Music", style: textStyle),
                        BooleanSettings(
                          defaultValue: false,
                          valueTag: GAME_MUSIC
                        ),
                        const Text("Sound Effects", style: textStyle),
                        BooleanSettings(
                          defaultValue: true,
                          valueTag: SOUND_EFFECTS
                        )
                      ]
                    )
                  )
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: size.width / 2 - 10,
                  child: Container(
                    decoration: boxDecoration,
                    padding: const EdgeInsets.all(2.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      childAspectRatio: 4.0,
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                      children: <Widget>[
                        const Text("Volume", style: textStyle),
                        SpinnerSettings(
                          minValue: 0,
                          maxValue: 100,
                          defaultValue: 15,
                          valueTag: VOLUME,
                          textStyle: textStyle,
                        ),
                        const Text("Screen Scale", style: textStyle),
                        SpinnerSettings(
                          minValue: 0.2,
                          maxValue: 4.0,
                          stepValue: 0.05,
                          fractionDigits: 2,
                          defaultValue: 1.0,
                          valueTag: SCREEN_SCALE,
                          textStyle: textStyle,
                        ),
                        const Text("Anim. Speed", style: textStyle),
                        SpinnerSettings(
                          minValue: 50,
                          maxValue: 500,
                          stepValue: 10,
                          defaultValue: 200,
                          valueTag: ANIMATION_SPEED,
                          textStyle: textStyle,
                        ),
                        const Text("Refresh Rate", style: textStyle),
                        SpinnerSettings(
                          minValue: 25,
                          maxValue: 120,
                          stepValue: 5,
                          defaultValue: 60,
                          valueTag: REFRESH_RATE,
                          textStyle: textStyle,
                        )
                      ]
                    )
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }
}
