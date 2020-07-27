import 'package:deal_o_round/settings/spinner_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../background_gradient.dart';
import 'boolean_settings.dart';
import 'settings_constants.dart';

// Extension methods
extension on Difficulty {
  String get inString => describeEnum(this);
}

extension on BoardLayout {
  String get inString => describeEnum(this);
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences _prefs;
  Difficulty _difficulty = Difficulty.Easy;
  BoardLayout _layout = BoardLayout.Hexagonal;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        try {
          final _storedDifficulty = _prefs.getString(DIFFICULTY);
          if (_storedDifficulty != null) {
            _difficulty = enumFromString(Difficulty.values, _storedDifficulty);
          } else {
            _prefs.setString(DIFFICULTY, _difficulty.inString);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write difficulty settings");
        }
        try {
          final _storedLayout = _prefs.getString(BOARD_LAYOUT);
          if (_storedLayout != null) {
            _layout = enumFromString(BoardLayout.values, _storedLayout);
          } else {
            _prefs.setString(BOARD_LAYOUT, _layout.inString);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write layout settings");
        }
      });
    });
  }

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: 40),
            backgroundColor: Colors.green,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: getBackgroundGradient()
          ),
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Settings", style: titleStyle),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: size.width / 2 - 10,
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      childAspectRatio: 4.0,
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      children: <Widget>[
                        const Text("Difficulty", style: textStyle),
                        DropdownButton<String>(
                          value: _difficulty.inString,
                          icon: Icon(Icons.arrow_downward, color: Colors.green),
                          iconSize: 40,
                          style: TextStyle(color: Colors.lightGreen),
                          underline: Container(
                            height: 2,
                            color: Colors.lightGreenAccent,
                          ),
                          dropdownColor: Colors.green.shade800,
                          onChanged: (String newValue) {
                            setState(() {
                              _difficulty = enumFromString(Difficulty.values, newValue);
                              _prefs.setString(DIFFICULTY, newValue);
                            });
                          },
                          items: <String>[Difficulty.Easy.inString, Difficulty.Medium.inString, Difficulty.Hard.inString]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: textStyle),
                            );
                          }).toList(),
                        ),
                        const Text("Layout", style: textStyle),
                        DropdownButton<String>(
                          value: _layout.inString,
                          icon: Icon(Icons.arrow_downward, color: Colors.green),
                          iconSize: 40,
                          style: TextStyle(color: Colors.lightGreen),
                          underline: Container(
                            height: 2,
                            color: Colors.lightGreenAccent,
                          ),
                          dropdownColor: Colors.green.shade800,
                          onChanged: (String newValue) {
                            setState(() {
                              _layout = enumFromString(BoardLayout.values, newValue);
                              _prefs.setString(BOARD_LAYOUT, newValue);
                            });
                          },
                          items: <String>[BoardLayout.Square.inString, BoardLayout.Hexagonal.inString]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: textStyle),
                            );
                          }).toList(),
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
                      ],
                    )),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: size.width / 2 - 10,
                      child: GridView.count(
                        crossAxisCount: 2,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        childAspectRatio: 4.0,
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
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
                  ]
              )
            ]
          )
      )
    );
  }
}
