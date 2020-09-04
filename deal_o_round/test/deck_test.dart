import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/deck.dart';
import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

main() {
  Deck testDeckCanGiveXCardsCore(bool shuffle, bool hasJokers) {
    final deck = Deck(includeJokers: hasJokers, initialShuffle: shuffle);
    final maxVal = hasJokers && shuffle ? 14 : 13;
    for (int i = 0; i < 52; i++) {
      final playCard = deck.dealCard();
      final suitInt = playCard.suit.index;
      final valueInt = playCard.value.index;
      expect(suitInt >= 0 && suitInt < 4, true);
      expect(valueInt >= 0 && valueInt < maxVal, true);
    }
    return deck;
  }

  void testDeckCannotGiveMoreThanXCardsCore(bool shuffle, bool hasJokers) {
    final deck = Deck(includeJokers: hasJokers, initialShuffle: shuffle);
    final limit = hasJokers ? 54 : 52;
    for (int i = 0; i < limit; i++) {
      deck.dealCard();
    }

    final extraCard = deck.dealCard();
    expect(extraCard.suit, Suit.Invalid);
    expect(extraCard.value, Value.Invalid);
  }

  void testDeckSuppliesDifferentCardsCore(bool shuffle, bool hasJokers) {
    final deck = Deck(includeJokers: hasJokers, initialShuffle: shuffle);
    final cards = List<PlayCard>();
    final limit = hasJokers ? 54 : 52;
    for (int i = 0; i < limit; i++) {
      final playCard = deck.dealCard();
      for (PlayCard card in cards) {
        expect(
            card.suit == playCard.suit && card.value == playCard.value, false);
        expect(playCard.suit != Suit.Invalid, true);
        expect(playCard.value != Value.Invalid, true);
      }
      cards.add(playCard);
    }
  }

  void testDeckIsNotSortedCore(bool hasJokers) async {
    final deck = Deck(includeJokers: hasJokers);
    int cardIndex = 0;
    bool sorted = true;
    while (deck.cardsLeft() > 0 && sorted) {
      final card = deck.dealCard();
      sorted = sorted && (cardIndex ~/ (52 / 4) == card.suit.index);
      sorted = sorted && (cardIndex % (52 / 4) == card.value.index);
      cardIndex++;
      if (!sorted) {
        break;
      }
    }
    expect(sorted, false);
  }

  group('Deck tests', () {
    test('Default deck is without Joker', () async {
      final deck = Deck();
      expect(deck.includeJokers, false);
    });

    test('Default deck has 52 cards', () async {
      final deck = Deck();
      expect(deck.deck.length, 52);
    });

    test('Default deck has 0 cards used', () async {
      final deck = Deck();
      expect(deck.cardsUsed, 0);
    });

    test('Default deck has 52 cards left', () async {
      final deck = Deck();
      expect(deck.cardsLeft(), 52);
    });

    test('Deck with Joker reports fine', () async {
      final deck = Deck(includeJokers: true);
      expect(deck.includeJokers, true);
    });

    test('Deck with Joker has 54 cards', () async {
      final deck = Deck(includeJokers: true);
      expect(deck.cardsLeft(), 54);
    });

    test('Default + unshuffled deck is sorted after construction', () async {
      final deck = Deck(initialShuffle: false);
      int cardIndex = 0;
      while (deck.cardsLeft() > 0) {
        final playCard = deck.dealCard();
        expect(playCard.suit.index, cardIndex ~/ (52 / 4));
        expect(playCard.value.index, cardIndex % (52 / 4));
        cardIndex++;
      }
    });

    test('Unshuffled Joker deck is sorted after construction', () async {
      final deck = Deck(includeJokers: true, initialShuffle: false);
      int cardIndex = 0;
      while (deck.cardsLeft() > 0 && cardIndex < 52) {
        final playCard = deck.dealCard();
        expect(playCard.suit.index, cardIndex ~/ (52 / 4));
        expect(playCard.value.index, cardIndex % (52 / 4));
        cardIndex++;
      }
    });

    test('Deck w/o Joker can deal 52 cards', () async {
      testDeckCanGiveXCardsCore(false, false);
    });

    test('Deck w Joker can deal 54 cards', () async {
      final deck = testDeckCanGiveXCardsCore(false, true);
      var playCard = deck.dealCard();
      expect(BLACK_SUITES.contains(playCard.suit), true);
      expect(playCard.value, Value.Joker);
      playCard = deck.dealCard();
      expect(RED_SUITES.contains(playCard.suit), true);
      expect(playCard.value, Value.Joker);
    });

    test('Deck w/o Joker cannot deal more than 52 cards', () async {
      testDeckCannotGiveMoreThanXCardsCore(false, false);
    });

    test('Deck w/o Joker cannot deal more than 54 cards', () async {
      testDeckCannotGiveMoreThanXCardsCore(false, true);
    });

    test('Deck w/o Joker deals different cards', () async {
      testDeckSuppliesDifferentCardsCore(false, false);
    });

    test('Deck w Joker deals different cards', () async {
      testDeckSuppliesDifferentCardsCore(false, true);
    });

    test('Deck w/o Joker is not sorted after creation', () async {
      testDeckIsNotSortedCore(false);
    });

    test('Deck w Joker is not sorted after creation', () async {
      testDeckIsNotSortedCore(true);
    });

    test('Deck w/o Joker can deal 52 cards (initially shuffled)', () async {
      testDeckCanGiveXCardsCore(true, false);
    });

    test('Deck w Joker can deal 54 cards (initially shuffled)', () async {
      testDeckCanGiveXCardsCore(true, true);
    });

    test('Deck w/o Joker cannot deal more than 52 cards (initially shuffled)',
        () async {
      testDeckCannotGiveMoreThanXCardsCore(true, false);
    });

    test('Deck w Joker cannot deal more than 54 cards (initially shuffled)',
        () async {
      testDeckCannotGiveMoreThanXCardsCore(true, true);
    });

    test('Deck deals different cards (initially shuffled)', () async {
      testDeckSuppliesDifferentCardsCore(true, false);
      testDeckSuppliesDifferentCardsCore(true, true);
    });
  });
}
