class Level {
  double scoreMultiplier;
  List<int> scoreLimit;	// by difficulty
  double timeMultiplier;
  List<int> timeLimit;	// by difficulty
  static const SCORE_THRESHOLD_BASE = 7000;
  static const TIME_THRESHOLD_BASE = 120;

  Level({this.scoreMultiplier, this.timeMultiplier}) {
    final firstLevel = scoreMultiplier < 1.01 && timeMultiplier > 0.99;
    final scoreLimitFloat = SCORE_THRESHOLD_BASE * scoreMultiplier;
    final timeLimitFloat = TIME_THRESHOLD_BASE * timeMultiplier;
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

  int getScoreLimit(int difficultyIndex) {
    return scoreLimit[difficultyIndex];
  }

  int getTimeLimit(int difficultyIndex) {
    return timeLimit[difficultyIndex];
  }
}
