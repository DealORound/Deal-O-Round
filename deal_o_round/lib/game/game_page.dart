import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:wakelock/wakelock.dart';
import '../services/settings_constants.dart';
import '../services/size.dart';
import '../services/sound.dart';
import 'logic/board.dart';
import 'logic/game_constants.dart';
import 'logic/hand_class.dart';
import 'logic/level_manager.dart';
import 'logic/play_card.dart';
import 'logic/rules.dart';
import 'logic/scoring.dart';
import 'game_over_page.dart';

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
    return (context.dependOnInheritedWidgetOfExactType<_GamePageInherited>())
        .data;
  }
}

class GameState extends State<GamePage> with SingleTickerProviderStateMixin {
  static const BOARD_SIZE = 5;

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
  bool _inGesture;
  Point<int> _firstTouched;
  Point<int> _lastFlipped;
  bool _swipeGesture;
  List<Point<int>> _selection;
  bool _paused;
  DateTime _pauseStarted;
  int _totalPaused;
  final indexes = Iterable<int>.generate(BOARD_SIZE).toList();
  final indexesEven = Iterable<int>.generate(BOARD_SIZE - 1).toList();
  List<GlobalKey<AnimatedListState>> _listKeys;
  int _animationDelay;
  bool _shouldUnlock;
  bool _selectionBlock;

  DateTime get rightNow => _rightNow;
  int get countDown => max(_countDown - _elapsed, 0);
  int get elapsed => _elapsed;
  int get nextLevel => _nextLevel;
  int get score => _score;
  int get level => _level;
  Board get board => _board;
  String get info => _info;
  bool get paused => _paused;
  BoardLayout get layout => _layout;
  List<GlobalKey<AnimatedListState>> get listKeys => _listKeys;
  int get animationDelay => _animationDelay;

  togglePause() {
    if (countDown <= 0) {
      return;
    }
    if (_paused) {
      Duration difference = _rightNow.difference(_pauseStarted);
      _totalPaused += difference.inSeconds + 1;
    } else {
      _pauseStarted = DateTime.now();
    }
    setState(() {
      _paused = !_paused;
    });
  }

  spin() async {
    if (countDown <= DELAY_OF_SPIN / 1000 + 1) {
      Get.snackbar("Not enough time for spin", "",
          colorText: SB_TEXT, backgroundColor: SB_BACK);
      return;
    }
    if (score <= PRICE_OF_SPIN) {
      Get.snackbar("Not enough points for spin", "",
          colorText: SB_TEXT, backgroundColor: SB_BACK);
      return;
    }
    await Get.find<SoundUtils>().playSoundEffect(SoundEffect.LongCardShuffle);
    setState(() {
      _score -= PRICE_OF_SPIN;
      _board.spin(_listKeys, DELAY_OF_SPIN);
      _selection.clear();
      _clearSelection();
    });
  }

  List<Point<int>> _getNeighbors(Point<int> cell) {
    final neighbors = List<Point<int>>();
    final diagonals = _levelManager.hasDiagonalSelection(_difficulty);
    final maxIndex = BOARD_SIZE - 1;
    final notTop = cell.y > 0;
    if (notTop) {
      neighbors.add(Point(cell.x, cell.y - 1));
    }
    if (_layout == BoardLayout.Square) {
      final notLeft = cell.x > 0;
      final notRight = cell.x < maxIndex;
      if (notTop && diagonals) {
        if (notLeft) {
          neighbors.add(Point(cell.x - 1, cell.y - 1));
        }
        if (notRight) {
          neighbors.add(Point(cell.x + 1, cell.y - 1));
        }
      }
      if (cell.y < maxIndex) {
        neighbors.add(Point(cell.x, cell.y + 1));
        if (diagonals) {
          if (notLeft) {
            neighbors.add(Point(cell.x - 1, cell.y + 1));
          }
          if (notRight) {
            neighbors.add(Point(cell.x + 1, cell.y + 1));
          }
        }
      }
      if (notLeft) {
        neighbors.add(Point(cell.x - 1, cell.y));
      }
      if (notRight) {
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

  bool _hasSelected(List<Point<int>> cells) {
    return cells.fold(false, (f, n) => f || _board.board[n.x][n.y].selected);
  }

  _correctNeighbors(List<Point<int>> neighbors) {
    for (Point<int> neighbor in neighbors) {
      final neighborsOfNeighbor = _getNeighbors(neighbor);
      _board.board[neighbor.x][neighbor.y].neighbor =
          _hasSelected(neighborsOfNeighbor);
    }
  }

  _clearSelection() {
    setState(() {
      for (var cell in _selection) {
        _board.board[cell.x][cell.y].selected = false;
      }
      if (_levelManager.hasNeighborHighlight(_difficulty, true)) {
        for (var x in indexes) {
          final ixs = (_layout == BoardLayout.Hexagonal && x % 2 == 0)
              ? indexesEven
              : indexes;
          for (var y in ixs) {
            _board.board[x][y].neighbor = false;
          }
        }
      }
      _selection.clear();
    });
  }

  List<PlayCard> _getSelectedHand() {
    return _selection.map((s) => _board.board[s.x][s.y]).toList();
  }

  List<Scoring> _rankHands(List<PlayCard> selectedHand) {
    if (selectedHand == null || selectedHand.length == 0) {
      selectedHand = _getSelectedHand();
    }
    return _rules.rankHand(selectedHand, 0, true, true);
  }

  _hitTest(PointerEvent details) {
    if (!_inGesture || _selectionBlock) {
      return;
    }
    final diameter = chipSize(context); // ~80
    final radius = diameter / 2;
    final xIndex = details.localPosition.dx ~/ diameter;
    final colAdj = _layout == BoardLayout.Hexagonal && xIndex % 2 == 0 ? 1 : 0;
    final yAdj = details.localPosition.dy - colAdj * radius;
    final cell = Point<int>(xIndex, yAdj ~/ diameter);
    final dX = radius * (cell.x * 2 + 1) - details.localPosition.dx;
    final dY = radius * (cell.y * 2 + 1 + colAdj) - details.localPosition.dy;

    // Check if the point within the cell is inside the chip circle
    // so corners won't trigger selection
    if (dX * dX + dY * dY < radius * radius) {
      if (_firstTouched.x == -1) {
        _firstTouched = cell;
      } else if (cell.x != _firstTouched.x || cell.y != _firstTouched.y) {
        _swipeGesture = true;
      }
      if ((cell.x != _lastFlipped.x || cell.y != _lastFlipped.y) &&
          _selection.length < 5) {
        bool selected = _board.board[cell.x][cell.y].selected;
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
              neighbors = _getNeighbors(cell);
              if (neighbors.length > 1) {
                List<int> vs =
                    neighbors.map((c) => _getNeighbors(c).length).toList();
                int vProd = vs.fold(1, (f, n) => f * n);
                // If any selected don't have selected neighbors OR
                // If more than 2 selected but there are no selection with
                // 2 or more neighbors (vProd < 2) OR
                // If 4 selected and there are more than two with 1 neighbor
                if (vProd == 0 ||
                    neighbors.length >= 3 && vProd < 2 ||
                    neighbors.length == 4 &&
                        vs.fold(0, (f, n) => f + (n == 1 ? 1 : 0)) > 2) {
                  _clearSelection();
                }
              }
            }
          }
        } else {
          if (_selection.length > 0) {
            // There were already some selected
            // Deselect them if the new selection is not adjacent
            neighbors = _getNeighbors(cell);
            if (!_hasSelected(neighbors)) {
              _clearSelection();
            }
          }
          setState(() {
            _selection.add(cell);
          });
          shouldAdjust = true;
        }
        if (shouldAdjust) {
          setState(() {
            _board.board[cell.x][cell.y].selected = !selected;
            if (_levelManager.hasNeighborHighlight(_difficulty, false)) {
              if (neighbors == null) {
                neighbors = _getNeighbors(cell);
              }
              _correctNeighbors(neighbors);
            }
            _lastFlipped = cell;

            // Update info
            List<Scoring> hands = _rankHands(null);
            if (hands.length > 0) {
              _info = hands[0].toStringDisplay();
            } else {
              _info = "-";
            }
          });
        }
      }
    }
  }

  evaluateAndProcessHand() async {
    if (countDown <= 0) {
      return;
    }
    bool clear = true;
    if (_selection.length >= 2 && countDown > 0) {
      List<Scoring> hands = _rankHands(null);
      if (hands.length > 0) {
        Scoring hand = hands.first;
        if (_shouldUnlock) {
          try {
            await GamesServices.unlock(
                achievement: Achievement(
                    androidID: HAND_ACHIEVEMENTS[hand.handClass],
                    iOSID: 'ios_id',
                    percentComplete: 100));
          } catch (e) {
            debugPrint("Error while submitting hand achievement: ${e.message}");
          }
        }
        final selectedHand = _getSelectedHand();
        final jokerCount = selectedHand.fold(
            0, (count, card) => card.value.index == 13 ? count + 1 : count);
        final multiplier = pow(2, jokerCount);
        final handScore = hand.score() * multiplier;
        AdvancingReturn advancing = await _levelManager.advanceLevels(
            _difficulty, _score, handScore, _nextLevel, _shouldUnlock);

        await Get.find<SoundUtils>().playSoundEffect(SoundEffect.PokerChips);
        setState(() {
          clear = false;
          _score += handScore;
          _countDown += getTimeBonus(hand.handClass);
          _level = _levelManager.getCurrentLevelIndex();
          _countDown += advancing.extraCountDown;
          _nextLevel = advancing.nextLevelScore;

          _selectionBlock = true;
          _board.removeHand(_listKeys, _animationDelay);
          _selection.clear();
          _clearSelection();
        });

        Timer(Duration(milliseconds: (2 * animationDelay * 1.5).toInt()), () {
          _selectionBlock = false;
        });
      }
    }
    if (clear) {
      _clearSelection();
    }
    setState(() {
      _info = "-";
    });
  }

  onPointerDown(PointerEvent details) async {
    _inGesture = true;
    _swipeGesture = false;
    _firstTouched = Point<int>(-1, -1);
    _lastFlipped = Point<int>(-1, -1);
    _hitTest(details);
  }

  onPointerMove(PointerEvent details) async {
    _hitTest(details);
  }

  onPointerUp(PointerEvent details) async {
    _hitTest(details);
    if (_inGesture && _swipeGesture) {
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
    _elapsed = 0;
    _info = "-";
    _inGesture = false;
    _paused = false;
    _totalPaused = 0;
    _prefs = Get.find<SharedPreferences>();
    _difficulty =
        enumFromString(Difficulty.values, _prefs.getString(DIFFICULTY));
    _layout =
        enumFromString(BoardLayout.values, _prefs.getString(BOARD_LAYOUT));
    _countDown = _levelManager.getCurrentLevelTimeLimit(_difficulty);
    _nextLevel = _levelManager.getCurrentLevelScoreLimit(_difficulty);
    _level = _levelManager.getCurrentLevelIndex();
    _board = Board(layout: _layout);
    _listKeys = indexes.map((i) => GlobalKey<AnimatedListState>()).toList();
    _animationDelay = _prefs.getDouble(ANIMATION_SPEED).toInt();
    _shouldUnlock = _prefs.getBool(GAME_SIGNED_IN) &&
        (UniversalPlatform.isAndroid || UniversalPlatform.isIOS);
    _populateBoard();

    final soundUtils = Get.find<SoundUtils>();
    soundUtils.playSoundEffect(SoundEffect.LongCardShuffle).then(
        (c) async => await soundUtils.playSoundTrack(SoundTrack.GuitarMusic));

    Wakelock.enable();
  }

  void _populateBoard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectionBlock = true;
      Timer(Duration(milliseconds: (animationDelay * BOARD_SIZE * 1.5).toInt()),
          () {
        _selectionBlock = false;
      });

      var future = Future(() {});
      for (int i = 0; i < BOARD_SIZE; i++) {
        future = future.then((_) {
          return Future.delayed(Duration(milliseconds: _animationDelay), () {
            for (int j = 0; j < BOARD_SIZE; j++) {
              if (i < BOARD_SIZE - 1 ||
                  j % 2 == 1 ||
                  layout == BoardLayout.Square) {
                _listKeys[j].currentState.insertItem(i);
              }
            }
            if (i == BOARD_SIZE - 1) {
              _started = DateTime.now();
              _updateTime();
            }
          });
        });
      }
    });
  }

  @override
  dispose() {
    // TODO: submit score if it's user induced back navigation #17
    Wakelock.disable();
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
          Get.close(1);
          Get.to(GameOverPage(score: _score));
        }
      }
      // Update once per second, but make sure to do it at the beginning
      // of each new second, so that the clock is accurate.
      _timer = Timer(
        Duration(milliseconds: 1000 - _rightNow.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _GamePageInherited(data: this, child: widget.child);
  }
}
