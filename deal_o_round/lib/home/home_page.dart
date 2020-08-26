import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  DateTime get rightNow => _rightNow;

  @override
  initState() {
    super.initState();
    Get.find<SoundUtils>().playSoundTrack(SoundTrack.SaloonMusic);
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

  @override
  Widget build(BuildContext context) {
    return _HomePageInherited(
      data: this,
      child: widget.child,
    );
  }
}
