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
    Key key,
    this.values,
    this.defaultValue,
    this.valueTag,
    this.textStyle
  }) : super(key: key);

  @override
  _EnumSettingsState createState() => _EnumSettingsState<T>(
    values: values,
    enumValue: defaultValue,
    valueTag: valueTag,
    textStyle: textStyle
  );
}

class _EnumSettingsState<T> extends State<EnumSettings> {
  SharedPreferences _prefs;
  final List<T> values;
  List<String> stringValues;
  T enumValue;
  String stringValue;
  final String valueTag;
  final TextStyle textStyle;

  _EnumSettingsState({
    this.values,
    this.enumValue,
    this.valueTag,
    this.textStyle
  }) {
    this.stringValues = values.map<String>((T val) {
      return val.toString().split('.').last;
    }).toList();
    this.stringValue = enumValue.toString().split('.').last;
  }

  @override
  initState() {
    super.initState();
    _prefs = Get.find<SharedPreferences>();
    stringValue = _prefs.getString(valueTag);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: stringValue,
      icon: Icon(Icons.arrow_downward, color: Colors.green),
      iconSize: chipRadius(context),
      style: TextStyle(color: Colors.lightGreen),
      underline: Container(
        height: 2,
        color: Colors.lightGreenAccent,
      ),
      dropdownColor: Colors.green.shade800,
      onChanged: (String newValue) {
        setState(() {
          stringValue = newValue;
          _prefs.setString(valueTag, newValue);
        });
      },
      items: stringValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: textStyle),
        );
      }).toList(),
    );
  }
}
