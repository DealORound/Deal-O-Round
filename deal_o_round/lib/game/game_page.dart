import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/settings_constants.dart';
import '../services/sound.dart';
import 'logic/board.dart';
import 'logic/hand_class.dart';
import 'logic/level_manager.dart';
import 'logic/play_card.dart';
import 'logic/rules.dart';
import 'logic/scoring.dart';
import 'chip_widget.dart';
import 'game_over_widget.dart';

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
    return (
        context.dependOnInheritedWidgetOfExactType<_GamePageInherited>()).data;
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
  BoardLayout _layout = BoardLayout.Hexagonal;
  Difficulty _difficulty = Difficulty.Easy;
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
  final indexesEven = Iterable<int>.generate(boardSize - 1).toList();

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
    if (countDown <= 0) {
      return;
    }
    if (_paused) {
      Duration difference = _rightNow.difference(_pauseStarted);
      _totalPaused += difference.inSeconds;
    } else {
      _pauseStarted = DateTime.now();
    }
    _paused = !_paused;
  }

  spin() {
    if (countDown <= 0) {
      return;
    }
    debugPrint('Spin!');
  }

  List<Point<int>> getNeighbors(Point<int> cell) {
    final neighbors = List<Point<int>>();
    if (cell.y > 0) {
      neighbors.add(Point(cell.x, cell.y - 1));
    }
    final maxIndex = boardSize - 1;
    if (_layout == BoardLayout.Square) {
      if (cell.y < maxIndex) {
        neighbors.add(Point(cell.x, cell.y + 1));
      }
      if (cell.x > 0) {
        neighbors.add(Point(cell.x - 1, cell.y));
      }
      if (cell.x < maxIndex) {
        neighbors.add(Point(cell.x + 1, cell.y));
      }
    } else {
      final shortColumn = cell.x % 2 == 0;
      final colHeight = maxIndex - (shortColumn ? 1 : 0);
      if (cell.y < colHeight) {
        neighbors.add(Point(cell.x, cell.y + 1));
      }
      if (shortColumn) {
        if (cell.x > 0) {
          neighbors.add(Point(cell.x - 1, cell.y));
          neighbors.add(Point(cell.x - 1, cell.y + 1));
        }
        if (cell.x < maxIndex) {
          neighbors.add(Point(cell.x + 1, cell.y));
          neighbors.add(Point(cell.x + 1, cell.y + 1));
        }
      } else {
        if (cell.x > 0) {
          if (cell.y > 0) {
            neighbors.add(Point(cell.x - 1, cell.y - 1));
          }
          if (cell.y < maxIndex) {
            neighbors.add(Point(cell.x - 1, cell.y));
          }
        }
        if (cell.x < maxIndex) {
          if (cell.y > 0) {
            neighbors.add(Point(cell.x + 1, cell.y - 1));
          }
          if (cell.y < maxIndex) {
            neighbors.add(Point(cell.x + 1, cell.y));
          }
        }
      }
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

  clearSelection() {
    for (var cell in _selection) {
      _board.board[cell.x][cell.y].selected = false;
    }
    if (_difficulty == Difficulty.Easy) {
      for (var x in indexes) {
        final ixs = (_layout == BoardLayout.Hexagonal && x % 2 == 0) ?
          indexesEven : indexes;
        for (var y in ixs) {
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
    final xIndex = details.localPosition.dx ~/ ChipWidgetState.chipSize;
    final colAdj = _layout == BoardLayout.Hexagonal && xIndex % 2 == 0 ? 1 : 0;
    final yAdj = details.localPosition.dy - colAdj * ChipWidgetState.chipRadius;
    final cell = Point<int>(xIndex, yAdj ~/ ChipWidgetState.chipSize);
    final dX = ChipWidgetState.chipRadius * (cell.x * 2 + 1) -
        details.localPosition.dx;
    final dY = ChipWidgetState.chipRadius * (cell.y * 2 + 1 + colAdj) -
        details.localPosition.dy;

    // Check if the point within the cell is inside the chip circle
    // so corners won't trigger selection
    final rSquare = ChipWidgetState.chipRadius * ChipWidgetState.chipRadius;
    if (dX * dX + dY * dY < rSquare) {
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
                    clearSelection();
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
                clearSelection();
              }
            }
            _selection.add(cell);
            shouldAdjust = true;
          }
          if (shouldAdjust) {
            _board.board[cell.x][cell.y].selected = !selected;
            if (_difficulty == Difficulty.Easy) {
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

  removeHand() async {
    await Get.find<SoundUtils>().playSoundEffect(
      SoundEffect.PokerChips);

    setState(() {
      _board.removeHand();
      _selection.clear();
      clearSelection();
    });
  }

  evaluateAndProcessHand() async {
    if (countDown <= 0) {
      return;
    }
    bool clear = true;
    if (_selection.length >= 2 && countDown > 0) {
      List<Scoring> hands = getSelectedHands();
      if (hands.length > 0) {
        clear = false;
        Scoring hand = hands.first;
        _score += hand.score();
        _countDown += getTimeBonus(hand.handClass);
        while (_score > _nextLevel) {
          _levelManager.advanceLevel();
          _level = _levelManager.getCurrentLevelIndex();
          _countDown += _levelManager.getCurrentLevelTimeLimit(_difficulty);
          _nextLevel += _levelManager.getCurrentLevelScoreLimit(_difficulty);
        }
        await removeHand();
      }
    }
    if (clear) {
      clearSelection();
    }
    _info = (countDown > 0) ? "-" : "Game ended";
  }

  onPointerDown(PointerEvent details) async {
    _inGesture = true;
    _firstTouched = Point<int>(-1, -1);
    _lastFlipped = Point<int>(-1, -1);
    hitTest(details, "onPointerDown");
  }

  onPointerMove(PointerEvent details) async {
    hitTest(details, "onPointerMove");
  }

  onPointerUp(PointerEvent details) async {
    hitTest(details, "onPointerDown");
    if (_inGesture) {
      await evaluateAndProcessHand();
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
    _prefs = Get.find<SharedPreferences>();
    setState(() {
      _difficulty = enumFromString(
        Difficulty.values,
        _prefs.getString(DIFFICULTY)
      );
      _layout = enumFromString(
          BoardLayout.values,
          _prefs.getString(BOARD_LAYOUT)
      );
      _refreshRate = _prefs.getDouble(REFRESH_RATE);
      _countDown = _levelManager.getCurrentLevelTimeLimit(_difficulty);
      _nextLevel = _levelManager.getCurrentLevelScoreLimit(_difficulty);
      _level = _levelManager.getCurrentLevelIndex();
      _board = Board(layout: _layout, size: boardSize);
      _started = DateTime.now();
      _timerDelay = 1000 ~/ _refreshRate;
      _updateTime();

      final soundUtils = Get.find<SoundUtils>();
      soundUtils.playSoundEffect(
        SoundEffect.ShortCardShuffle).then(
          (c) async => await soundUtils.playSoundTrack(SoundTrack.GuitarMusic)
      );
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
        if (countDown <= 0) {
          final soundUtils = Get.find<SoundUtils>();
          soundUtils.playSoundTrack(SoundTrack.EndMusic);
          Get.close(1);
          Get.to(GameOverWidget());
        }
      }
      // Update once per second, but make sure to do it at the beginning
      // of each new second, so that the clock is accurate.
      _timer = Timer(
        Duration(milliseconds: _timerDelay),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _GamePageInherited(data: this, child: widget.child);
  }
}
