import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinner_input/spinner_input.dart';
import '../background_gradient.dart';
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
  bool _music = false;
  bool _soundEffects = true;
  double _volume = 15;
  double _screenScale = 1.0;
  double _animationSpeed = 200;
  double _refreshRate = 60;

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
        try {
          final _storedMusic = _prefs.getBool(GAME_MUSIC);
          if (_storedMusic != null) {
            _music = _storedMusic;
          } else {
            _prefs.setBool(GAME_MUSIC, _music);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write music settings");
        }
        try {
          final _storedSoundEffects = _prefs.getBool(SOUND_EFFECTS);
          if (_storedSoundEffects != null) {
            _soundEffects = _storedSoundEffects;
          } else {
            _prefs.setBool(SOUND_EFFECTS, _soundEffects);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write sound effects settings");
        }
        try {
          final _storedVolume = _prefs.getDouble(VOLUME);
          if (_storedVolume != null) {
            _volume = _storedVolume;
          } else {
            _prefs.setDouble(VOLUME, _volume);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write volume settings");
        }
        try {
          final _storedScale = _prefs.getDouble(SCREEN_SCALE);
          if (_storedScale != null) {
            _screenScale = _storedScale;
          } else {
            _prefs.setDouble(SCREEN_SCALE, _screenScale);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write screen scale settings");
        }
        try {
          final _storedSpeed = _prefs.getDouble(ANIMATION_SPEED);
          if (_storedSpeed != null) {
            _animationSpeed = _storedSpeed;
          } else {
            _prefs.setDouble(ANIMATION_SPEED, _animationSpeed);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write animation speed settings");
        }
        try {
          final _storedRefreshRate = _prefs.getDouble(REFRESH_RATE);
          if (_storedRefreshRate != null) {
            _refreshRate = _storedRefreshRate;
          } else {
            _prefs.setDouble(REFRESH_RATE, _refreshRate);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write refresh rate settings");
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
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            value: _music,
                            activeColor: Colors.lightGreenAccent,
                            activeTrackColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.brown,
                            onChanged: (newValue) {
                              setState(() {
                                _music = newValue;
                                _prefs.setBool(GAME_MUSIC, newValue);
                              });
                            }
                          )
                        ),
                        const Text("Sound Effects", style: textStyle),
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            value: _soundEffects,
                            activeColor: Colors.lightGreenAccent,
                            activeTrackColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.brown,
                            onChanged: (newValue) {
                              setState(() {
                                _soundEffects = newValue;
                                _prefs.setBool(SOUND_EFFECTS, newValue);
                              });
                            }
                          )
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
                          SpinnerInput(
                            spinnerValue: _volume,
                            minValue: 0,
                            maxValue: 100,
                            plusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.add, size: 35)
                            ),
                            minusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.remove, size: 35)
                            ),
                            middleNumberWidth: 100,
                            middleNumberStyle: textStyle,
                            middleNumberBackground: Colors.green.shade800,
                            onChange: (newValue) {
                              setState(() {
                                _volume = newValue;
                                _prefs.setDouble(VOLUME, newValue);
                              });
                            }
                          ),
                          const Text("Screen Scale", style: textStyle),
                          SpinnerInput(
                            spinnerValue: _screenScale,
                            minValue: 0.2,
                            maxValue: 4.0,
                            step: 0.05,
                            fractionDigits: 2,
                            plusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.add, size: 35)
                            ),
                            minusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.remove, size: 35)
                            ),
                            middleNumberWidth: 100,
                            middleNumberStyle: textStyle,
                            middleNumberBackground: Colors.green.shade800,
                            onChange: (newValue) {
                              setState(() {
                                _screenScale = newValue;
                                _prefs.setDouble(SCREEN_SCALE, newValue);
                              });
                            }
                          ),
                          const Text("Anim. Speed", style: textStyle),
                          SpinnerInput(
                            spinnerValue: _animationSpeed,
                            minValue: 50,
                            maxValue: 500,
                            step: 10,
                            plusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.add, size: 35)
                            ),
                            minusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.remove, size: 35)
                            ),
                            middleNumberWidth: 100,
                            middleNumberStyle: textStyle,
                            middleNumberBackground: Colors.green.shade800,
                            onChange: (newValue) {
                              setState(() {
                                _animationSpeed = newValue;
                                _prefs.setDouble(ANIMATION_SPEED, newValue);
                              });
                            }
                          ),
                          const Text("Refresh Rate", style: textStyle),
                          SpinnerInput(
                            spinnerValue: _refreshRate,
                            minValue: 25,
                            maxValue: 120,
                            step: 5,
                            plusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.add, size: 35)
                            ),
                            minusButton: SpinnerButtonStyle(
                              color: Colors.green,
                              height: 40,
                              width: 40,
                              child: Icon(Icons.remove, size: 35)
                            ),
                            middleNumberWidth: 100,
                            middleNumberStyle: textStyle,
                            middleNumberBackground: Colors.green.shade800,
                            onChange: (newValue) {
                              setState(() {
                                _refreshRate = newValue;
                                _prefs.setDouble(REFRESH_RATE, newValue);
                              });
                            }
                          ),
                        ],
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
