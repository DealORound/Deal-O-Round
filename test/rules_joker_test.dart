import 'dart:math';

import 'package:deal_o_round/game/logic/scoring.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/hand_class.dart';
import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/rules.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

class RuleTestInput {
  List<PlayCard> hand;
  int subHandDrillDownLevel;
  int expectedScore;
  HandClass expectedHand;

  RuleTestInput({
    required this.hand,
    this.subHandDrillDownLevel = 0,
    this.expectedScore = 0,
    this.expectedHand = HandClass.none,
  });
}

main() {
  int offsetRank(PlayCard card) {
    return valueScore(card.value);
  }

  void assertCombination(RuleTestInput ruleTestInput) {
    final rules = Rules();
    final results = rules.rankHand(
      ruleTestInput.hand,
      ruleTestInput.subHandDrillDownLevel,
      true,
      true,
    );
    final score = results.isNotEmpty ? results[0].score() : 0;
    expect(ruleTestInput.expectedScore, score);
  }

  void assertHand(RuleTestInput ruleTestInput) {
    final rules = Rules();
    final results = rules.rankHand(
      ruleTestInput.hand,
      ruleTestInput.subHandDrillDownLevel,
      false,
      true,
    );
    bool hasExpectedHand = false;
    for (Scoring result in results) {
      if (handBaseValue(result.handClass) ==
          handBaseValue(ruleTestInput.expectedHand)) {
        hasExpectedHand = true;
        break;
      }
    }

    expect(hasExpectedHand, true);
  }

  test('Empty hand worth nothing', () async {
    assertCombination(
      RuleTestInput(hand: [], subHandDrillDownLevel: 0, expectedScore: 0),
    );
    assertCombination(
      RuleTestInput(hand: [], subHandDrillDownLevel: 4, expectedScore: 0),
    );
  });

  test('Single hand of joker worth nothing', () async {
    for (Suit suit in blackSuites + redSuites) {
      final hand = [PlayCard(suit, Value.joker)];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 4, expectedScore: 0),
      );
    }
  });

  test('Joker forms a pair with another card', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, Value.joker),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 1 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 4,
            expectedScore: 1 + offset,
          ),
        );
      }
    }
  });

  // Tests for 3 card combinations

  test('Joker can complete a Three of a kind', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, value),
          PlayCard(Suit.spades, Value.joker),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 100 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 4,
            expectedScore: 100 + offset,
          ),
        );
      }
    }
  });

  test('Joker completes combination to lesser straight', () async {
    // When beginning does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i == 0 ? 1 : 0]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.spades, Value.joker),
      ];
      int offset = min(offsetRank(hand[0]), offsetRank(hand[1]));
      int expected = 0;
      if (i < 2 || i == 12) {
        expected = 35;
      } else if (i == 2) {
        expected = 30;
      }

      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: expected + offset,
        ),
      );

      expected = 5 * i + 1; // Low card value + pair base value
      if (i < 2) {
        expected = 35;
      } else if (i == 2) {
        expected = 30;
      }

      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: expected + offset,
        ),
      );
    }

    // When middle does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i == 0 ? 1 : 0]),
        PlayCard(Suit.spades, Value.joker),
      ];
      int offset = min(offsetRank(hand[0]), offsetRank(hand[1]));
      int expected = 0;
      if (i < 2 || i == 12) {
        expected = 35;
      } else if (i == 2) {
        expected = 30;
      }

      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: expected + offset,
        ),
      );

      expected = 5 * i + 1; // Low card value + pair base value
      if (i < 2) {
        expected = 35;
      } else if (i == 2) {
        expected = 30;
      }

      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: expected + offset,
        ),
      );
    }

    // When end does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.joker),
        PlayCard(Suit.spades, Value.values[i == 0 ? 1 : 0]),
      ];
      int offset = min(offsetRank(hand[0]), offsetRank(hand[1]));
      int expected = 0;
      if (i == 0) {
        expected = 35 + offset;
      } else if (i == 1) {
        expected = 30 + offset;
      } else if (i == 2) {
        expected = 20 + offset;
      } else if (i == 12) {
        expected = 35;
      }

      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: expected,
        ),
      );

      if (i > 2) {
        expected = 5 * i + 1; // Low card value + pair base value
      }

      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: expected,
        ),
      );
    }
  });

  test('Flush of 3 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.six),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 15,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 15,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.two),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 15,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 15,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.six),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 15,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 15,
          ),
        );
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.jack),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 15 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 15 + offset,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.seven),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 15 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 15 + offset,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.jack),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 15 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 15 + offset,
          ),
        );
      }
    }
  });

  test('Straight of 3 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.clubs, Value.values[i + 2]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 2]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }
  });

  test('Straight wheel of 3 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.two),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.clubs, Value.ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.clubs, Value.two),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.clubs, Value.ace),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.diamonds, Value.ace),
        PlayCard(Suit.hearts, Value.three),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 30 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }
  });

  test('Straight flush of 3 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.four),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50,
          ),
        );
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.queen),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.queen),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.queen),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }
  });

  test('Straight wheel flush of 3 worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }

    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }

    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }

    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.three),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 50 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 50 + offset,
          ),
        );
      }
    }
  });

  // Tests for 4 card combinations

  test('Four of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, value),
          PlayCard(Suit.spades, value),
          PlayCard(Suit.hearts, value),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 2000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 4,
            expectedScore: 2000 + offset,
          ),
        );
      }
    }
  });

  test('Pair from 4 worth the right points', () async {
    // When beginning does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[11]),
        PlayCard(Suit.clubs, Value.values[12]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 1 + offset,
        ),
      );
    }

    // When middle does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[11]),
        PlayCard(Suit.diamonds, Value.values[12]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 1 + offset,
        ),
      );
    }

    // When end does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.spades, Value.values[11]),
        PlayCard(Suit.spades, Value.values[12]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 1 + offset,
        ),
      );
    }
  });

  test('Two pairs worth the expected score', () async {
    // Ascending
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i + 1]),
      ];
      int offset1 = offsetRank(hand[0]);
      int offset2 = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
    }

    // Descending
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset1 = offsetRank(hand[2]);
      int offset2 = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
    }

    // mixed 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i + 1]),
      ];
      int offset1 = offsetRank(hand[0]);
      int offset2 = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
    }

    // mixed 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset1 = offsetRank(hand[1]);
      int offset2 = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2,
        ),
      );
    }
  });

  test('Two pairs out of 5 found', () async {
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.diamonds, Value.values[i]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[(i + 3) % 13]),
      ];
      assertHand(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.twoPair,
        ),
      );
    }
  });

  test('Flush of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 15),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 15),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
        PlayCard(Suit.values[i], Value.six),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 15),
      );
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
        PlayCard(Suit.values[i], Value.jack),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15 + offset,
        ),
      );
    }
  });

  test('Straight of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 2]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 2]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 30 + offset,
        ),
      );
    }
  });

  test('Straight flush of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 50),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 50),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 50),
      );
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ),
      );
    }
  });

  test('Flush of 4 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.eight),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.eight),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.two),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170,
          ),
        );
      }
    }

    // mixed order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.eight),
          PlayCard(suit, Value.six),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170,
          ),
        );
      }
    }

    // mixed order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.eight),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.two),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170,
          ),
        );
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.king),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170 + offset,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.seven),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170 + offset,
          ),
        );
      }
    }

    // mixed order 3
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.jack),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170 + offset,
          ),
        );
      }
    }

    // mixed order 4
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.jack),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 170 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 170 + offset,
          ),
        );
      }
    }
  });

  test('Straight of 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 2]),
        PlayCard(Suit.spades, Value.values[i + 3]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 3]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 3]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }
  });

  test('Straight wheel of 4 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.two),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.clubs, Value.ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.clubs, Value.two),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.clubs, Value.ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.ace),
        PlayCard(Suit.hearts, Value.three),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 125 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }
  });

  test('Straight flush of 4 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.five),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.five),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250,
          ),
        );
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.queen),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.queen),
          PlayCard(suit, Value.jack),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.queen),
          PlayCard(suit, Value.jack),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }
  });

  test('Straight wheel flush of 4 worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }

    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }

    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }

    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.three),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 250 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 250 + offset,
          ),
        );
      }
    }
  });

  // tests for hands of 5 cards

  test('Four of a kind in 5 worth the right points', () async {
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.invalid, Value.values[i == 0 ? 1 : 0]),
      ];
      int offset = offsetRank(hand[0]);
      // No points of no drill down
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 2000 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 2000 + offset,
        ),
      );
    }
  });

  test('Pair worth expected points', () async {
    // When beginning does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(Suit.hearts, Value.values[0]),
        PlayCard(Suit.hearts, Value.values[11]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 1 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 3,
          expectedScore: 1 + offset,
        ),
      );
    }

    // When middle does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[0]),
        PlayCard(Suit.diamonds, Value.values[11]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 1 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 3,
          expectedScore: 1 + offset,
        ),
      );
    }

    // When end does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.spades, Value.values[0]),
        PlayCard(Suit.spades, Value.values[11]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 1 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 3,
          expectedScore: 1 + offset,
        ),
      );
    }
  });

  test('Two pairs from 5 worth the expected score', () async {
    // Ascending
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset,
        ),
      );
    }

    // Descending
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[2]) + 2 * offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset,
        ),
      );
    }

    // mixed 1
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset,
        ),
      );
    }

    // mixed 2
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[1]) + 2 * offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset,
        ),
      );
    }
  });

  test('Flush of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.invalid, Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.jack),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 2, expectedScore: 15),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.invalid, Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.jack),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 2, expectedScore: 15),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
        PlayCard(Suit.invalid, Value.jack),
        PlayCard(Suit.values[i], Value.six),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 2, expectedScore: 15),
      );
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ace),
        PlayCard(Suit.invalid, Value.jack),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 15 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.invalid, Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.jack),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 15 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.invalid, Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.jack),
        PlayCard(Suit.values[i], Value.jack),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 15 + offset,
        ),
      );
    }
  });

  test('Straight of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 2]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 30 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 2]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 30 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
        PlayCard(Suit.spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 30 + offset,
        ),
      );
    }
  });

  test('Straight flush of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
        PlayCard(Suit.invalid, Value.six),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 50 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
        PlayCard(Suit.invalid, Value.six),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 2, expectedScore: 50),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
        PlayCard(Suit.invalid, Value.six),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 2, expectedScore: 50),
      );
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
        PlayCard(Suit.invalid, Value.six),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 50 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
        PlayCard(Suit.invalid, Value.six),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 50 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.four),
        PlayCard(Suit.invalid, Value.six),
        PlayCard(Suit.values[i], Value.queen),
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 2,
          expectedScore: 50 + offset,
        ),
      );
    }
  });

  test('Flush of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.values[i], Value.eight),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 170),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.eight),
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 170),
      );
    }

    // mixed order 1
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.eight),
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 170),
      );
    }

    // mixed order 2
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.eight),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.six),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 170),
      );
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ),
      );
    }

    // mixed order 3
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ),
      );
    }

    // mixed order 4
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.nine),
        PlayCard(Suit.values[i], Value.seven),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.ten),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ),
      );
    }
  });

  test('Straight of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 2]),
        PlayCard(Suit.spades, Value.values[i + 3]),
        PlayCard(Suit.clubs, Value.two),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // descending order
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 3]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.clubs, Value.two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 3]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.clubs, Value.two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 125 + offset,
        ),
      );
    }
  });

  test('Straight flush of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.five),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.king),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 250),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.king),
        PlayCard(Suit.values[i], Value.five),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.two),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 250),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.three),
        PlayCard(Suit.values[i], Value.two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.king),
        PlayCard(Suit.values[i], Value.four),
        PlayCard(Suit.values[i], Value.five),
      ];
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 1, expectedScore: 250),
      );
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.two),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i], Value.jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.king),
        PlayCard(Suit.values[i], Value.ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.two),
        PlayCard(Suit.values[i], Value.queen),
        PlayCard(Suit.values[i], Value.jack),
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ),
      );
    }
  });

  // Tests for 5 card combinations

  test('Five of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, value),
          PlayCard(Suit.spades, value),
          PlayCard(Suit.hearts, value),
          PlayCard(Suit.clubs, value),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 8000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 4,
            expectedScore: 8000 + offset,
          ),
        );
      }
    }
  });

  test('Flush of 5 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.eight),
          PlayCard(suit, Value.ten),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ten),
          PlayCard(suit, Value.eight),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.two),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300,
          ),
        );
      }
    }

    // mixed order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.eight),
          PlayCard(suit, Value.ten),
          PlayCard(suit, Value.six),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300,
          ),
        );
      }
    }

    // mixed order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.eight),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.ten),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300,
          ),
        );
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.king),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300 + offset,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.five),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300 + offset,
          ),
        );
      }
    }

    // mixed order 3
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.five),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300 + offset,
          ),
        );
      }
    }

    // mixed order 4
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.nine),
          PlayCard(suit, Value.seven),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.five),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 300 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 300 + offset,
          ),
        );
      }
    }
  });

  test('Straight of 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 2]),
        PlayCard(Suit.spades, Value.values[i + 3]),
        PlayCard(Suit.clubs, Value.values[i + 4]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }

    // descending order
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 4]),
        PlayCard(Suit.clubs, Value.values[i + 3]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }

    // mixed order
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 3]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.clubs, Value.values[i + 4]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }
  });

  test('Straight wheel of 5 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.two),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.hearts, Value.five),
        PlayCard(Suit.clubs, Value.ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.hearts, Value.five),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.clubs, Value.two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.hearts, Value.five),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.hearts, Value.five),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.clubs, Value.ace),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.ace),
        PlayCard(Suit.hearts, Value.three),
        PlayCard(Suit.hearts, Value.five),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 200 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 200 + offset,
        ),
      );
    }
  });

  test('Straight flush worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.six),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.five),
        ];
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000,
          ),
        );
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ten),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.queen),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.queen),
          PlayCard(suit, Value.jack),
          PlayCard(suit, Value.ten),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.king),
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.ten),
          PlayCard(suit, Value.queen),
          PlayCard(suit, Value.jack),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }
  });

  test('Straight wheel flush worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }

    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }

    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }

    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.ace),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.five),
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.ace),
          PlayCard(suit, Value.three),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset,
          ),
        );
        assertCombination(
          RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset,
          ),
        );
      }
    }
  });

  test('Full house worth the right points', () async {
    // Basic case
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.invalid, Value.values[i + 1]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[4]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 350 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 350 + offset,
        ),
      );
    }

    // Other end
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.invalid, Value.values[i + 1]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[4]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 350 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 350 + offset,
        ),
      );
    }

    // descending order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.invalid, Value.values[i]),
      ];
      int offset = offsetRank(hand[4]) + 2 * offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 350 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 350 + offset,
        ),
      );
    }

    // descending order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.invalid, Value.values[i]),
      ];
      int offset = offsetRank(hand[4]) + 2 * offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 350 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 350 + offset,
        ),
      );
    }

    // mixed order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.invalid, Value.values[i]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[3]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 350 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 350 + offset,
        ),
      );
    }

    // mixed order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.invalid, Value.values[i + 1]),
      ];
      int offset = offsetRank(hand[3]) + 2 * offsetRank(hand[0]);
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 350 + offset,
        ),
      );
      assertCombination(
        RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 350 + offset,
        ),
      );
    }
  });
}
