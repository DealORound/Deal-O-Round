import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_constants.dart';

class PreferencesUtils {
  static Future<SharedPreferences> registerService() async {
    return Get.putAsync<SharedPreferences>(() async {
      final prefs = await SharedPreferences.getInstance();
      String? storedString = prefs.getString(DIFFICULTY);
      if (storedString == null) {
        await prefs.setString(DIFFICULTY, DIFFICULTY_DEFAULT);
      }
      storedString = prefs.getString(BOARD_LAYOUT);
      if (storedString == null) {
        await prefs.setString(BOARD_LAYOUT, BOARD_LAYOUT_DEFAULT);
      }
      bool? storedBool = prefs.getBool(GAME_MUSIC);
      if (storedBool == null) {
        await prefs.setBool(GAME_MUSIC, GAME_MUSIC_DEFAULT);
      }
      storedBool = prefs.getBool(SOUND_EFFECTS);
      if (storedBool == null) {
        await prefs.setBool(SOUND_EFFECTS, SOUND_EFFECTS_DEFAULT);
      }
      double? storedNumber = prefs.getDouble(VOLUME);
      if (storedNumber == null) {
        await prefs.setDouble(VOLUME, VOLUME_DEFAULT);
      }
      storedNumber = prefs.getDouble(SCREEN_SCALE);
      if (storedNumber == null) {
        await prefs.setDouble(SCREEN_SCALE, SCREEN_SCALE_DEFAULT);
      }
      storedNumber = prefs.getDouble(ANIMATION_SPEED);
      if (storedNumber == null) {
        await prefs.setDouble(ANIMATION_SPEED, ANIMATION_SPEED_DEFAULT);
      }
      return prefs;
    });
  }
}
