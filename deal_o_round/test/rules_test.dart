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

  RuleTestInput(
      {this.hand,
      this.subHandDrillDownLevel = 0,
      this.expectedScore = 0,
      this.expectedHand = HandClass.None});
}

main() {
  int offsetRank(PlayCard card) {
    return valueScore(card.value);
  }

  void assertCombination(RuleTestInput ruleTestInput) {
    final rules = Rules();
    final results = rules.rankHand(ruleTestInput.hand,
        ruleTestInput.subHandDrillDownLevel, true, true, true);
    final score = results.isNotEmpty ? results[0].score() : 0;
    expect(ruleTestInput.expectedScore, score);
  }

  void assertHand(RuleTestInput ruleTestInput) {
    final rules = Rules();
    final results = rules.rankHand(ruleTestInput.hand,
        ruleTestInput.subHandDrillDownLevel, true, false, true);
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

  test('Null hand worth nothing', () async {
    assertCombination(
        RuleTestInput(hand: null, subHandDrillDownLevel: 0, expectedScore: 0));
    assertCombination(
        RuleTestInput(hand: null, subHandDrillDownLevel: 4, expectedScore: 0));
  });

  test('Single hand worth nothing', () async {
    final hand = [PlayCard(suit: Suit.Clubs, value: Value.Ten)];
    assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
    assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 4, expectedScore: 0));
  });

  test('Worthless two hand worth nothing', () async {
    final hand = [
      PlayCard(suit: Suit.Clubs, value: Value.Ten),
      PlayCard(suit: Suit.Diamonds, value: Value.Nine)
    ];
    assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
    assertCombination(
        RuleTestInput(hand: hand, subHandDrillDownLevel: 4, expectedScore: 0));
  });

  test('Pair worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 1 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 4, expectedScore: 1 + offset));
      }
    }
  });

  // Tests for 3 card combinations

  test('Three of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value),
          PlayCard(suit: Suit.Spades, value: value)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 100 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 4, expectedScore: 100 + offset));
      }
    }
  });

  test('Pair from 3 worth the right points', () async {
    // When beginning does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i == 0 ? 1 : 0]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 1 + offset));
    }
    // When middle does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i == 0 ? 1 : 0]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 1 + offset));
    }
    // When end does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i == 0 ? 1 : 0])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 1 + offset));
    }
  });

  test('Flush of 3 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Six)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 15));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 15));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Two)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 15));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 15));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Six)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 15));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 15));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Jack)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 15 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 15 + offset));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Seven)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 15 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 15 + offset));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.Jack)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 15 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 15 + offset));
      }
    }
  });

  test('Straight of 3 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 2])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
  });

  test('Straight wheel of 3 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // Basis case 2
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // descending order 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // descending order 2
    {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // mixed order
    {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Three)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 30 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
  });

  test('Straight flush of 3 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Four)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Queen),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Queen)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Queen)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }
  });

  test('Straight wheel flush of 3 worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }

    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }
    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }
    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Three)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 50 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
      }
    }
  });

  // Tests for 4 card combinations

  test('Four of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value),
          PlayCard(suit: Suit.Spades, value: value),
          PlayCard(suit: Suit.Hearts, value: value)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 2000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 4,
            expectedScore: 2000 + offset));
      }
    }
  });

  test('Pair from 4 worth the right points', () async {
    // When beginning does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[11]),
        PlayCard(suit: Suit.Clubs, value: Value.values[12]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 1 + offset));
    }
    // When middle does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[11]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[12]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 1 + offset));
    }
    // When end does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[11]),
        PlayCard(suit: Suit.Spades, value: Value.values[12])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 1 + offset));
    }
  });

  test('Two pairs worth the expected score', () async {
    // Ascending
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1])
      ];
      int offset1 = offsetRank(hand[0]);
      int offset2 = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2));
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2));
    }
    // Descending
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset1 = offsetRank(hand[2]);
      int offset2 = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2));
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2));
    }
    // mixed 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1])
      ];
      int offset1 = offsetRank(hand[0]);
      int offset2 = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2));
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2));
    }
    // mixed 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset1 = offsetRank(hand[1]);
      int offset2 = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 150 + offset1 + 2 * offset2));
      assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 150 + offset1 + 2 * offset2));
    }
  });

  test('Two pairs out of 5 found', () async {
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[(i + 3) % 13])
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }
  });

  test('Flush of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 15));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 15));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace),
        PlayCard(suit: Suit.values[i], value: Value.Six)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 15));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 15 + offset));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 15 + offset));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace),
        PlayCard(suit: Suit.values[i], value: Value.Jack)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 15 + offset));
    }
  });

  test('Straight of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 30 + offset));
    }
  });

  test('Straight flush of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 50));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 50));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 50));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 50 + offset));
    }
  });

  test('Flush of 4 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Eight)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Eight),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Two)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
      }
    }
    // mixed order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Eight),
          PlayCard(suit: suit, value: Value.Six)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
      }
    }
    // mixed order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Eight),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Two)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.King)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Seven)
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
      }
    }
    // mixed order 3
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.Jack)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
      }
    }
    // mixed order 4
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Jack)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 170 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
      }
    }
  });

  test('Straight of 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 3])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
  });

  test('Straight wheel of 4 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // Basis case 2
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // descending order 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // descending order 2
    {
      final hand = [
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // mixed order
    {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Three)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 125 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
  });

  test('Straight flush of 4 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Five)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Five)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Queen),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Queen),
          PlayCard(suit: suit, value: Value.Jack)
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Queen),
          PlayCard(suit: suit, value: Value.Jack)
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
  });

  test('Straight wheel flush of 4 worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Three)
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 250 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
      }
    }
  });

  // tests for hands of 5 cards

  test('Four of a kind in 5 worth the right points', () async {
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Invalid, value: Value.values[i == 0 ? 1 : 0])
      ];
      int offset = offsetRank(hand[0]);
      // No points of no drill down
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 2000 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 2000 + offset));
    }
  });

  test('Pair worth expected points', () async {
    // When beginning does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(suit: Suit.Hearts, value: Value.values[0]),
        PlayCard(suit: Suit.Hearts, value: Value.values[11]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 1 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 3, expectedScore: 1 + offset));
    }
    // When middle does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[0]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[11]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 1 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 3, expectedScore: 1 + offset));
    }
    // When end does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[0]),
        PlayCard(suit: Suit.Spades, value: Value.values[11])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 1 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 3, expectedScore: 1 + offset));
    }
  });

  test('Two pairs from 5 worth the expected score', () async {
    // Ascending
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Invalid, value: Value.values[0])
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 150 + offset));
    }
    // Descending
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Invalid, value: Value.values[0])
      ];
      int offset = offsetRank(hand[2]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 150 + offset));
    }
    // mixed 1
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Invalid, value: Value.values[0])
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 150 + offset));
    }
    // mixed 2
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Invalid, value: Value.values[0])
      ];
      int offset = offsetRank(hand[1]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 150 + offset));
    }
  });

  test('Flush of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.Invalid, value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Jack)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 15));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.Invalid, value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Jack)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 15));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace),
        PlayCard(suit: Suit.Invalid, value: Value.Jack),
        PlayCard(suit: Suit.values[i], value: Value.Six)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 15));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ace),
        PlayCard(suit: Suit.Invalid, value: Value.Jack)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 15 + offset));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.Invalid, value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Jack)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 15 + offset));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.Invalid, value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Jack),
        PlayCard(suit: Suit.values[i], value: Value.Jack)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 15 + offset));
    }
  });

  test('Straight of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 30 + offset));
    }
    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 30 + offset));
    }
    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0]),
        PlayCard(suit: Suit.Spades, value: Value.values[i < 2 ? 10 : 0])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 30 + offset));
    }
  });

  test('Straight flush of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four),
        PlayCard(suit: Suit.Invalid, value: Value.Six)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 50 + offset));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four),
        PlayCard(suit: Suit.Invalid, value: Value.Six)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 50));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four),
        PlayCard(suit: Suit.Invalid, value: Value.Six)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 50));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four),
        PlayCard(suit: Suit.Invalid, value: Value.Six)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 50 + offset));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four),
        PlayCard(suit: Suit.Invalid, value: Value.Six)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 50 + offset));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Four),
        PlayCard(suit: Suit.Invalid, value: Value.Six),
        PlayCard(suit: Suit.values[i], value: Value.Queen)
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 2, expectedScore: 50 + offset));
    }
  });

  test('Flush of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.values[i], value: Value.Eight),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Eight),
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
    }
    // mixed order 1
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Eight),
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
    }
    // mixed order 2
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Eight),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Six),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
    }
    // mixed order 3
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
    }
    // mixed order 4
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Nine),
        PlayCard(suit: Suit.values[i], value: Value.Seven),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Ten)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 170 + offset));
    }
  });

  test('Straight of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // descending order
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
    // mixed order
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 125 + offset));
    }
  });

  test('Straight flush of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Five),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.King)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 250));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Five),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Two)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 250));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Three),
        PlayCard(suit: Suit.values[i], value: Value.Two),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Four),
        PlayCard(suit: Suit.values[i], value: Value.Five)
      ];
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 250));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Ace)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i], value: Value.Jack),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Two)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
    }
    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(suit: Suit.values[i], value: Value.King),
        PlayCard(suit: Suit.values[i], value: Value.Ace),
        PlayCard(suit: Suit.values[i == 0 ? 1 : 0], value: Value.Two),
        PlayCard(suit: Suit.values[i], value: Value.Queen),
        PlayCard(suit: Suit.values[i], value: Value.Jack)
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 0));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 250 + offset));
    }
  });

  // Tests for 5 card combinations

  test('Five of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value),
          PlayCard(suit: Suit.Spades, value: value),
          PlayCard(suit: Suit.Hearts, value: value),
          PlayCard(suit: Suit.Clubs, value: value)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 10000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 4,
            expectedScore: 10000 + offset));
      }
    }
  });

  test('Flush of 5 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Eight),
          PlayCard(suit: suit, value: Value.Ten)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ten),
          PlayCard(suit: suit, value: Value.Eight),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Two)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300));
      }
    }
    // mixed order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Eight),
          PlayCard(suit: suit, value: Value.Ten),
          PlayCard(suit: suit, value: Value.Six)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300));
      }
    }
    // mixed order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Eight),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Ten)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.King)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300 + offset));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.Five)
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300 + offset));
      }
    }
    // mixed order 3
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Five)
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300 + offset));
      }
    }
    // mixed order 4
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Nine),
          PlayCard(suit: suit, value: Value.Seven),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Five)
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 300 + offset));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 300 + offset));
      }
    }
  });

  test('Straight of 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 4])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
    // descending order
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 4]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
    // mixed order
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 4])
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
  });

  test('Straight wheel of 5 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Hearts, value: Value.Five),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
    // Basis case 2
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Five),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
    // descending order 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Five),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
    // descending order 2
    {
      final hand = [
        PlayCard(suit: Suit.Hearts, value: Value.Five),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
    // mixed order
    {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Three),
        PlayCard(suit: Suit.Hearts, value: Value.Five)
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 200 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 200 + offset));
    }
  });

  test('Straight flush worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Six)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 5000));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 5000));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 5000));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 5000));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Five)
        ];
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 0, expectedScore: 5000));
        assertCombination(RuleTestInput(
            hand: hand, subHandDrillDownLevel: 1, expectedScore: 5000));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ten),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Queen),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Queen),
          PlayCard(suit: suit, value: Value.Jack),
          PlayCard(suit: suit, value: Value.Ten)
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.King),
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Ten),
          PlayCard(suit: suit, value: Value.Queen),
          PlayCard(suit: suit, value: Value.Jack)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
  });

  test('Straight wheel flush worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two)
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Five),
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Ace),
          PlayCard(suit: suit, value: Value.Three)
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 0,
            expectedScore: 5000 + offset));
        assertCombination(RuleTestInput(
            hand: hand,
            subHandDrillDownLevel: 1,
            expectedScore: 5000 + offset));
      }
    }
  });

  test('Full house worth the right points', () async {
    // Basic case
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Invalid, value: Value.values[i + 1])
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[4]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 350 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 350 + offset));
    }
    // Other end
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Invalid, value: Value.values[i + 1])
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[4]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 350 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 350 + offset));
    }
    // descending order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Invalid, value: Value.values[i])
      ];
      int offset = offsetRank(hand[4]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 350 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 350 + offset));
    }
    // descending order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Invalid, value: Value.values[i])
      ];
      int offset = offsetRank(hand[4]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 350 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 350 + offset));
    }
    // mixed order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Invalid, value: Value.values[i])
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[3]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 350 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 350 + offset));
    }
    // mixed order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Invalid, value: Value.values[i + 1])
      ];
      int offset = offsetRank(hand[3]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 0, expectedScore: 350 + offset));
      assertCombination(RuleTestInput(
          hand: hand, subHandDrillDownLevel: 1, expectedScore: 350 + offset));
    }
  });
}
