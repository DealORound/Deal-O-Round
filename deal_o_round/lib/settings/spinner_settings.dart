import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinner_input/spinner_input.dart';
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

  const SpinnerSettings({
    Key key,
    this.minValue,
    this.maxValue,
    this.stepValue = 1,
    this.fractionDigits = 0,
    this.defaultValue,
    this.valueTag,
    this.textStyle
  }) : super(key: key);

  @override
  _SpinnerSettingsState createState() => _SpinnerSettingsState(
    minValue: minValue,
    maxValue: maxValue,
    stepValue: stepValue,
    fractionDigits: fractionDigits,
    doubleValue: defaultValue,
    valueTag: valueTag,
    textStyle: textStyle
  );
}

class _SpinnerSettingsState extends State<SpinnerSettings> {
  SharedPreferences _prefs;
  final double minValue;
  final double maxValue;
  final double stepValue;
  final int fractionDigits;
  double doubleValue;
  final String valueTag;
  final TextStyle textStyle;

  _SpinnerSettingsState({
    this.minValue,
    this.maxValue,
    this.stepValue,
    this.fractionDigits,
    this.doubleValue,
    this.valueTag,
    this.textStyle
  });

  @override
  initState() {
    super.initState();
    _prefs = Get.find<SharedPreferences>();
    doubleValue = _prefs.getDouble(valueTag);
  }

  @override
  Widget build(BuildContext context) {
    final radius = chipRadius(context);  // ~40
    final iconSize = radius - 5;  // ~35
    final numberWidth = radius * 2 + 15;  // ~95
    return SpinnerInput(
      spinnerValue: doubleValue,
      minValue: minValue,
      maxValue: maxValue,
      step: stepValue,
      fractionDigits: fractionDigits,
      plusButton: SpinnerButtonStyle(
        color: Colors.green,
        height: radius,
        width: radius,
        child: Icon(Icons.add, size: iconSize)
      ),
      minusButton: SpinnerButtonStyle(
        color: Colors.green,
        height: radius,
        width: radius,
        child: Icon(Icons.remove, size: iconSize)
      ),
      middleNumberWidth: numberWidth,
      middleNumberStyle: textStyle,
      middleNumberBackground: Colors.green.shade800,
      onChange: (newValue) {
        setState(() {
          doubleValue = newValue;
          _prefs.setDouble(valueTag, newValue);
          if (valueTag == VOLUME) {
            final soundUtils = Get.find<SoundUtils>();
            soundUtils.updateVolume(newValue);
          }
        });
      }
    );
  }
}
