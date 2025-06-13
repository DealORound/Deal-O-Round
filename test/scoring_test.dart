import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/hand_class.dart';
import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/rules.dart';
import 'package:deal_o_round/game/logic/scoring.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

void main() {
  toDisplayHand(List<PlayCard> hand, HandClass handClass) {
    final rules = Rules();
    final results = rules.rankHand(hand, 0, true, true);
    final result = results.isNotEmpty
        ? results[0]
        : Scoring(
            handClass,
            hand.isNotEmpty ? hand[0] : PlayCard(Suit.invalid, Value.invalid),
            "",
          );
    final displayStr = result.toStringDisplay();
    final handDisplayStr = handDisplayString(handClass);
    expect(displayStr.startsWith(handDisplayStr), true);
  }

  test('Empty hand to display', () async {
    toDisplayHand([], HandClass.none);
  });

  test('Single hand to display', () async {
    final hand = [PlayCard(Suit.clubs, Value.ten)];
    toDisplayHand(hand, HandClass.none);
  });

  test('Worthless two hand to display', () async {
    final hand = [
      PlayCard(Suit.clubs, Value.ten),
      PlayCard(Suit.diamonds, Value.nine),
    ];
    toDisplayHand(hand, HandClass.none);
  });

  test('Pair to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, value),
        ];
        toDisplayHand(hand, HandClass.onePair);
      }
    }
  });

  // Tests for 3 card combinations
  test('Three of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, value),
          PlayCard(Suit.spades, value),
        ];
        toDisplayHand(hand, HandClass.threeOfAKind);
      }
    }
  });

  test('Flush of 3 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.six),
        ];
        toDisplayHand(hand, HandClass.flush3);
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
        toDisplayHand(hand, HandClass.flush3);
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
        toDisplayHand(hand, HandClass.flush3);
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
        toDisplayHand(hand, HandClass.flush3);
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
        toDisplayHand(hand, HandClass.flush3);
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
        toDisplayHand(hand, HandClass.flush3);
      }
    }
  });

  test('Straight of 3 to display', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.clubs, Value.values[i + 2]),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 2]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }
  });

  test('Straight wheel of 3 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.two),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.clubs, Value.ace),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.clubs, Value.two),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.clubs, Value.ace),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.diamonds, Value.ace),
        PlayCard(Suit.hearts, Value.three),
      ];
      toDisplayHand(hand, HandClass.straight3);
    }
  });

  test('Straight flush of 3 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
        ];
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
      }
    }
  });

  test('Straight wheel flush of 3 to display', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.ace),
        ];
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
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
        toDisplayHand(hand, HandClass.straightFlush3);
      }
    }
  });

  // Tests for 4 card combinations

  test('Four of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, value),
          PlayCard(Suit.spades, value),
          PlayCard(Suit.hearts, value),
        ];
        toDisplayHand(hand, HandClass.fourOfAKind);
      }
    }
  });

  test('Two pairs to display', () async {
    // Ascending
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.clubs, Value.values[i]));
      hand.add(PlayCard(Suit.diamonds, Value.values[i]));
      hand.add(PlayCard(Suit.hearts, Value.values[i + 1]));
      hand.add(PlayCard(Suit.spades, Value.values[i + 1]));
      toDisplayHand(hand, HandClass.twoPair);
    }

    // Descending
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.clubs, Value.values[i + 1]));
      hand.add(PlayCard(Suit.diamonds, Value.values[i + 1]));
      hand.add(PlayCard(Suit.hearts, Value.values[i]));
      hand.add(PlayCard(Suit.spades, Value.values[i]));
      toDisplayHand(hand, HandClass.twoPair);
    }

    // mixed 1
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.clubs, Value.values[i]));
      hand.add(PlayCard(Suit.diamonds, Value.values[i + 1]));
      hand.add(PlayCard(Suit.hearts, Value.values[i]));
      hand.add(PlayCard(Suit.spades, Value.values[i + 1]));
      toDisplayHand(hand, HandClass.twoPair);
    }

    // mixed 2
    for (int i = 0; i < 11; i++) {
      final List<PlayCard> hand = [];
      hand.add(PlayCard(Suit.clubs, Value.values[i + 1]));
      hand.add(PlayCard(Suit.diamonds, Value.values[i]));
      hand.add(PlayCard(Suit.hearts, Value.values[i + 1]));
      hand.add(PlayCard(Suit.spades, Value.values[i]));
      toDisplayHand(hand, HandClass.twoPair);
    }
  });

  test('Flush of 4 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.six),
          PlayCard(suit, Value.eight),
        ];
        toDisplayHand(hand, HandClass.flush4);
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
        toDisplayHand(hand, HandClass.flush4);
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
        toDisplayHand(hand, HandClass.flush4);
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
        toDisplayHand(hand, HandClass.flush4);
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
        toDisplayHand(hand, HandClass.flush4);
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
        toDisplayHand(hand, HandClass.flush4);
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
        toDisplayHand(hand, HandClass.flush4);
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
        toDisplayHand(hand, HandClass.flush4);
      }
    }
  });

  test('Straight of 4 to display', () async {
    // Basis case
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 2]),
        PlayCard(Suit.spades, Value.values[i + 3]),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }

    // descending order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 3]),
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }

    // mixed order
    for (int i = 0; i < 10; i++) {
      final hand = [
        PlayCard(Suit.diamonds, Value.values[i + 2]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 3]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }
  });

  test('Straight wheel of 4 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.two),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.clubs, Value.ace),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }

    // Basis case 2
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.clubs, Value.two),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }

    // descending order 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.ace),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }

    // descending order 2
    {
      final hand = [
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.clubs, Value.ace),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }

    // mixed order
    {
      final hand = [
        PlayCard(Suit.diamonds, Value.two),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.diamonds, Value.ace),
        PlayCard(Suit.hearts, Value.three),
      ];
      toDisplayHand(hand, HandClass.straight4);
    }
  });

  test('Straight flush of 4 to display', () async {
    // Basis case
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.five),
        ];
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
      }
    }
  });

  test('Straight wheel flush of 4 to display', () async {
    // Basis case 1
    for (Suit suit in Suit.values) {
      if (suit.index < 4) {
        final hand = [
          PlayCard(suit, Value.two),
          PlayCard(suit, Value.three),
          PlayCard(suit, Value.four),
          PlayCard(suit, Value.ace),
        ];
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
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
        toDisplayHand(hand, HandClass.straightFlush4);
      }
    }
  });

  // tests for hands of 5 cards

  test('Five of a kind to display', () async {
    for (Value value in Value.values) {
      if (value.index < 13) {
        final hand = [
          PlayCard(Suit.clubs, value),
          PlayCard(Suit.diamonds, value),
          PlayCard(Suit.spades, value),
          PlayCard(Suit.hearts, value),
          PlayCard(Suit.clubs, value),
        ];
        toDisplayHand(hand, HandClass.fiveOfAKind);
      }
    }
  });

  test('Flush of 5 to display', () async {
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
        toDisplayHand(hand, HandClass.flush5);
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
        toDisplayHand(hand, HandClass.flush5);
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
        toDisplayHand(hand, HandClass.flush5);
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
        toDisplayHand(hand, HandClass.flush5);
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
        toDisplayHand(hand, HandClass.flush5);
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
        toDisplayHand(hand, HandClass.flush5);
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
        toDisplayHand(hand, HandClass.flush5);
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
        toDisplayHand(hand, HandClass.flush5);
      }
    }
  });

  test('Straight of 5 to display', () async {
    // Basis case
    for (int i = 0; i < 9; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 2]),
        PlayCard(Suit.spades, Value.values[i + 3]),
        PlayCard(Suit.clubs, Value.values[i + 4]),
      ];
      toDisplayHand(hand, HandClass.straight5);
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
      toDisplayHand(hand, HandClass.straight5);
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
      toDisplayHand(hand, HandClass.straight5);
    }
  });

  test('Straight wheel of 5 to display', () async {
    // Basis case 1
    {
      final hand = [
        PlayCard(Suit.clubs, Value.two),
        PlayCard(Suit.diamonds, Value.three),
        PlayCard(Suit.hearts, Value.four),
        PlayCard(Suit.hearts, Value.five),
        PlayCard(Suit.clubs, Value.ace),
      ];
      toDisplayHand(hand, HandClass.straight5);
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
      toDisplayHand(hand, HandClass.straight5);
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
      toDisplayHand(hand, HandClass.straight5);
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
      toDisplayHand(hand, HandClass.straight5);
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
      toDisplayHand(hand, HandClass.straight5);
    }
  });

  test('Straight flush to display', () async {
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
      }
    }
  });

  test('Straight wheel flush to display', () async {
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
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
        toDisplayHand(hand, HandClass.straightFlush5);
      }
    }
  });

  test('Full house to display', () async {
    // Basic case
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
      ];
      toDisplayHand(hand, HandClass.fullHouse);
    }

    // Other end
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.clubs, Value.values[i + 1]),
      ];
      toDisplayHand(hand, HandClass.fullHouse);
    }

    // descending order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.fullHouse);
    }

    // descending order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.fullHouse);
    }

    // mixed order 1
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
        PlayCard(Suit.hearts, Value.values[i]),
        PlayCard(Suit.spades, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
      ];
      toDisplayHand(hand, HandClass.fullHouse);
    }

    // mixed order 2
    for (int i = 0; i < 11; i++) {
      final hand = [
        PlayCard(Suit.clubs, Value.values[i + 1]),
        PlayCard(Suit.diamonds, Value.values[i]),
        PlayCard(Suit.hearts, Value.values[i + 1]),
        PlayCard(Suit.spades, Value.values[i]),
        PlayCard(Suit.diamonds, Value.values[i + 1]),
      ];
      toDisplayHand(hand, HandClass.fullHouse);
    }
  });
}
