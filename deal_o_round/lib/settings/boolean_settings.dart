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
  initState() {
    super.initState();
    _prefs = Get.find<SharedPreferences>();
    booleanValue = _prefs.getBool(valueTag);
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
          debugPrint("onChanged $valueTag $newValue");
          setState(() {
            booleanValue = newValue;
            _prefs.setBool(valueTag, newValue);
            debugPrint("setState $valueTag $newValue");
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
        }
      )
    );
  }
}
