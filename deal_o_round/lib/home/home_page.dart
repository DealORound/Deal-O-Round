import 'dart:async';

import 'package:deal_o_round/services/settings_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sound.dart';

class _HomePageInherited extends InheritedWidget {
  _HomePageInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final HomePageState data;

  @override
  bool updateShouldNotify(_HomePageInherited oldWidget) {
    return true;
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  HomePageState createState() => HomePageState();

  static HomePageState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_HomePageInherited>())
        .data;
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var _rightNow = DateTime.now();
  Timer _timer;
  SharedPreferences _prefs;
  bool _gameSignedIn = false;

  DateTime get rightNow => _rightNow;
  bool get gameSignedIn => _gameSignedIn;

  @override
  initState() {
    super.initState();
    Get.find<SoundUtils>().playSoundTrack(SoundTrack.SaloonMusic);
    _prefs = Get.find<SharedPreferences>();
    _gameSignedIn = _prefs.getBool(GAME_SIGNED_IN);
    if (_gameSignedIn == null) {
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
        Duration(seconds: 1) - Duration(milliseconds: _rightNow.millisecond),
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
