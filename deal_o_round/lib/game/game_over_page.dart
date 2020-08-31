import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:games_services/models/score.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import '../services/settings_constants.dart';
import '../services/size.dart';
import '../services/sound.dart';
import 'logic/game_constants.dart';
import 'background_painter.dart';

class GameOverPage extends StatefulWidget {
  GameOverPage({Key key, this.score}) : super(key: key);

  final int score;

  @override
  _GameOverPageState createState() => _GameOverPageState(score: score);
}

class _GameOverPageState extends State<GameOverPage> {
  final int score;
  String _layoutStr = "Hexagonal";
  String _difficultyStr = "Easy";
  BoardLayout _layout = BoardLayout.Hexagonal;
  Difficulty _difficulty = Difficulty.Easy;

  _GameOverPageState({this.score}) {}

  @override
  initState() {
    super.initState();

    final _prefs = Get.find<SharedPreferences>();
    _difficultyStr = _prefs.getString(DIFFICULTY);
    _difficulty = enumFromString(Difficulty.values, _difficultyStr);
    _layoutStr = _prefs.getString(BOARD_LAYOUT);
    _layout = enumFromString(BoardLayout.values, _layoutStr);
    final gameSignedIn = _prefs.getBool(GAME_SIGNED_IN);
    if (gameSignedIn &&
        (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _submitScore();
      });
    }
    final soundUtils = Get.find<SoundUtils>();
    soundUtils.playSoundTrack(SoundTrack.EndMusic);
  }

  _submitScore() async {
    try {
      await GamesServices.submitScore(
          score: Score(
              androidLeaderboardID: LEADER_BOARDS[_layout][_difficulty],
              iOSLeaderboardID: "ios_leaderboard_id",
              value: score));
    } catch (e) {
      debugPrint("Error while submitting score: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = chipRadius(context); // ~40
    final titleSize = radius * 1.5; // ~60
    final buttonSize = radius * 1.2; // ~48
    final titleStyle = TextStyle(
        fontSize: titleSize, fontFamily: 'Musicals', color: Colors.white);
    final fontSize = radius * 0.8; // ~32
    final textStyle = TextStyle(
        fontSize: fontSize,
        fontFamily: 'Roboto Condensed',
        color: Colors.white);

    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: fontSize),
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              onPressed: () => Get.back(closeOverlays: true),
              child: Icon(Icons.arrow_back, size: radius),
              backgroundColor: Colors.green,
            ),
          ),
        ),
        body: CustomPaint(
            painter: BackgroundPainter(),
            child: Stack(children: <Widget>[
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Text("Game", style: titleStyle),
                    Text("Over", style: titleStyle),
                  ])),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Score:", style: textStyle),
                              Text("$score", style: textStyle),
                            ])),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Difficulty:", style: textStyle),
                              Text(_difficultyStr, style: textStyle),
                              Text("Layout:", style: textStyle),
                              Text(_layoutStr, style: textStyle),
                            ])),
                  ])
            ])));
  }
}
