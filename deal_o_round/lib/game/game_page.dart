import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/settings_constants.dart';
import 'logic/board.dart';
import 'logic/hand_class.dart';
import 'logic/level_manager.dart';
import 'logic/play_card.dart';
import 'logic/rules.dart';
import 'logic/scoring.dart';
import 'chip_widget.dart';
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
  List<Point<int>> _selection;
  bool _paused;
  DateTime _pauseStarted;
  int _totalPaused;
  final indexes = Iterable<int>.generate(boardSize).toList();

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
    // TODO: change this for hexagonal
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

  bool hasSelected(List<Point<int>> cells) {
    return cells.fold(false, (f, n) => f || _board.board[n.x][n.y].selected);
  }

  correctNeighbors(List<Point<int>> neighbors) {
    for (Point<int> neighbor in neighbors) {
      final neighborsOfNeighbor = getNeighbors(neighbor);
      _board.board[neighbor.x][neighbor.y].neighbor =
          hasSelected(neighborsOfNeighbor);
    }
  }

  clearSelection(Difficulty difficulty) {
    for (var cell in _selection) {
      _board.board[cell.x][cell.y].selected = false;
    }
    if (difficulty == Difficulty.Easy) {
      for (var x in indexes) {
        for (var y in indexes) {
          _board.board[x][y].neighbor = false;
        }
      }
    }
    _selection.clear();
  }

  List<Scoring> getSelectedHands() {
    List<PlayCard> cards = _selection.map((s) =>
      _board.board[s.x][s.y]).toList();
    return _rules.rankHand(cards, 0, false, true, true);
  }

  hitTest(PointerEvent details, String tag) {
    // final dxStr = details.localPosition.dx.toString();
    // final dyStr = details.localPosition.dy.toString();
    // debugPrint("$tag $dxStr, $dyStr; $_swipeGesture");
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
      // debugPrint("c $cell, l $_lastFlipped");
      if (cell.x != _lastFlipped.x || cell.y != _lastFlipped.y) {
        bool selected = _board.board[cell.x][cell.y].selected;
        if (selected || _selection.length < 5) {
          bool shouldAdjust = false;
          List<Point<int>> neighbors;
          if (selected) {
            if (!_swipeGesture) {
              assert(_selection.length > 0);
              // Check if the remaining selection is adjacent
              _selection.remove(cell);
              shouldAdjust = true;
              // Don't check if the removed chip was at a tip of a selection
              if (_selection.length > 1) {
                neighbors = getNeighbors(cell);
                if (neighbors.length > 1) {
                  List<int> vs = neighbors.map((c) =>
                  getNeighbors(c).length).toList();
                  int vProd = vs.fold(1, (f, n) => f * n);
                  // If any selected don't have selected neighbors OR
                  // If more than 2 selected but there are no selection with
                  // 2 or more neighbors (vProd < 2) OR
                  // If 4 selected and there are more than two with 1 neighbor
                  if (vProd == 0 || neighbors.length >= 3 && vProd < 2 ||
                      neighbors.length == 4 &&
                          vs.fold(0, (f, n) => f + (n == 1 ? 1 : 0)) > 2)
                  {
                    clearSelection(difficulty);
                  }
                }
              }
            }
          } else {
            if (_selection.length > 0) {
              // There were already some selected
              // Deselect them if the new selection is not adjacent
              neighbors = getNeighbors(cell);
              if (!hasSelected(neighbors)) {
                clearSelection(difficulty);
              }
            }
            _selection.add(cell);
            shouldAdjust = true;
          }
          if (shouldAdjust) {
            _board.board[cell.x][cell.y].selected = !selected;
            if (difficulty == Difficulty.Easy) {
              if (neighbors == null) {
                neighbors = getNeighbors(cell);
              }
              correctNeighbors(neighbors);
            }
            _lastFlipped = cell;

            // Update info
            List<Scoring> hands = getSelectedHands();
            if (hands.length > 0) {
              _info = hands[0].toStringDisplay();
            } else {
              _info = "-";
            }
          }
        }
      }
    }
  }

  removeHand() {
    _board.removeHand();
    _selection.clear();
  }

  evaluateAndProcessHand() {
    bool clear = true;
    if (_selection.length >= 2) {
      List<Scoring> hands = getSelectedHands();
      if (hands.length > 0) {
        clear = false;
        Scoring hand = hands.first;
        _score += hand.score();
        _countDown += getTimeBonus(hand.handClass);
        while (_score > _nextLevel) {
          _levelManager.advanceLevel();
          _level = _levelManager.getCurrentLevelIndex();
          _countDown += _levelManager.getCurrentLevelTimeLimit(difficulty);
          _nextLevel += _levelManager.getCurrentLevelScoreLimit(difficulty);
        }
        removeHand();
      }
    }
    if (clear) {
      clearSelection(difficulty);
    }
    _info = "-";
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
    if (_inGesture) {
      evaluateAndProcessHand();
    }
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
    _selection = List<Point<int>>();
    _refreshRate = 60;
    _elapsed = 0;
    _info = "-";
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
