import 'dart:async';
import 'dart:math';

import 'package:deal_o_round/game/chip_widget.dart';
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
  static const boardSize = 5;

  DateTime _rightNow;
  DateTime _started;
  int _countDown;
  int _nextLevel;
  int _score;
  int _level;
  String _info;
  Timer _timer;
  SharedPreferences _prefs;
  BoardLayout layout = BoardLayout.Hexagonal;
  Difficulty difficulty = Difficulty.Easy;
  LevelManager _levelManager;
  Board _board;
  Rules _rules;
  int _elapsed;
  double _refreshRate;
  int _timerDelay;
  bool _inGesture;
  Point<int> _firstTouched;
  Point<int> _lastFlipped;
  bool _swipeGesture;
  int _selected;
  bool _paused;
  DateTime _pauseStarted;
  int _totalPaused;

  DateTime get rightNow => _rightNow;
  int get countDown => max(_countDown - _elapsed, 0);
  int get elapsed => _elapsed;
  int get nextLevel => _nextLevel;
  int get score => _score;
  int get level => _level;
  Board get board => _board;
  String get info => _info;
  bool get paused => _paused;

  togglePause() {
    if (_paused) {
      Duration difference = _rightNow.difference(_pauseStarted);
      _totalPaused += difference.inSeconds;
    } else {
      _pauseStarted = DateTime.now();
    }
    _paused = !_paused;
  }

  List<Point<int>> getNeighbors(Point<int> cell) {
    final neighbors = List<Point<int>>();
    if (cell.x > 0) {
      neighbors.add(Point(cell.x - 1, cell.y));
    }
    if (cell.y > 0) {
      neighbors.add(Point(cell.x, cell.y - 1));
    }
    if (cell.x < boardSize - 1) {
      neighbors.add(Point(cell.x + 1, cell.y));
    }
    if (cell.y < boardSize - 1) {
      neighbors.add(Point(cell.x, cell.y + 1));
    }
    return neighbors;
  }

  correctNeighbors(Point<int> cell) {
    for (Point<int> neighbor in getNeighbors(cell)) {
      final neighborsOfNeighbor = getNeighbors(neighbor);
      _board.board[neighbor.x][neighbor.y].neighbor =
          neighborsOfNeighbor.fold(false, (f, n) =>
              f || _board.board[n.x][n.y].selected);
    }
  }

  hitTest(PointerEvent details, String tag) {
    final dxStr = details.localPosition.dx.toString();
    final dyStr = details.localPosition.dy.toString();
    debugPrint("$tag $dxStr, $dyStr");
    if (!_inGesture) {
      return;
    }
    final cell = Point<int>(
        details.localPosition.dx ~/ ChipWidgetState.chipSize,
        details.localPosition.dy ~/ ChipWidgetState.chipSize
    );
    final dx = ChipWidgetState.chipRadius * (cell.x * 2 + 1) -
        details.localPosition.dx;
    final dy = ChipWidgetState.chipRadius * (cell.y * 2 + 1) -
        details.localPosition.dy;
    // Check if the point within the cell is inside the chip circle
    // so corners won't trigger selection
    final rSquare = ChipWidgetState.chipRadius * ChipWidgetState.chipRadius;
    if (dx * dx + dy * dy < rSquare) {
      if (_firstTouched.x == -1) {
        _firstTouched = cell;
      } else if (cell.x != _firstTouched.x && cell.y != _firstTouched.y) {
        _swipeGesture = true;
      }
      if (cell.x != _lastFlipped.x && cell.y != _lastFlipped.y) {
        bool selected = _board.board[cell.x][cell.y].selected;
        if (selected) {
          assert(_selected > 0);
          _selected -= 1;
        } else {
          _selected += 1;
        }
        if (selected || _selected < 4) {
          // TODO: things to do with the selection
          _board.board[cell.x][cell.y].selected = !selected;
          if (difficulty == Difficulty.Easy) {
            correctNeighbors(cell);
          }
          _lastFlipped = cell;
        }
      }
    }
  }

  onPointerDown(PointerEvent details) {
    _inGesture = true;
    _firstTouched = Point<int>(-1, -1);
    _lastFlipped = Point<int>(-1, -1);
    hitTest(details, "onPointerDown");
  }

  onPointerMove(PointerEvent details) {
    hitTest(details, "onPointerMove");
  }

  onPointerUp(PointerEvent details) {
    hitTest(details, "onPointerDown");
    // TODO eval selection if it was swipe
    _inGesture = false;
    _swipeGesture = false;
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
    _inGesture = false;
    _paused = false;
    _totalPaused = 0;
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
        _board = Board(layout: layout, size: boardSize);
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
      if (!_paused) {
        Duration difference = _rightNow.difference(_started);
        _elapsed = difference.inSeconds - _totalPaused;
      }
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
