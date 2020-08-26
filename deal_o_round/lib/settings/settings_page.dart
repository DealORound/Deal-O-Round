import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../background_gradient.dart';
import '../services/settings_constants.dart';
import '../services/size.dart';
import 'boolean_settings.dart';
import 'enum_settings.dart';
import 'spinner_settings.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final radius = chipRadius(context); // ~40
    final size = context.mediaQuerySize;
    final titleStyle = TextStyle(
        fontSize: radius * 1.4, // ~56
        fontFamily: 'Roboto-Condensed',
        fontWeight: FontWeight.w400,
        color: Colors.lightGreenAccent);
    final textStyle = TextStyle(
        fontSize: radius * 0.8, // ~32
        fontFamily: 'Roboto-Condensed',
        fontWeight: FontWeight.w400,
        color: Colors.white);
    final boxDecoration = BoxDecoration(
        color: Colors.green.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.green.shade900, width: 3.0));
    final separatorSize = radius / 2; // ~ 20
    final halfWidth = size.width / 2 - 10;

    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: radius * 1.5), // ~60
          child: FloatingActionButton(
            onPressed: () => Get.back(),
            child: Icon(Icons.arrow_back, size: radius),
            backgroundColor: Colors.green,
          ),
        ),
        body: Container(
            decoration: BoxDecoration(gradient: getBackgroundGradient()),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      decoration: boxDecoration,
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Settings", style: titleStyle)),
                  SizedBox(height: separatorSize),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            width: halfWidth,
                            child: Container(
                                decoration: boxDecoration,
                                padding: const EdgeInsets.all(2.0),
                                child: GridView.count(
                                    crossAxisCount: 2,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    childAspectRatio: 4.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 8.0),
                                    children: <Widget>[
                                      Text("Difficulty", style: textStyle),
                                      EnumSettings<Difficulty>(
                                        values: Difficulty.values,
                                        defaultValue: DIFFICULTY_DEFAULT_VALUE,
                                        valueTag: DIFFICULTY,
                                        textStyle: textStyle,
                                      ),
                                      Text("Layout", style: textStyle),
                                      EnumSettings<BoardLayout>(
                                        values: BoardLayout.values,
                                        defaultValue:
                                            BOARD_LAYOUT_DEFAULT_VALUE,
                                        valueTag: BOARD_LAYOUT,
                                        textStyle: textStyle,
                                      ),
                                      Text("Game Music", style: textStyle),
                                      BooleanSettings(
                                          defaultValue: GAME_MUSIC_DEFAULT,
                                          valueTag: GAME_MUSIC),
                                      Text("Sound Effects", style: textStyle),
                                      BooleanSettings(
                                          defaultValue: SOUND_EFFECTS_DEFAULT,
                                          valueTag: SOUND_EFFECTS)
                                    ]))),
                        SizedBox(width: separatorSize),
                        SizedBox(
                            width: halfWidth,
                            child: Container(
                                decoration: boxDecoration,
                                padding: const EdgeInsets.all(2.0),
                                child: GridView.count(
                                    crossAxisCount: 2,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    childAspectRatio: 4.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 8.0),
                                    children: <Widget>[
                                      Text("Volume", style: textStyle),
                                      SpinnerSettings(
                                        minValue: 0,
                                        maxValue: 100,
                                        defaultValue: VOLUME_DEFAULT,
                                        valueTag: VOLUME,
                                        textStyle: textStyle,
                                      ),
                                      Text("Screen Scale", style: textStyle),
                                      SpinnerSettings(
                                        minValue: 0.2,
                                        maxValue: 4.0,
                                        stepValue: 0.05,
                                        fractionDigits: 2,
                                        defaultValue: SCREEN_SCALE_DEFAULT,
                                        valueTag: SCREEN_SCALE,
                                        textStyle: textStyle,
                                      ),
                                      Text("Anim. Speed", style: textStyle),
                                      SpinnerSettings(
                                        minValue: 50,
                                        maxValue: 500,
                                        stepValue: 10,
                                        defaultValue: ANIMATION_SPEED_DEFAULT,
                                        valueTag: ANIMATION_SPEED,
                                        textStyle: textStyle,
                                      )
                                    ])))
                      ])
                ])));
  }
}
