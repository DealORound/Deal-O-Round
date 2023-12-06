import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/settings_constants.dart';
import '../services/sound.dart';

class _HomePageInherited extends InheritedWidget {
  const _HomePageInherited({
    required super.child,
    required this.data,
  });

  final HomePageState data;

  @override
  bool updateShouldNotify(_HomePageInherited oldWidget) {
    return true;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  HomePageState createState() => HomePageState();

  static HomePageState? of(BuildContext context) {
    final state =
        context.dependOnInheritedWidgetOfExactType<_HomePageInherited>();
    return state?.data;
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var _rightNow = DateTime.now();
  Timer? _timer;
  late SharedPreferences _prefs;
  bool _gameSignedIn = false;

  DateTime get rightNow => _rightNow;
  bool get gameSignedIn => _gameSignedIn;

  HomePageState() {
    _prefs = Get.find<SharedPreferences>();
  }

  @override
  initState() {
    super.initState();
    Get.find<SoundUtils>().playSoundTrack(SoundTrack.SaloonMusic);
    bool? storedSignedIn = _prefs.getBool(GAME_SIGNED_IN);
    if (storedSignedIn != null) {
      _gameSignedIn = storedSignedIn;
    } else {
      _prefs.setBool(GAME_SIGNED_IN, false);
      _gameSignedIn = false;
    }
    _updateTime();
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _updateTime() {
    setState(() {
      _rightNow = DateTime.now();
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        const Duration(seconds: 1) -
            Duration(milliseconds: _rightNow.millisecond),
        _updateTime,
      );
    });
  }

  updateSignedIn(bool on) {
    setState(() {
      _gameSignedIn = on;
    });
    _prefs.setBool(GAME_SIGNED_IN, _gameSignedIn);
  }

  @override
  Widget build(BuildContext context) {
    return _HomePageInherited(
      data: this,
      child: widget.child,
    );
  }
}
