import 'package:flutter/material.dart';

import 'hand_class.dart';

enum Difficulty { easy, medium, hard }

enum BoardLayout { square, hexagonal }

const Map<HandClass, String> handAchievements = {
  HandClass.onePair: "CgkI1Z6JldYeEAIQIQ",
  HandClass.flush3: "CgkI1Z6JldYeEAIQIg",
  HandClass.straight3: "CgkI1Z6JldYeEAIQIw",
  HandClass.straightFlush3: "CgkI1Z6JldYeEAIQKw",
  HandClass.threeOfAKind: "CgkI1Z6JldYeEAIQJg",
  HandClass.straight4: "CgkI1Z6JldYeEAIQJw",
  HandClass.twoPair: "CgkI1Z6JldYeEAIQJA",
  HandClass.flush4: "CgkI1Z6JldYeEAIQJQ",
  HandClass.straight5: "CgkI1Z6JldYeEAIQKg",
  HandClass.straightFlush4: "CgkI1Z6JldYeEAIQLQ",
  HandClass.flush5: "CgkI1Z6JldYeEAIQKQ",
  HandClass.fullHouse: "CgkI1Z6JldYeEAIQKA",
  HandClass.fourOfAKind: "CgkI1Z6JldYeEAIQLA",
  HandClass.straightFlush5: "CgkI1Z6JldYeEAIQLg",
  HandClass.fiveOfAKind: "CgkI1Z6JldYeEAIQAw",
};

const List<String> levelAchievements = [
  "CgkI1Z6JldYeEAIQAQ",
  "CgkI1Z6JldYeEAIQCg",
  "CgkI1Z6JldYeEAIQCw",
  "CgkI1Z6JldYeEAIQDA",
  "CgkI1Z6JldYeEAIQDQ",
  "CgkI1Z6JldYeEAIQDg",
  "CgkI1Z6JldYeEAIQDw",
  "CgkI1Z6JldYeEAIQEA",
  "CgkI1Z6JldYeEAIQEQ",
  "CgkI1Z6JldYeEAIQEg",
  "CgkI1Z6JldYeEAIQEw",
  "CgkI1Z6JldYeEAIQFA",
  "CgkI1Z6JldYeEAIQFQ",
  "CgkI1Z6JldYeEAIQFg",
  "CgkI1Z6JldYeEAIQFw",
  "CgkI1Z6JldYeEAIQGA",
  "CgkI1Z6JldYeEAIQGQ",
  "CgkI1Z6JldYeEAIQGg",
  "CgkI1Z6JldYeEAIQGw",
  "CgkI1Z6JldYeEAIQHA",
  "CgkI1Z6JldYeEAIQHQ",
  "CgkI1Z6JldYeEAIQHg",
  "CgkI1Z6JldYeEAIQHw",
  "CgkI1Z6JldYeEAIQIA",
];

const Map<BoardLayout, Map<Difficulty, String>> leaderBoards = {
  BoardLayout.square: {
    Difficulty.easy: "CgkI1Z6JldYeEAIQLw",
    Difficulty.medium: "CgkI1Z6JldYeEAIQMQ",
    Difficulty.hard: "CgkI1Z6JldYeEAIQMg",
  },
  BoardLayout.hexagonal: {
    Difficulty.easy: "CgkI1Z6JldYeEAIQMw",
    Difficulty.medium: "CgkI1Z6JldYeEAIQNA",
    Difficulty.hard: "CgkI1Z6JldYeEAIQNQ",
  },
};

const aboutUrl = "https://mrcsabatoth.github.io/DealORoundWebsite/about.html";
const helpUrl = "https://mrcsabatoth.github.io/DealORoundWebsite/help.html";
const Color snackTextColor = Colors.white;
final Color snackBgColor = Colors.redAccent.withOpacity(0.5);
const priceOfSpin = 200;
const delayOfSpin = 2000;
