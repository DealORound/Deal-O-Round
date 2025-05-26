import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/settings_constants.dart';
import '../services/sound.dart';

class BooleanSettings extends StatefulWidget {
  final double scale;
  final bool defaultValue;
  final String valueTag;

  const BooleanSettings({
    super.key,
    this.scale = 1.2,
    required this.defaultValue,
    required this.valueTag,
  });

  @override
  BooleanSettingsState createState() => BooleanSettingsState();
}

class BooleanSettingsState extends State<BooleanSettings> {
  late SharedPreferences _prefs;
  late bool _booleanValue;

  BooleanSettingsState() {
    _prefs = Get.find<SharedPreferences>();
  }

  @override
  initState() {
    super.initState();
    bool? storedValue = _prefs.getBool(widget.valueTag);
    if (storedValue != null) {
      _booleanValue = storedValue;
    } else {
      _booleanValue = widget.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: Switch(
        value: _booleanValue,
        activeColor: Colors.lightGreenAccent,
        activeTrackColor: Colors.green,
        inactiveThumbColor: Colors.red,
        inactiveTrackColor: Colors.brown,
        onChanged: (newValue) {
          setState(() async {
            _booleanValue = newValue;
            _prefs.setBool(widget.valueTag, newValue);
            final soundUtils = Get.find<SoundUtils>();
            if (widget.valueTag == soundEffectsTag) {
              if (newValue) {
                await soundUtils.loadSoundEffects();
              } else {
                await soundUtils.stopSoundEffects();
              }
            } else if (widget.valueTag == gameMusicTag) {
              if (newValue) {
                await soundUtils.playSoundTrack(SoundTrack.saloonMusic);
              } else {
                await soundUtils.stopAllSoundTracks();
              }
            }
          });
        },
      ),
    );
  }
}
