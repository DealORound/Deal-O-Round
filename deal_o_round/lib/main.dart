import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/preferences.dart';
import 'services/sound.dart';
import 'deal_o_round_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  await PreferencesUtils.registerService().then((pref) =>
    Get.put<SoundUtils>(SoundUtils(pref: pref))
  );
  runApp(DealORoundApp());
}
