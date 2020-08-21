import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'services/preferences.dart';
import 'deal_o_round_app.dart';

Soundpool soundPool;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  PreferencesUtils.registerService();
  soundPool = Soundpool(streamType: StreamType.notification, maxStreams: 2);
  runApp(DealORoundApp());
}
