import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:just_audio_background/just_audio_background.dart';

import 'services/preferences.dart';
import 'services/sound.dart';
import 'deal_o_round_app.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.dealoround.android.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  // if (kDebugMode) {
  //   debugPaintSizeEnabled = true;
  // }
  await PreferencesUtils.registerService().then(
    (pref) => Get.put<SoundUtils>(SoundUtils(pref)),
  );
  runApp(const DealORoundApp());
}
