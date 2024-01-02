import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinner_input_plus/spinner_input_plus.dart';

import '../services/settings_constants.dart';
import '../services/size.dart';
import '../services/sound.dart';

class SpinnerSettings extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double stepValue;
  final int fractionDigits;
  final double defaultValue;
  final String valueTag;
  final TextStyle textStyle;

  const SpinnerSettings(
      {super.key,
      required this.minValue,
      required this.maxValue,
      this.stepValue = 1,
      this.fractionDigits = 0,
      required this.defaultValue,
      required this.valueTag,
      required this.textStyle});

  @override
  SpinnerSettingsState createState() => SpinnerSettingsState();
}

class SpinnerSettingsState extends State<SpinnerSettings> {
  late SharedPreferences _prefs;
  late double _doubleValue;

  SpinnerSettingsState() {
    _prefs = Get.find<SharedPreferences>();
  }

  @override
  initState() {
    super.initState();
    double? storedValue = _prefs.getDouble(widget.valueTag);
    if (storedValue != null) {
      _doubleValue = storedValue;
    } else {
      _doubleValue = widget.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = chipRadius(context); // ~40
    final iconSize = radius - 10; // ~30
    final numberWidth = radius * 2 + 15; // ~95
    return SpinnerInput(
        spinnerValue: _doubleValue,
        minValue: widget.minValue,
        maxValue: widget.maxValue,
        step: widget.stepValue,
        fractionDigits: widget.fractionDigits,
        plusButton: SpinnerButtonStyle(
          color: Colors.green,
          height: radius,
          width: radius,
          child: Icon(Icons.add, size: iconSize),
        ),
        minusButton: SpinnerButtonStyle(
          color: Colors.green,
          height: radius,
          width: radius,
          child: Icon(Icons.remove, size: iconSize),
        ),
        middleNumberWidth: numberWidth,
        middleNumberStyle: widget.textStyle,
        middleNumberBackground: Colors.green.shade800,
        onChange: (newValue) {
          setState(() {
            _doubleValue = newValue;
            _prefs.setDouble(widget.valueTag, newValue);
            if (widget.valueTag == volumeTag) {
              final soundUtils = Get.find<SoundUtils>();
              soundUtils.updateVolume(newValue);
            }
          });
        });
  }
}
