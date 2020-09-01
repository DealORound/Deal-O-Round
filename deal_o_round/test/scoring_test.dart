import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/hand_class.dart';
import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/rules.dart';
import 'package:deal_o_round/game/logic/scoring.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

main() {
  toDisplayHand(List<PlayCard> hand, HandClass handClass) {
    final rules = Rules();
    final results = rules.rankHand(hand, 0, true, true);
    final result = results.isNotEmpty ? results[0] : Scoring();
    final displayStr = result.toStringDisplay();
    final handDisplayStr = handDisplayString(handClass);
    expect(displayStr.startsWith(handDisplayStr), true);
  }

  test('Null hand to display', () async {
    toDisplayHand(null, HandClass.None);
  });

  test('Single hand to display', () async {
    final hand = [PlayCard(suit: Suit.Clubs, value: Value.Ten)];
    toDisplayHand(hand, HandClass.None);
  });

  test('Worthless two hand to display', () async {
    final hand = [
      PlayCard(suit: Suit.Clubs, value: Value.Ten),
      PlayCard(suit: Suit.Diamonds, value: Value.Nine)
    ];
    toDisplayHand(hand, HandClass.None);
  });

  test('Pair to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value)
        ];
        toDisplayHand(hand, HandClass.OnePair);
      }
    }
  });

  // Tests for 3 card combinations
  test('Three of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value),
          PlayCard(suit: Suit.Spades, value: value),
        ];
        toDisplayHand(hand, HandClass.ThreeOfAKind);
      }
    }
  });

  test('Flush of 3 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Six)
        ];
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
      }
    }
  });

  test('Straight of 3 to display', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 2])
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i])
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i])
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
  });

  test('Straight wheel of 3 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
    // Basis case 2
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
    // descending order 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two)
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
    // descending order 2
    {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
    // mixed order
    {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Three)
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
  });

  test('Straight flush of 3 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four)
        ];
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
      }
    }
  });

  test('Straight wheel flush of 3 to display', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
      }
    }
  });

  // Tests for 4 card combinations

  test('Four of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value),
          PlayCard(suit: Suit.Spades, value: value),
          PlayCard(suit: Suit.Hearts, value: value)
        ];
        toDisplayHand(hand, HandClass.FourOfAKind);
      }
    }
  });

  test('Two pairs to display', () async {
    // Ascending
    for (int i = 0; i < 11; i++) {
      final hand = List<PlayCard>();
      hand.add(PlayCard(suit: Suit.Clubs, value: Value.values[i]));
      hand.add(PlayCard(suit: Suit.Diamonds, value: Value.values[i]));
      hand.add(PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]));
      hand.add(PlayCard(suit: Suit.Spades, value: Value.values[i + 1]));
      toDisplayHand(hand, HandClass.TwoPair);
    }
    // Descending
    for (int i = 0; i < 11; i++) {
      final hand = List<PlayCard>();
      hand.add(PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]));
      hand.add(PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]));
      hand.add(PlayCard(suit: Suit.Hearts, value: Value.values[i]));
      hand.add(PlayCard(suit: Suit.Spades, value: Value.values[i]));
      toDisplayHand(hand, HandClass.TwoPair);
    }
    // mixed 1
    for (int i = 0; i < 11; i++) {
      final hand = List<PlayCard>();
      hand.add(PlayCard(suit: Suit.Clubs, value: Value.values[i]));
      hand.add(PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]));
      hand.add(PlayCard(suit: Suit.Hearts, value: Value.values[i]));
      hand.add(PlayCard(suit: Suit.Spades, value: Value.values[i + 1]));
      toDisplayHand(hand, HandClass.TwoPair);
    }
    // mixed 2
    for (int i = 0; i < 11; i++) {
      final hand = List<PlayCard>();
      hand.add(PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]));
      hand.add(PlayCard(suit: Suit.Diamonds, value: Value.values[i]));
      hand.add(PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]));
      hand.add(PlayCard(suit: Suit.Spades, value: Value.values[i]));
      toDisplayHand(hand, HandClass.TwoPair);
    }
  });

  test('Flush of 4 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Six),
          PlayCard(suit: suit, value: Value.Eight)
        ];
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
      }
    }
  });

  test('Straight of 4 to display', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 3])
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
  });

  test('Straight wheel of 4 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
    // Basis case 2
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Clubs, value: Value.Two)
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
    // descending order 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two)
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
    // descending order 2
    {
      final hand = [
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
    // mixed order
    {
      final hand = [
        PlayCard(suit: Suit.Diamonds, value: Value.Two),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Diamonds, value: Value.Ace),
        PlayCard(suit: Suit.Hearts, value: Value.Three)
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
  });

  test('Straight flush of 4 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Five)
        ];
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
      }
    }
  });

  test('Straight wheel flush of 4 to display', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit: suit, value: Value.Two),
          PlayCard(suit: suit, value: Value.Three),
          PlayCard(suit: suit, value: Value.Four),
          PlayCard(suit: suit, value: Value.Ace)
        ];
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
      }
    }
  });

  // tests for hands of 5 cards

  test('Five of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(suit: Suit.Clubs, value: value),
          PlayCard(suit: Suit.Diamonds, value: value),
          PlayCard(suit: Suit.Spades, value: value),
          PlayCard(suit: Suit.Hearts, value: value),
          PlayCard(suit: Suit.Clubs, value: value)
        ];
        toDisplayHand(hand, HandClass.FiveOfAKind);
      }
    }
  });

  test('Flush of 5 to display', () async {
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
      }
    }
  });

  test('Straight of 5 to display', () async {
    // Basis case
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 2]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 3]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 4])
      ];
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
    }
  });

  test('Straight wheel of 5 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.Two),
        PlayCard(suit: Suit.Diamonds, value: Value.Three),
        PlayCard(suit: Suit.Hearts, value: Value.Four),
        PlayCard(suit: Suit.Hearts, value: Value.Five),
        PlayCard(suit: Suit.Clubs, value: Value.Ace)
      ];
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
    }
  });

  test('Straight flush to display', () async {
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
      }
    }
  });

  test('Straight wheel flush to display', () async {
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
      }
    }
  });

  test('Full house to display', () async {
    // Basic case
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1])
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }
    // Other end
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1])
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }
    // descending order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i])
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }
    // descending order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i])
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }
    // mixed order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i]),
        PlayCard(suit: Suit.Spades, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i])
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }
    // mixed order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(suit: Suit.Clubs, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i]),
        PlayCard(suit: Suit.Hearts, value: Value.values[i + 1]),
        PlayCard(suit: Suit.Spades, value: Value.values[i]),
        PlayCard(suit: Suit.Diamonds, value: Value.values[i + 1])
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }
  });
}
