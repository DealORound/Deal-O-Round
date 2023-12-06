import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/settings_constants.dart';
import '../services/size.dart';
import '../services/sound.dart';
import 'background_painter.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage({super.key, required this.score});

  final int score;

  @override
  _GameOverPageState createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  String _layout = "Hexagonal";
  String _difficulty = "Easy";

  @override
  initState() {
    super.initState();

    final prefs = Get.find<SharedPreferences>();
    _difficulty = prefs.getString(DIFFICULTY) ?? DIFFICULTY_DEFAULT;
    _layout = prefs.getString(BOARD_LAYOUT) ?? BOARD_LAYOUT_DEFAULT;
    final soundUtils = Get.find<SoundUtils>();
    soundUtils.playSoundTrack(SoundTrack.EndMusic);
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
            backgroundColor: Colors.green,
            child: Icon(Icons.arrow_back, size: radius, color: Colors.white),
          ),
        ),
      ),
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Game", style: titleStyle),
                  Text("Over", style: titleStyle),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Score:", style: textStyle),
                      Text("${widget.score}", style: textStyle),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Difficulty:", style: textStyle),
                      Text(_difficulty, style: textStyle),
                      Text("Layout:", style: textStyle),
                      Text(_layout, style: textStyle),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
