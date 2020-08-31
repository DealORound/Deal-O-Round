import 'package:flutter/material.dart';
import 'hand_class.dart';

enum Difficulty { Easy, Medium, Hard }
enum BoardLayout { Square, Hexagonal }

const Map<HandClass, String> HAND_ACHIEVEMENTS = {
  HandClass.OnePair: "CgkI1Z6JldYeEAIQIQ",
  HandClass.Flush3: "CgkI1Z6JldYeEAIQIg",
  HandClass.Straight3: "CgkI1Z6JldYeEAIQIw",
  HandClass.StraightFlush3: "CgkI1Z6JldYeEAIQKw",
  HandClass.ThreeOfAKind: "CgkI1Z6JldYeEAIQJg",
  HandClass.Straight4: "CgkI1Z6JldYeEAIQJw",
  HandClass.TwoPair: "CgkI1Z6JldYeEAIQJA",
  HandClass.Flush4: "CgkI1Z6JldYeEAIQJQ",
  HandClass.Straight5: "CgkI1Z6JldYeEAIQKg",
  HandClass.StraightFlush4: "CgkI1Z6JldYeEAIQLQ",
  HandClass.Flush5: "CgkI1Z6JldYeEAIQKQ",
  HandClass.FullHouse: "CgkI1Z6JldYeEAIQKA",
  HandClass.FourOfAKind: "CgkI1Z6JldYeEAIQLA",
  HandClass.StraightFlush5: "CgkI1Z6JldYeEAIQLg",
  HandClass.FiveOfAKind: "CgkI1Z6JldYeEAIQAw",
};

const List<String> LEVEL_ACHIEVEMENTS = [
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

const Map<BoardLayout, Map<Difficulty, String>> LEADER_BOARDS = {
  BoardLayout.Square: {
    Difficulty.Easy: "CgkI1Z6JldYeEAIQLw",
    Difficulty.Medium: "CgkI1Z6JldYeEAIQMQ",
    Difficulty.Hard: "CgkI1Z6JldYeEAIQMg",
  },
  BoardLayout.Hexagonal: {
    Difficulty.Easy: "CgkI1Z6JldYeEAIQMw",
    Difficulty.Medium: "CgkI1Z6JldYeEAIQNA",
    Difficulty.Hard: "CgkI1Z6JldYeEAIQNQ",
  },
};

const ABOUT_URL = "https://mrcsabatoth.github.io/DealORoundWebsite/about.html";
const HELP_URL = "https://mrcsabatoth.github.io/DealORoundWebsite/help.html";
const Color SB_TEXT = Colors.white;
final Color SB_BACK = Colors.redAccent.withOpacity(0.5);
const PRICE_OF_SPIN = 200;
const DELAY_OF_SPIN = 2000;
