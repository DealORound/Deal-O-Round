import 'dart:math';

import 'level.dart';
import 'rules.dart';

class LevelManager {
  List<Level> levels;
  int currentLevel;
  Rules rules;

  LevelManager({this.rules}) {
    currentLevel = 0;
    rules = Rules();
    // Levels will proceed in the order they are added
    levels = [
      Level(scoreMultiplier: 1.0, timeMultiplier: 1.0),
      Level(scoreMultiplier: 1.03, timeMultiplier: 0.98),
      Level(scoreMultiplier: 1.06, timeMultiplier: 0.96),
      Level(scoreMultiplier: 1.09, timeMultiplier: 0.93),
      Level(scoreMultiplier: 1.12, timeMultiplier: 0.90),
      Level(scoreMultiplier: 1.15, timeMultiplier: 0.86),
      Level(scoreMultiplier: 1.18, timeMultiplier: 0.82),
      Level(scoreMultiplier: 1.21, timeMultiplier: 0.78),
      Level(scoreMultiplier: 1.24, timeMultiplier: 0.74),
      Level(scoreMultiplier: 1.27, timeMultiplier: 0.70),
      Level(scoreMultiplier: 1.30, timeMultiplier: 0.60),
      Level(scoreMultiplier: 1.33, timeMultiplier: 0.50),
      Level(scoreMultiplier: 1.36, timeMultiplier: 0.40),
      Level(scoreMultiplier: 1.39, timeMultiplier: 0.30),
      Level(scoreMultiplier: 1.42, timeMultiplier: 0.20),
      Level(scoreMultiplier: 1.45, timeMultiplier: 0.10),
      Level(scoreMultiplier: 1.48, timeMultiplier: 0.05),
      Level(scoreMultiplier: 1.51, timeMultiplier: 0.01)
    ];
  }

  Level getCurrentLevel() {
    return levels[min(levels.length - 1, currentLevel)];
  }

  int getCurrentLevelTimeLimit(int difficultyIndex) {
    return getCurrentLevel().getTimeLimit(difficultyIndex);
  }

  int getCurrentLevelScoreLimit(int difficultyIndex) {
    return getCurrentLevel().getScoreLimit(difficultyIndex);
  }

  int getAccumulatedScoreLimit(int difficultyIndex) {
    int scoreLimit = 0;
    int lvlIndex = 0;
    for (Level level in levels) {
      scoreLimit += level.getScoreLimit(difficultyIndex);
      lvlIndex++;
      if (lvlIndex > currentLevel)
        break;
    }
    return scoreLimit;
  }

  int getCurrentLevelIndex() {
    return currentLevel + 1;
  }

  void advanceLevel() {
    currentLevel++;
  }

  void resetLevel() {
    currentLevel = 0;
  }
}
