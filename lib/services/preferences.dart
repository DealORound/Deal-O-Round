import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_constants.dart';

class PreferencesUtils {
  static Future<SharedPreferences> registerService() async {
    return Get.putAsync<SharedPreferences>(() async {
      final prefs = await SharedPreferences.getInstance();
      String? storedString = prefs.getString(difficultyTag);
      if (storedString == null) {
        await prefs.setString(difficultyTag, difficultyDefault);
      }
      storedString = prefs.getString(boardLayoutTag);
      if (storedString == null) {
        await prefs.setString(boardLayoutTag, boardLayoutDefault);
      }
      bool? storedBool = prefs.getBool(gameMusicTag);
      if (storedBool == null) {
        await prefs.setBool(gameMusicTag, gameMusicDefault);
      }
      storedBool = prefs.getBool(soundEffectsTag);
      if (storedBool == null) {
        await prefs.setBool(soundEffectsTag, soundEffectsDefault);
      }
      double? storedNumber = prefs.getDouble(volumeTag);
      if (storedNumber == null) {
        await prefs.setDouble(volumeTag, volumeDefault);
      }
      storedNumber = prefs.getDouble(screenScaleTag);
      if (storedNumber == null) {
        await prefs.setDouble(screenScaleTag, screenScaleDefault);
      }
      storedNumber = prefs.getDouble(animationSpeedTag);
      if (storedNumber == null) {
        await prefs.setDouble(animationSpeedTag, animationSpeedDefault);
      }
      return prefs;
    });
  }
}
