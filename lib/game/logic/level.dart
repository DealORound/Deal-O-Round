import 'game_constants.dart';

class Level {
  double scoreMultiplier;
  late List<int> scoreLimit; // by difficulty
  double timeMultiplier;
  late List<int> timeLimit; // by difficulty
  static const scoreThresholdBase = 7000;
  static const timeThresholdBase = 120;

  Level(this.scoreMultiplier, this.timeMultiplier) {
    final firstLevel = scoreMultiplier < 1.01 && timeMultiplier > 0.99;
    final scoreLimitFloat = scoreThresholdBase * scoreMultiplier;
    final timeLimitFloat = timeThresholdBase * timeMultiplier;
    final scoreLimitInt = scoreLimitFloat.round();
    final timeLimitInt = timeLimitFloat.round();
    if (firstLevel) {
      scoreLimit = [scoreLimitInt, scoreLimitInt, scoreLimitInt];
      timeLimit = [timeLimitInt, timeLimitInt, timeLimitInt];
    } else {
      scoreLimit = [
        scoreLimitInt,
        (scoreLimitFloat * 1.5).round(),
        (scoreLimitFloat * 2).round()
      ];
      timeLimit = [
        timeLimitInt,
        (timeLimitFloat * 0.75).round(),
        (timeLimitFloat * 0.5).round()
      ];
    }
  }

  int getScoreLimit(Difficulty difficulty) {
    return scoreLimit[difficulty.index];
  }

  int getTimeLimit(Difficulty difficulty) {
    return timeLimit[difficulty.index];
  }
}
