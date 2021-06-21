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
    final result = results.isNotEmpty
        ? results[0]
        : Scoring(handClass, hand.length > 0 ? hand[0] : PlayCard(Suit.Invalid, Value.Invalid), "");
    final displayStr = result.toStringDisplay();
    final handDisplayStr = handDisplayString(handClass);
    expect(displayStr.startsWith(handDisplayStr), true);
  }

  test('Empty hand to display', () async {
    toDisplayHand([], HandClass.None);
  });

  test('Single hand to display', () async {
    final hand = [PlayCard(Suit.Clubs, Value.Ten)];
    toDisplayHand(hand, HandClass.None);
  });

  test('Worthless two hand to display', () async {
    final hand = [PlayCard(Suit.Clubs, Value.Ten), PlayCard(Suit.Diamonds, Value.Nine)];
    toDisplayHand(hand, HandClass.None);
  });

  test('Pair to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
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
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
          PlayCard(Suit.Spades, value),
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
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
        ];
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
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
        toDisplayHand(hand, HandClass.Flush3);
      }
    }
  });

  test('Straight of 3 to display', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Clubs, Value.values[i + 2]),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 2]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
  });

  test('Straight wheel of 3 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Two),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Diamonds, Value.Ace),
        PlayCard(Suit.Hearts, Value.Three),
      ];
      toDisplayHand(hand, HandClass.Straight3);
    }
  });

  test('Straight flush of 3 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
        ];
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
      }
    }
  });

  test('Straight wheel flush of 3 to display', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Ace),
        ];
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
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
        toDisplayHand(hand, HandClass.StraightFlush3);
      }
    }
  });

  // Tests for 4 card combinations

  test('Four of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
          PlayCard(Suit.Spades, value),
          PlayCard(Suit.Hearts, value),
        ];
        toDisplayHand(hand, HandClass.FourOfAKind);
      }
    }
  });

  test('Two pairs to display', () async {
    // Ascending
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.Clubs, Value.values[i]));
      hand.add(PlayCard(Suit.Diamonds, Value.values[i]));
      hand.add(PlayCard(Suit.Hearts, Value.values[i + 1]));
      hand.add(PlayCard(Suit.Spades, Value.values[i + 1]));
      toDisplayHand(hand, HandClass.TwoPair);
    }

    // Descending
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.Clubs, Value.values[i + 1]));
      hand.add(PlayCard(Suit.Diamonds, Value.values[i + 1]));
      hand.add(PlayCard(Suit.Hearts, Value.values[i]));
      hand.add(PlayCard(Suit.Spades, Value.values[i]));
      toDisplayHand(hand, HandClass.TwoPair);
    }

    // mixed 1
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.Clubs, Value.values[i]));
      hand.add(PlayCard(Suit.Diamonds, Value.values[i + 1]));
      hand.add(PlayCard(Suit.Hearts, Value.values[i]));
      hand.add(PlayCard(Suit.Spades, Value.values[i + 1]));
      toDisplayHand(hand, HandClass.TwoPair);
    }

    // mixed 2
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.Clubs, Value.values[i + 1]));
      hand.add(PlayCard(Suit.Diamonds, Value.values[i]));
      hand.add(PlayCard(Suit.Hearts, Value.values[i + 1]));
      hand.add(PlayCard(Suit.Spades, Value.values[i]));
      toDisplayHand(hand, HandClass.TwoPair);
    }
  });

  test('Flush of 4 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Eight),
        ];
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
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
        toDisplayHand(hand, HandClass.Flush4);
      }
    }
  });

  test('Straight of 4 to display', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 2]),
        PlayCard(Suit.Spades, Value.values[i + 3]),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 3]),
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.Diamonds, Value.values[i + 2]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 3]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
  });

  test('Straight wheel of 4 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Two),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Clubs, Value.Two),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Ace),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.Diamonds, Value.Two),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Diamonds, Value.Ace),
        PlayCard(Suit.Hearts, Value.Three),
      ];
      toDisplayHand(hand, HandClass.Straight4);
    }
  });

  test('Straight flush of 4 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
        ];
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
      }
    }
  });

  test('Straight wheel flush of 4 to display', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Ace),
        ];
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
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
        toDisplayHand(hand, HandClass.StraightFlush4);
      }
    }
  });

  // tests for hands of 5 cards

  test('Five of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.Clubs, value),
          PlayCard(Suit.Diamonds, value),
          PlayCard(Suit.Spades, value),
          PlayCard(Suit.Hearts, value),
          PlayCard(Suit.Clubs, value),
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
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Six),
          PlayCard(suit, Value.Eight),
          PlayCard(suit, Value.Ten),
        ];
        toDisplayHand(hand, HandClass.Flush5);
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
          PlayCard(suit, Value.Two),
        ];
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
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
        toDisplayHand(hand, HandClass.Flush5);
      }
    }
  });

  test('Straight of 5 to display', () async {
    // Basis case
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 2]),
        PlayCard(Suit.Spades, Value.values[i + 3]),
        PlayCard(Suit.Clubs, Value.values[i + 4]),
      ];
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
    }
  });

  test('Straight wheel of 5 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.Clubs, Value.Two),
        PlayCard(Suit.Diamonds, Value.Three),
        PlayCard(Suit.Hearts, Value.Four),
        PlayCard(Suit.Hearts, Value.Five),
        PlayCard(Suit.Clubs, Value.Ace),
      ];
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
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
      toDisplayHand(hand, HandClass.Straight5);
    }
  });

  test('Straight flush to display', () async {
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
          PlayCard(suit, Value.Jack),
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
          PlayCard(suit, Value.Two),
          PlayCard(suit, Value.Three),
          PlayCard(suit, Value.Four),
          PlayCard(suit, Value.Five),
          PlayCard(suit, Value.Ace),
        ];
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
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
        toDisplayHand(hand, HandClass.StraightFlush5);
      }
    }
  });

  test('Full house to display', () async {
    // Basic case
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }

    // Other end
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Clubs, Value.values[i + 1]),
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }

    // descending order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }

    // descending order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }

    // mixed order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
        PlayCard(Suit.Hearts, Value.values[i]),
        PlayCard(Suit.Spades, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }

    // mixed order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.Clubs, Value.values[i + 1]),
        PlayCard(Suit.Diamonds, Value.values[i]),
        PlayCard(Suit.Hearts, Value.values[i + 1]),
        PlayCard(Suit.Spades, Value.values[i]),
        PlayCard(Suit.Diamonds, Value.values[i + 1]),
      ];
      toDisplayHand(hand, HandClass.FullHouse);
    }
  });
}
