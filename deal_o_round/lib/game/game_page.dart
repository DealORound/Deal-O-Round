import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/settings_constants.dart';
import 'logic/board.dart';
import 'logic/level_manager.dart';
import 'logic/rules.dart';
import 'loading_widget.dart';

extension on BoardLayout {
  String get inString => describeEnum(this);
}

extension on Difficulty {
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
  static const size = 5;

  var _rightNow;
  var _started;
  var _countDown;
  var _nextLevel;
  var _score;
  var _level;
  var _info;
  Timer _timer;
  SharedPreferences _prefs;
  BoardLayout layout = BoardLayout.Hexagonal;
  Difficulty difficulty = Difficulty.Easy;
  LevelManager _levelManager;
  Board _board;
  Rules _rules;
  int _selected;
  int _elapsed;
  double _refreshRate;
  int _timerDelay;
  bool _inGesture;
  int _lastSelectedX;
  int _lastSelectedY;

  DateTime get rightNow => _rightNow;
  int get countDown => max(_countDown - _elapsed, 0);
  int get elapsed => _elapsed;
  int get nextLevel => _nextLevel;
  int get score => _score;
  int get level => _level;
  Board get board => _board;
  String get info => _info;

  incrementSelected() {
    _selected += 0;
  }

  setElapsed(int seconds) {
    _elapsed = seconds;
  }

  hitTest(PointerEvent details, String tag) {
    final dxStr = details.localPosition.dx.toString();
    final dyStr = details.localPosition.dy.toString();
    debugPrint("$tag $dxStr, $dyStr");
    if (_inGesture) {
      return;
    }
    final cx = details.localPosition.dx ~/ 80;
    final cy = details.localPosition.dy ~/ 80;
    if (cx != _lastSelectedX && cy != _lastSelectedY || details.pressure > 2.0) {
      final dx = cx * 80 + 40 - details.localPosition.dx;
      final dy = cy * 80 + 40 - details.localPosition.dy;
      if (dx * dx + dy * dy < 40 * 40) {
        bool selected = _board.board[cx][cy].selected;  // size - cy - 1
        _board.board[cx][cy].selected = !selected;  // size - cy - 1
        _lastSelectedX = cx;
        _lastSelectedY = cy;
      }
    }
  }

  onPointerDown(PointerEvent details) {
    _inGesture = true;
    _lastSelectedX = -1;
    _lastSelectedY = -1;
    hitTest(details, "onPointerDown");
  }

  onPointerMove(PointerEvent details) {
    hitTest(details, "onPointerMove");
  }

  onPointerUp(PointerEvent details) {
    _inGesture = false;
    hitTest(details, "onPointerDown");
    _lastSelectedX = -1;
    _lastSelectedY = -1;
  }

  @override
  initState() {
    super.initState();
    _rightNow = DateTime.now();
    _levelManager = LevelManager();
    _rules = Rules();
    _score = 0;
    _selected = 0;
    _refreshRate = 60;
    _elapsed = 0;
    _info = "Lorem ipsum dolor sit amet";
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        try {
          final _storedLayout = _prefs.getString(BOARD_LAYOUT);
          if (_storedLayout != null) {
            layout = enumFromString(BoardLayout.values, _storedLayout);
          } else {
            _prefs.setString(BOARD_LAYOUT, layout.inString);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write $BOARD_LAYOUT settings");
        }

        try {
          final _storedDifficulty = _prefs.getString(DIFFICULTY);
          if (_storedDifficulty != null) {
            difficulty = enumFromString(Difficulty.values, _storedDifficulty);
          } else {
            _prefs.setString(DIFFICULTY, difficulty.inString);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write $DIFFICULTY settings");
        }

        try {
          final _storedRefreshRate = _prefs.getDouble(REFRESH_RATE);
          if (_storedRefreshRate != null) {
            _refreshRate = _storedRefreshRate;
          } else {
            _prefs.setDouble(REFRESH_RATE, _refreshRate);
          }
        }
        on ArgumentError {
          debugPrint("Could not read or write $DIFFICULTY settings");
        }

        _countDown = _levelManager.getCurrentLevelTimeLimit(difficulty);
        _nextLevel = _levelManager.getCurrentLevelScoreLimit(difficulty);
        _level = _levelManager.getCurrentLevelIndex();
        _board = Board(layout: layout, size: size);
        _started = DateTime.now();
        _timerDelay = 1000 ~/ _refreshRate;
        _updateTime();
      });
    });
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _updateTime() {
    setState(() {
      _rightNow = DateTime.now();
      Duration difference = _rightNow.difference(_started);
      setElapsed(difference.inSeconds);
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(milliseconds: _timerDelay),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _GamePageInherited(
      data: this,
      child: _prefs == null ? LoadingWidget() : widget.child
    );
  }
}
