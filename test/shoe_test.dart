import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/deck.dart';
import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/shoe.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

main() {
  testShoeWithoutJokerUnshuffledDecksAreSortedCore(int deckCount) {
    final shoe = Shoe(includeJokers: false, initialShuffle: false);
    for (int deck = 0; deck < deckCount; deck++) {
      for (int cardIndex = 0; cardIndex < 52; cardIndex++) {
        final card = shoe.dealCard();
        expect(cardIndex ~/ (52 / 4), card.suit.index);
        expect(cardIndex % (52 / 4), card.value.index);
        expect(card.deck, deck);
      }
    }
  }

  testShoeWithoutJokerIsNotSortedAfterCreation(int deckCount) {
    final shoe = Shoe(includeJokers: false);
    for (int deck = 0; deck < deckCount; deck++) {
      bool sorted = true;
      for (int cardIdx = 0; cardIdx < 52; cardIdx++) {
        final card = shoe.dealCard();
        sorted = sorted && (cardIdx ~/ (52 / 4) == card.suit.index);
        sorted = sorted && (cardIdx % (52 / 4) != card.value.index);
        expect(card.deck, deck);
      }
      expect(sorted, false);
    }
  }

  testShoeWithoutJokerCanDeal52CardsCore(int deckCount) {
    final shoe = Shoe(includeJokers: false);
    for (int deck = 0; deck < deckCount; deck++) {
      for (int i = 0; i < 52; i++) {
        final card = shoe.dealCard();
        int suitInt = card.suit.index;
        int valueInt = card.value.index;
        expect(suitInt >= 0 && suitInt < 4, true);
        expect(valueInt >= 0 && valueInt < 13, true);
        expect(card.deck, deck);
      }
    }
  }

  testShoeWithoutJokerIsEndlessCore(int deckCount) {
    final shoe = Shoe(includeJokers: false);
    // pulling out three times the decks of cards
    for (int x = 0; x < 3; x++) {
      for (int deck = 0; deck < deckCount; deck++) {
        for (int i = 0; i < 52; i++) {
          final card = shoe.dealCard();
          expect(card.suit != Suit.invalid, true);
          expect(card.value != Value.invalid, true);
          expect(card.deck, x * deckCount + deck);
        }
      }
    }
  }

  testShoeSuppliesDifferentCardsCore(int deckCount) {
    final shoe = Shoe(includeJokers: false);
    for (int deck = 0; deck < deckCount; deck++) {
      final List<PlayCard> cards = [];
      for (int i = 0; i < 52; i++) {
        final playCard = shoe.dealCard();
        for (PlayCard card in cards) {
          expect(card.suit == playCard.suit && card.value == playCard.value,
              false);
          expect(playCard.suit != Suit.invalid, true);
          expect(playCard.value != Value.invalid, true);
          expect(card.deck, deck);
        }
        cards.add(playCard);
      }
    }
  }

  const maxDeckCount = 8;

  group('Shoe tests', () {
    test('Default deck is without Joker', () async {
      final deck = Deck();
      expect(deck.includeJokers, false);
    });

    test('Shoe w/o Joker unshuffled decks are sorted after construction',
        () async {
      for (int deckCount in [1, 2, 3, maxDeckCount]) {
        testShoeWithoutJokerUnshuffledDecksAreSortedCore(deckCount);
      }
    });

    test('Shoe w/o Joker is not sorted after shuffle', () async {
      for (int deckCount in [1, 2, 3, maxDeckCount]) {
        testShoeWithoutJokerIsNotSortedAfterCreation(deckCount);
      }
    });

    test('Shoe w/o Joker can deal 52 cards', () async {
      for (int deckCount in [1, 2, 3, maxDeckCount]) {
        testShoeWithoutJokerCanDeal52CardsCore(deckCount);
      }
    });

    test('Shoe w/o Joker is endless', () async {
      for (int deckCount in [1, 2, 3, maxDeckCount]) {
        testShoeWithoutJokerIsEndlessCore(deckCount);
      }
    });

    test('Shoe deals different cards', () async {
      for (int deckCount in [1, 2, 3, maxDeckCount]) {
        testShoeSuppliesDifferentCardsCore(deckCount);
      }
    });
  });
}
