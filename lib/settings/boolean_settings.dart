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
  _BooleanSettingsState createState() =>
      _BooleanSettingsState(defaultValue, valueTag);
}

class _BooleanSettingsState extends State<BooleanSettings> {
  late SharedPreferences _prefs;
  bool booleanValue;
  final String valueTag;

  _BooleanSettingsState(this.booleanValue, this.valueTag) {
    _prefs = Get.find<SharedPreferences>();
  }

  @override
  initState() {
    super.initState();
    bool? storedValue = _prefs.getBool(valueTag);
    if (storedValue != null) {
      booleanValue = storedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: widget.scale,
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
                final soundUtils = Get.find<SoundUtils>();
                if (valueTag == SOUND_EFFECTS) {
                  if (newValue) {
                    soundUtils.loadSoundEffects();
                  } else {
                    soundUtils.stopAllSoundEffects();
                  }
                } else if (valueTag == GAME_MUSIC) {
                  if (newValue) {
                    soundUtils.playSoundTrack(SoundTrack.SaloonMusic);
                  } else {
                    soundUtils.stopAllSoundTracks();
                  }
                }
              });
            }));
  }
}
