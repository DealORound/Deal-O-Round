import 'dart:math';

import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'game_constants.dart';
import 'level.dart';

class AdvancingReturn {
  final int nextLevelScore;
  final int extraCountDown;

  AdvancingReturn(this.nextLevelScore, this.extraCountDown);
}

class LevelManager {
  late List<Level> levels;
  late int currentLevel;

  LevelManager() {
    currentLevel = 0;
    // Levels will proceed in the order they are added
    levels = [
      Level(1.0, 1.0),
      Level(1.03, 0.98),
      Level(1.06, 0.96),
      Level(1.09, 0.93),
      Level(1.12, 0.90),
      Level(1.15, 0.86),
      Level(1.18, 0.82),
      Level(1.21, 0.78),
      Level(1.24, 0.74),
      Level(1.27, 0.70),
      Level(1.30, 0.60),
      Level(1.33, 0.50),
      Level(1.36, 0.40),
      Level(1.39, 0.30),
      Level(1.42, 0.20),
      Level(1.45, 0.10),
      Level(1.48, 0.05),
      Level(1.51, 0.01),
    ];
  }

  Level getCurrentLevel() {
    return levels[min(levels.length - 1, currentLevel)];
  }

  int getCurrentLevelTimeLimit(Difficulty difficulty) {
    return getCurrentLevel().getTimeLimit(difficulty);
  }

  int getCurrentLevelScoreLimit(Difficulty difficulty) {
    return getCurrentLevel().getScoreLimit(difficulty);
  }

  int getAccumulatedScoreLimit(Difficulty difficulty) {
    int scoreLimit = 0;
    int lvlIndex = 0;
    for (Level level in levels) {
      scoreLimit += level.getScoreLimit(difficulty);
      lvlIndex++;
      if (lvlIndex > currentLevel) break;
    }

    return scoreLimit;
  }

  int getCurrentLevelIndex() {
    return currentLevel + 1;
  }

  advanceLevel() {
    currentLevel++;
  }

  resetLevel() {
    currentLevel = 0;
  }

  Future<AdvancingReturn> advanceLevels(Difficulty difficulty, int currentScore, int handScore,
      int nextLevelScore, bool shouldUnlock) async {
    final newScore = currentScore + handScore;
    int countDown = 0;
    while (newScore > nextLevelScore) {
      advanceLevel();
      if (shouldUnlock) {
        final level = getCurrentLevelIndex();
        if (level <= 25) {
          try {
            GamesServices.unlock(
                achievement: Achievement(
                    androidID: LEVEL_ACHIEVEMENTS[level - 2],
                    iOSID: 'ios_id',
                    percentComplete: 100));
          } on Exception catch (e, stack) {
            debugPrint("Error while submitting level achievement: $e");
            debugPrintStack(stackTrace: stack, label: "trace:");
          }
        }
      }

      countDown += getCurrentLevelTimeLimit(difficulty);
      nextLevelScore += getCurrentLevelScoreLimit(difficulty);
    }

    return AdvancingReturn(nextLevelScore, countDown);
  }

  bool hasNeighborHighlight(Difficulty difficulty, bool previous) {
    final offset = previous ? 1 : 0;
    return difficulty == Difficulty.Easy ||
        difficulty == Difficulty.Medium && currentLevel - offset < 5 ||
        difficulty == Difficulty.Hard && currentLevel - offset < 1;
  }

  bool hasDiagonalSelection(Difficulty difficulty) {
    return difficulty == Difficulty.Easy || difficulty == Difficulty.Medium && currentLevel < 2;
  }
}
