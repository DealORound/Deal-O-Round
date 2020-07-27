import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooleanSettings extends StatefulWidget {
  final double scale;
  final bool defaultValue;
  final String valueTag;

  const BooleanSettings({
    Key key,
    this.scale = 1.2,
    this.defaultValue,
    this.valueTag
  }) : super(key: key);

  @override
  _BooleanSettingsState createState() => _BooleanSettingsState(
    scale: scale,
    booleanValue: defaultValue,
    valueTag: valueTag
  );
}

class _BooleanSettingsState extends State<BooleanSettings> {
  SharedPreferences _prefs;
  final double scale;
  bool booleanValue;
  final String valueTag;

  _BooleanSettingsState({
    this.scale = 1.2,
    this.booleanValue,
    this.valueTag
  });

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        try {
          final _storedValue = _prefs.getBool(valueTag);
          if (_storedValue != null) {
            booleanValue = _storedValue;
          } else {
            _prefs.setBool(valueTag, booleanValue);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write $valueTag settings");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Switch(
        value: booleanValue,
        activeColor: Colors.lightGreenAccent,
        activeTrackColor: Colors.green,
        inactiveThumbColor: Colors.red,
        inactiveTrackColor: Colors.brown,
        onChanged: (newValue) {
          setState(() {
            booleanValue = newValue;
            _prefs.setBool(valueTag, newValue);
          });
        }
      )
    );
  }
}
