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
    this.expectedHand = HandClass.None,
  });
}

main() {
  int offsetRank(PlayCard card) {
    return valueScore(card.value);
  }

  void assertCombination(RuleTestInput ruleTestInput) {
    final rules = Rules();
    final results = rules.rankHand(
        ruleTestInput.hand, ruleTestInput.subHandDrillDownLevel, true, true);
    final score = results.isNotEmpty ? results[0].score() : 0;
    expect(score, ruleTestInput.expectedScore);
  }

  void assertHand(RuleTestInput ruleTestInput) {
    final rules = Rules();
    final results = rules.rankHand(
        ruleTestInput.hand, ruleTestInput.subHandDrillDownLevel, false, true);
    bool hasExpectedHand = false;
    for (Scoring result in results) {
      if (handBaseValue(result.handClass) ==
          handBaseValue(ruleTestInput.expectedHand)) {
        hasExpectedHand = true;
        break;
      }
    }
    expect(true, hasExpectedHand);
  }

  test('Empty hand worth nothing', () async {
    assertCombination(RuleTestInput(
      hand: [],
      subHandDrillDownLevel: 0,
      expectedScore: 0,
    ));
    assertCombination(RuleTestInput(
      hand: [],
      subHandDrillDownLevel: 4,
      expectedScore: 0,
    ));
  });

  test('Single hand worth nothing', () async {
    final hand = [PlayCard(Suit.Clubs, Value.Ten)];
    assertCombination(RuleTestInput(
      hand: hand,
      subHandDrillDownLevel: 0,
      expectedScore: 0,
    ));
    assertCombination(RuleTestInput(
      hand: hand,
      subHandDrillDownLevel: 4,
      expectedScore: 0,
    ));
  });

  test('Worthless two hand worth nothing', () async {
    final hand = [
      PlayCard(Suit.Clubs, Value.Ten),
      PlayCard(Suit.Diamonds, Value.Nine),
    ];
    assertCombination(RuleTestInput(
      hand: hand,
      subHandDrillDownLevel: 0,
      expectedScore: 0,
    ));
    assertCombination(RuleTestInput(
      hand: hand,
      subHandDrillDownLevel: 4,
      expectedScore: 0,
    ));
  });

  test('Pair worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 1 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 4,
          expectedScore: 1 + offset,
        ));
      }
    }
  });

  // Tests for 3 card combinations

  test('Three of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
          PlayCard(Suit.Spades, value),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 100 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 4,
          expectedScore: 100 + offset,
        ));
      }
    }
  });

  test('Pair from 3 worth the right points', () async {
    // When beginning does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i == 0 ? 1 : 0]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 1 + offset,
      ));
    }

    // When middle does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i == 0 ? 1 : 0]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 1 + offset,
      ));
    }

    // When end does not match up
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i == 0 ? 1 : 0]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 1 + offset,
      ));
    }
  });

  test('Flush of 3 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 15,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Two),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 15,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Six),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 15,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15,
        ));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Jack),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 15 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15 + offset,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Seven),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 15 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15 + offset,
        ));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.Jack),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 15 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 15 + offset,
        ));
      }
    }
  });

  test('Straight of 3 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Clubs, Value.values[i + 2]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 2]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }
  });

  test('Straight wheel of 3 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Two),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Diamonds, Value.Ace),
        PlayCard(Suit.Hearts, Value.Three),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 30 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }
  });

  test('Straight flush of 3 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50,
        ));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Queen),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Queen),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Queen),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }
  });

  test('Straight wheel flush of 3 worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }

    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }

    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }

    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Three),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 50 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 50 + offset,
        ));
      }
    }
  });

  // Tests for 4 card combinations

  test('Four of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
          PlayCard(Suit.Spades, value),
          PlayCard(Suit.Hearts, value),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 2000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 4,
          expectedScore: 2000 + offset,
        ));
      }
    }
  });

  test('Pair from 4 worth the right points', () async {
    // When beginning does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[11]),
        PlayCard(Suit.Clubs, Value.values[12]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 1 + offset,
      ));
    }

    // When middle does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[11]),
        PlayCard(Suit.Diamonds, Value.values[12]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 1 + offset,
      ));
    }

    // When end does not match up
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[11]),
        PlayCard(Suit.Spades, Value.values[12])
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 1 + offset,
      ));
    }
  });

  test('Two pairs worth the expected score', () async {
    // Ascending
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
      ];
      int offset1 = offsetRank(hand[0]);
      int offset2 = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
    }

    // Descending
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset1 = offsetRank(hand[2]);
      int offset2 = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
    }

    // mixed 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
      ];
      int offset1 = offsetRank(hand[0]);
      int offset2 = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
    }

    // mixed 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset1 = offsetRank(hand[1]);
      int offset2 = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset1 + 2 * offset2,
      ));
    }
  });

  test('Two pairs out of 5 found', () async {
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
      ];
      assertHand(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedHand: HandClass.TwoPair));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
        PlayCard(Suit.Diamonds, Value.values[i]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }

    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[(i + 3) % 13]),
      ];
      assertHand(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedHand: HandClass.TwoPair,
      ));
    }
  });

  test('Flush of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 15,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 15,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
        PlayCard(Suit.values[i], Value.Six),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 15,
      ));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 15 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 15 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
        PlayCard(Suit.values[i], Value.Jack),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 15 + offset,
      ));
    }
  });

  test('Straight of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 2]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 2]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0])
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 30 + offset,
      ));
    }
  });

  test('Straight flush of 3 from 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 50,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 50,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 50,
      ));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 50 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 50 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 50 + offset,
      ));
    }
  });

  test('Flush of 4 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Eight),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Two),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170,
        ));
      }
    }

    // mixed order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Six),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170,
        ));
      }
    }

    // mixed order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Two),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170,
        ));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.King),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Seven),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ));
      }
    }

    // mixed order 3
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.Jack),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ));
      }
    }

    // mixed order 4
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Jack),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 170 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 170 + offset,
        ));
      }
    }
  });

  test('Straight of 4 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 2]),
        PlayCard(Suit.Spades, Value.values[i + 3]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 3]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 3]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }
  });

  test('Straight wheel of 4 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Two),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Clubs, Value.Ace)
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Ace),
        PlayCard(Suit.Hearts, Value.Three),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 125 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }
  });

  test('Straight flush of 4 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250,
        ));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Queen),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Queen),
          PlayCard(suit, Value.Jack),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Queen),
          PlayCard(suit, Value.Jack),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }
  });

  test('Straight wheel flush of 4 worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }

    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }

    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }

    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Three),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 250 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 250 + offset,
        ));
      }
    }
  });

  // tests for hands of 5 cards

  test('Four of a kind in 5 worth the right points', () async {
    for (int i = 0; i < 13; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Invalid, Value.values[i == 0 ? 1 : 0]),
      ];
      int offset = offsetRank(hand[0]);
      // No points of no drill down
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 2000 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 2000 + offset,
      ));
    }
  });

  test('Pair worth expected points', () async {
    // When beginning does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(Suit.Hearts, Value.values[0]),
        PlayCard(Suit.Hearts, Value.values[11]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 1 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 3,
        expectedScore: 1 + offset,
      ));
    }

    // When middle does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[0]),
        PlayCard(Suit.Diamonds, Value.values[11]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 1 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 3,
        expectedScore: 1 + offset,
      ));
    }

    // When end does not match up
    for (int i = 1; i < 9; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[0]),
        PlayCard(Suit.Spades, Value.values[11]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 1 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 3,
        expectedScore: 1 + offset,
      ));
    }
  });

  test('Two pairs from 5 worth the expected score', () async {
    // Ascending
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset,
      ));
    }

    // Descending
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[2]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset,
      ));
    }

    // mixed 1
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset,
      ));
    }

    // mixed 2
    for (int i = 2; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Invalid, Value.values[0]),
      ];
      int offset = offsetRank(hand[1]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 150 + offset,
      ));
    }
  });

  test('Flush of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.Invalid, Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Jack),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 15,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.Invalid, Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Jack),
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
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
        PlayCard(Suit.Invalid, Value.Jack),
        PlayCard(Suit.values[i], Value.Six),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 15,
      ));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ace),
        PlayCard(Suit.Invalid, Value.Jack),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 15 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.Invalid, Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Jack),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 15 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.Invalid, Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Jack),
        PlayCard(Suit.values[i], Value.Jack),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 15 + offset,
      ));
    }
  });

  test('Straight of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 2]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 30 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 2]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 30 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
        PlayCard(Suit.Spades, Value.values[i < 2 ? 10 : 0]),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 30 + offset,
      ));
    }
  });

  test('Straight flush of 3 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
        PlayCard(Suit.Invalid, Value.Six),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 50 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
        PlayCard(Suit.Invalid, Value.Six),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 50,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
        PlayCard(Suit.Invalid, Value.Six),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 50,
      ));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
        PlayCard(Suit.Invalid, Value.Six),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 50 + offset,
      ));
    }
    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
        PlayCard(Suit.Invalid, Value.Six),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 50 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Four),
        PlayCard(Suit.Invalid, Value.Six),
        PlayCard(Suit.values[i], Value.Queen),
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 2,
        expectedScore: 50 + offset,
      ));
    }
  });

  test('Flush of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.values[i], Value.Eight),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Eight),
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170,
      ));
    }

    // mixed order 1
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Eight),
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170,
      ));
    }

    // mixed order 2
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Eight),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Six),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170,
      ));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170 + offset,
      ));
    }

    // mixed order 3
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170 + offset,
      ));
    }

    // mixed order 4
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Nine),
        PlayCard(Suit.values[i], Value.Seven),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Ten),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 170 + offset,
      ));
    }
  });

  test('Straight of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 2]),
        PlayCard(Suit.Spades, Value.values[i + 3]),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // descending order
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 3]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }

    // mixed order
    for (int i = 2; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 3]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 125 + offset,
      ));
    }
  });

  test('Straight flush of 4 from 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Five),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.King),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 250,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.King),
        PlayCard(Suit.values[i], Value.Five),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Two),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 250,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Three),
        PlayCard(Suit.values[i], Value.Two),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.King),
        PlayCard(Suit.values[i], Value.Four),
        PlayCard(Suit.values[i], Value.Five),
      ];
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 250,
      ));
    }

    // Same with higher hand
    // Basis case
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Two),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 250 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i], Value.Jack),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 250 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 4; i++) {
      final hand = [
        PlayCard(Suit.values[i], Value.King),
        PlayCard(Suit.values[i], Value.Ace),
        PlayCard(Suit.values[i == 0 ? 1 : 0], Value.Two),
        PlayCard(Suit.values[i], Value.Queen),
        PlayCard(Suit.values[i], Value.Jack),
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 0,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 250 + offset,
      ));
    }
  });

  // Tests for 5 card combinations

  test('Five of a kind worth the right points', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
          PlayCard(Suit.Spades, value),
          PlayCard(Suit.Hearts, value),
          PlayCard(Suit.Clubs, value),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 8000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 4,
          expectedScore: 8000 + offset,
        ));
      }
    }
  });

  test('Flush of 5 worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Ten),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ten),
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Two)
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300,
        ));
      }
    }

    // mixed order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Ten),
          PlayCard(suit, Value.Six),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300,
        ));
      }
    }

    // mixed order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Ten),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300,
        ));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.King),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300 + offset,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.Five),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300 + offset,
        ));
      }
    }

    // mixed order 3
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Five),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300 + offset,
        ));
      }
    }

    // mixed order 4
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Nine),
          PlayCard(suit, Value.Seven),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Five),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 300 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 300 + offset,
        ));
      }
    }
  });

  test('Straight of 5 worth the right points', () async {
    // Basis case
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 2]),
        PlayCard(Suit.Spades, Value.values[i + 3]),
        PlayCard(Suit.Clubs, Value.values[i + 4]),
      ];
      int offset = offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }

    // descending order
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 4]),
        PlayCard(Suit.Clubs, Value.values[i + 3]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      int offset = offsetRank(hand[4]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }

    // mixed order
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 3]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Clubs, Value.values[i + 4]),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }
  });

  test('Straight wheel of 5 worth the right points', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Two),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Hearts, Value.Five),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      int offset = offsetRank(hand[1]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Hearts, Value.Five),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Hearts, Value.Five),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.Hearts, Value.Five),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      int offset = offsetRank(hand[2]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Ace),
        PlayCard(Suit.Hearts, Value.Three),
        PlayCard(Suit.Hearts, Value.Five),
      ];
      int offset = offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 200 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 200 + offset,
      ));
    }
  });

  test('Straight flush worth the right points', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Six),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
        ];
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000,
        ));
      }
    }

    // Same with higher hand
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ten),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Queen),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[0]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }

    // descending order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Queen),
          PlayCard(suit, Value.Jack),
          PlayCard(suit, Value.Ten),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }
    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.King),
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Ten),
          PlayCard(suit, Value.Queen),
          PlayCard(suit, Value.Jack)
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }
  });

  test('Straight wheel flush worth the right points', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[1]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }

    // Basis case 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }

    // descending order 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
        ];
        int offset = offsetRank(hand[3]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }

    // descending order 2
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Ace),
        ];
        int offset = offsetRank(hand[2]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }

    // mixed order
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Ace),
          PlayCard(suit, Value.Three),
        ];
        int offset = offsetRank(hand[4]);
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 0,
          expectedScore: 5000 + offset,
        ));
        assertCombination(RuleTestInput(
          hand: hand,
          subHandDrillDownLevel: 1,
          expectedScore: 5000 + offset,
        ));
      }
    }
  });

  test('Full house worth the right points', () async {
    // Basic case
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Invalid, Value.values[i + 1]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[4]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 350 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 350 + offset,
      ));
    }

    // Other end
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Invalid, Value.values[i + 1]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[4]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 350 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 350 + offset,
      ));
    }

    // descending order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Invalid, Value.values[i]),
      ];
      int offset = offsetRank(hand[4]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 350 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 350 + offset,
      ));
    }

    // descending order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Invalid, Value.values[i]),
      ];
      int offset = offsetRank(hand[4]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 350 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 350 + offset,
      ));
    }

    // mixed order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Invalid, Value.values[i]),
      ];
      int offset = offsetRank(hand[0]) + 2 * offsetRank(hand[3]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 350 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 350 + offset,
      ));
    }

    // mixed order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Invalid, Value.values[i + 1]),
      ];
      int offset = offsetRank(hand[3]) + 2 * offsetRank(hand[0]);
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 0,
        expectedScore: 350 + offset,
      ));
      assertCombination(RuleTestInput(
        hand: hand,
        subHandDrillDownLevel: 1,
        expectedScore: 350 + offset,
      ));
    }
  });
}
