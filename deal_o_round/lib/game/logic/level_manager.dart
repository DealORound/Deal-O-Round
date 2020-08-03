import 'dart:math';

import 'level.dart';
import 'rules.dart';

class LevelManager {
  List<Level> levels;
  int currentLevel;
  Rules rules;

  LevelManager({this.rules}) {
    currentLevel = 0;
    // rules = Rule();
    //Levels will proceed in the order they are added
    levels.add(Level(scoreMultiplier: 1.0, timeMultiplier: 1.0));
    levels.add(Level(scoreMultiplier: 1.03, timeMultiplier: 0.98));
    levels.add(Level(scoreMultiplier: 1.06, timeMultiplier: 0.96));
    levels.add(Level(scoreMultiplier: 1.09, timeMultiplier: 0.93));
    levels.add(Level(scoreMultiplier: 1.12, timeMultiplier: 0.90));
    levels.add(Level(scoreMultiplier: 1.15, timeMultiplier: 0.86));
    levels.add(Level(scoreMultiplier: 1.18, timeMultiplier: 0.82));
    levels.add(Level(scoreMultiplier: 1.21, timeMultiplier: 0.78));
    levels.add(Level(scoreMultiplier: 1.24, timeMultiplier: 0.74));
    levels.add(Level(scoreMultiplier: 1.27, timeMultiplier: 0.70));
    levels.add(Level(scoreMultiplier: 1.30, timeMultiplier: 0.60));
    levels.add(Level(scoreMultiplier: 1.33, timeMultiplier: 0.50));
    levels.add(Level(scoreMultiplier: 1.36, timeMultiplier: 0.40));
    levels.add(Level(scoreMultiplier: 1.39, timeMultiplier: 0.30));
    levels.add(Level(scoreMultiplier: 1.42, timeMultiplier: 0.20));
    levels.add(Level(scoreMultiplier: 1.45, timeMultiplier: 0.10));
    levels.add(Level(scoreMultiplier: 1.48, timeMultiplier: 0.05));
    levels.add(Level(scoreMultiplier: 1.51, timeMultiplier: 0.01));
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
