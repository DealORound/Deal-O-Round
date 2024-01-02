import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/size.dart';

class EnumSettings<T> extends StatefulWidget {
  final List<T> values;
  final T defaultValue;
  final String valueTag;
  final TextStyle textStyle;

  const EnumSettings({
    super.key,
    required this.values,
    required this.defaultValue,
    required this.valueTag,
    required this.textStyle,
  });

  @override
  EnumSettingsState createState() =>
      EnumSettingsState<T>(values, defaultValue, valueTag);
}

class EnumSettingsState<T> extends State<EnumSettings> {
  late SharedPreferences _prefs;
  late List<String> stringValues;
  T enumValue;
  late String stringValue;
  final String valueTag;

  EnumSettingsState(List<T> values, this.enumValue, this.valueTag) {
    _prefs = Get.find<SharedPreferences>();
    this.stringValues = values.map<String>((T val) {
      return val.toString().split('.').last;
    }).toList();
    this.stringValue = enumValue.toString().split('.').last;
  }

  @override
  initState() {
    super.initState();
    String? storedValue = _prefs.getString(valueTag);
    if (storedValue != null) {
      stringValue = storedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: stringValue,
      icon: const Icon(Icons.arrow_downward, color: Colors.green),
      iconSize: chipRadius(context),
      style: TextStyle(
          color: Colors.lightGreen, fontSize: widget.textStyle.fontSize),
      underline: Container(
        height: 2,
        color: Colors.lightGreenAccent,
      ),
      dropdownColor: Colors.green.shade800,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue != null) {
            stringValue = newValue;
            _prefs.setString(valueTag, newValue);
          }
        });
      },
      items: stringValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: widget.textStyle),
        );
      }).toList(),
    );
  }
}
