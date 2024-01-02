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
  EnumSettingsState createState() => EnumSettingsState<T>();
}

class EnumSettingsState<T> extends State<EnumSettings> {
  late SharedPreferences _prefs;
  late List<String> _stringValues;
  late String _stringValue;

  EnumSettingsState() {
    _prefs = Get.find<SharedPreferences>();
  }

  @override
  initState() {
    super.initState();
    String? storedValue = _prefs.getString(widget.valueTag);
    if (storedValue != null) {
      _stringValue = storedValue.toLowerCase();
    } else {
      _stringValue = widget.defaultValue.toString().split('.').last;
    }

    _stringValues = widget.values.map((v0) {
      return v0.toString();
    }).map((v1) {
      return v1.split('.').last;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _stringValue,
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
            _stringValue = newValue;
            _prefs.setString(widget.valueTag, newValue);
          }
        });
      },
      items: _stringValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: widget.textStyle),
        );
      }).toList(),
    );
  }
}
