import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/settings_constants.dart';

extension on BoardLayout {
  String get inString => describeEnum(this);
}

class _GamePageInherited extends InheritedWidget {
  _GamePageInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final GameState data;

  @override
  bool updateShouldNotify(_GamePageInherited oldWidget) {
    return true;
  }
}

class GamePage extends StatefulWidget {
  GamePage({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  GameState createState() => GameState();

  static GameState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_GamePageInherited>()).data;
  }
}

class GameState extends State<GamePage> with SingleTickerProviderStateMixin {
  var _rightNow;
  var _countDown;
  var _nextLevel;
  var _score;
  var _level;
  var _info;
  Timer _timer;
  SharedPreferences _prefs;
  BoardLayout layout = BoardLayout.Hexagonal;

  DateTime get rightNow => _rightNow;
  int get countDown => _countDown;
  int get nextLevel => _nextLevel;
  int get score => _score;
  int get level => _level;
  String get info => _info;

  @override
  void initState() {
    super.initState();
    _rightNow = DateTime.now();
    _countDown = 120;
    _nextLevel = 7000;
    _score = 0;
    _level = 1;
    _info = "Lorem ipsum dolor sit amet";
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        try {
          final _storedLayout = _prefs.getString(BOARD_LAYOUT);
          if (_storedLayout != null) {
            layout = enumFromString(BoardLayout.values, _storedLayout);;
          } else {
            _prefs.setString(BOARD_LAYOUT, layout.inString);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write $BOARD_LAYOUT settings");
        }
      });
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _rightNow = DateTime.now();
      if (_countDown > 0) {
        _countDown -= 1;
      } else if (_countDown == 0) {
        // End game
        _countDown = -1;
      }
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
    const textStyle = TextStyle(
        fontSize: 64,
        fontFamily: 'Musicals',
        color: Colors.white
    );

    return new _GamePageInherited(
      data: this,
      child: _prefs != null ? widget.child :
        Center(child: Text("Loading...", style: textStyle))
    );
  }
}
