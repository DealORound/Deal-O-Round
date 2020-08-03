import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/deck.dart';
import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

main() {
  void testDeckWithoutJokerCanGive52CardsCore(bool shuffle) {
    final deck = Deck();
    if (shuffle) {
      deck.shuffle();
    }
    for(int i = 0; i < 52; i++) {
      PlayCard playCard = deck.dealCard();
      final suitInt = playCard.suit.index;
      final valueInt = playCard.value.index;
      expect(suitInt >= 0 && suitInt < 4, true);
      expect(valueInt >= 0 && valueInt < 13, true);
    }
  }

  void testDeckWithoutJokerCannotGiveMoreThan52CardsCore(bool shuffle) {
    final deck = Deck();
    if (shuffle) {
      deck.shuffle();
    }
    for(int i = 0; i < 52; i++) {
      deck.dealCard();
    }

    final extraCard = deck.dealCard();
    expect(extraCard.suit, Suit.Invalid);
    expect(extraCard.value, Value.Invalid);
  }

  void testDeckSuppliesDifferentCardsCore(bool shuffle) {
    final deck = Deck();
    if (shuffle) {
      deck.shuffle();
    }
    final cards = List<PlayCard>();
    for(int i = 0; i < 52; i++) {
      final playCard = deck.dealCard();
      for(PlayCard card in cards) {
        expect(card.suit == playCard.suit && card.value == playCard.value, false);
        expect(playCard.suit != Suit.Invalid, true);
        expect(playCard.value != Value.Invalid, true);
      }
      cards.add(playCard);
    }
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

    test('Deck with Joker has 56 cards', () async {
      final deck = Deck(includeJokers: true);
      expect(deck.cardsLeft(), 56);
    });

    test('Default deck is sorted after construction', () async {
      final deck = Deck();
      int cardIndex = 0;
      while (deck.cardsLeft() > 0) {
        PlayCard playCard = deck.dealCard();
        expect(playCard.suit.index, cardIndex ~/ (52 / 4));
        expect(playCard.value.index, cardIndex % (52 / 4));
        cardIndex++;
      }
    });

    test('Deck w/o Joker can deal 52 cards', () async {
      testDeckWithoutJokerCanGive52CardsCore(false);
    });

    test('Deck w/o Joker cannot deal more than 52 cards', () async {
      testDeckWithoutJokerCannotGiveMoreThan52CardsCore(false);
    });

    test('Deck w/o Joker deals different cards', () async {
      testDeckSuppliesDifferentCardsCore(false);
    });

    test('Deck w/o Joker is not sorted after shuffle', () async {
      final deck = Deck();
      deck.shuffle();
      int cardIndex = 0;
      bool sorted = true;
      while(deck.cardsLeft() > 0 && sorted) {
        PlayCard card = deck.dealCard();
        sorted = sorted && (cardIndex ~/ (52 / 4) == card.suit.index);
        sorted = sorted && (cardIndex % (52 / 4) == card.value.index);
        cardIndex++;
        if (!sorted) {
          break;
        }
      }
      expect(sorted, false);
    });

    test('Deck w/o Joker can deal 52 cards after shuffle', () async {
      testDeckWithoutJokerCanGive52CardsCore(true);
    });

    test('Deck w/o Joker cannot dela more than 52 cards after shuffle', () async {
      testDeckWithoutJokerCannotGiveMoreThan52CardsCore(true);
    });

    test('Deck deals different cards after shuffle', () async {
      testDeckSuppliesDifferentCardsCore(true);
    });
  });
}
