import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/deck.dart';
import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/shoe.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

main() {
  testShoeWithoutJokerFirstDeckIsSortedTheRestBecomesShuffledAfterConstructionCore(int shoeSize) {
    final shoe = Shoe(shoeSize);
    for (int deck = 0; deck < shoeSize; deck++) {
      if (deck == 0) {
        for (int cardIndex = 0; cardIndex < 52; cardIndex++) {
          final card = shoe.dealCard();
          expect(cardIndex ~/ (52 / 4), card.suit.index);
          expect(cardIndex % (52 / 4), card.value.index);
        }
      } else {
        bool sorted = true;
        for (int cardIndex = 0; cardIndex < 52 && sorted; cardIndex++) {
          final card = shoe.dealCard();
          sorted = sorted && (cardIndex ~/ (52 / 4) == card.suit.index);
          sorted = sorted && (cardIndex % (52 / 4) != card.value.index);
        }
        expect(sorted, false);
      }
    }
  }

  testShoeWithoutJokerIsNotSortedAfterShuffleCore(int shoeSize) {
    final shoe = Shoe(shoeSize);
    shoe.shuffleAll();
    for (int deck = 0; deck < shoeSize; deck++) {
      bool sorted = true;
      for (int cardIdx = 0; cardIdx < 52 && sorted; cardIdx++) {
        final card = shoe.dealCard();
        sorted = sorted && (cardIdx ~/ (52 / 4) == card.suit.index);
        sorted = sorted && (cardIdx % (52 / 4) != card.value.index);
      }
      expect(sorted, false);
    }
  }

  testShoeWithoutJokerIsShuffledAfterTurnaroundCore(int shoeSize) {
    final shoe = Shoe(shoeSize);
    // Go through all decks and cause shoe to "turn around"
    for (int deck = 0; deck < shoeSize; deck++) {
      for (int cardIdx = 0; cardIdx < 52; cardIdx++) {
        shoe.dealCard();
      }
    }
    for (int deck = 0; deck < shoeSize; deck++) {
      bool sorted = true;
      for (int cardIdx = 0; cardIdx < 52 && sorted; cardIdx++) {
        final card = shoe.dealCard();
        sorted = sorted && (cardIdx ~/ (52 / 4) == card.suit.index);
        sorted = sorted && (cardIdx % (52 / 4) != card.value.index);
      }
      expect(sorted, false);
    }
  }

  testShoeWithoutJokerCanDeal52CardsCore(int shoeSize) {
    final shoe = Shoe(shoeSize);
    for (int deck = 0; deck < shoeSize; deck++) {
      for(int i = 0; i < 52; i++) {
        final card = shoe.dealCard();
        int suitInt = card.suit.index;
        int valueInt = card.value.index;
        expect(suitInt >= 0 && suitInt < 4, true);
        expect(valueInt >= 0 && valueInt < 13, true);
      }
    }
  }

  testShoeWithoutJokerIsEndlessCore(int shoeSize) {
    final shoe = Shoe(shoeSize);
    // pulling out three times the decks of cards
    for(int i = 0; i < shoeSize * 52 * 3; i++) {
      final card = shoe.dealCard();
      expect(card.suit != Suit.Invalid, true);
      expect(card.value != Value.Invalid, true);
    }
  }

  testShoeSuppliesDifferentCardsCore(int shoeSize) {
    final shoe = Shoe(shoeSize);
    for (int deck = 0; deck < shoeSize; deck++) {
      final cards = List<PlayCard>();
      for(int i = 0; i < 52; i++) {
        final playCard = shoe.dealCard();
        for(PlayCard card in cards) {
          expect(card.suit == playCard.suit && card.value == playCard.value, false);
          expect(playCard.suit != Suit.Invalid, true);
          expect(playCard.value != Value.Invalid, true);
        }
        cards.add(playCard);
      }
    }
  }

  final maxShoeSizeToTest = 8;

  group('Shoe tests', () {
    test('Default deck is without Joker', () async {
      final deck = Deck();
      expect(deck.includeJokers, false);
    });

    test('Empty shoe deals invalid cards', () async {
      final shoe = Shoe(0);
      for (int cardIdx = 0; cardIdx < 104; cardIdx++) {
        final card = shoe.dealCard();
        expect(card.suit, Suit.Invalid);
        expect(card.value, Value.Invalid);
      }
    });

    test('Shoe w/o Joker first deck is sorted the rest becomes shuffled after construction', () async {
      for (int shoeSize = 1; shoeSize <= maxShoeSizeToTest; shoeSize++) {
        testShoeWithoutJokerFirstDeckIsSortedTheRestBecomesShuffledAfterConstructionCore(
            shoeSize);
      }
    });

    test('Shoe w/o Joker is not sorted after shuffle', () async {
      for (int shoeSize = 1; shoeSize <= maxShoeSizeToTest; shoeSize++) {
        testShoeWithoutJokerIsNotSortedAfterShuffleCore(shoeSize);
      }
    });

    test('Shoe w/o Joker is shuffled after turnaround', () async {
      for (int shoeSize = 1; shoeSize <= maxShoeSizeToTest; shoeSize++) {
        testShoeWithoutJokerIsShuffledAfterTurnaroundCore(shoeSize);
      }
    });

    test('Shoe w/o Joker can deal 52 cards', () async {
      for (int shoeSize = 1; shoeSize <= maxShoeSizeToTest; shoeSize++) {
        testShoeWithoutJokerCanDeal52CardsCore(shoeSize);
      }
    });

    test('Shoe w/o Joker is endless', () async {
      for (int shoeSize = 1; shoeSize <= maxShoeSizeToTest; shoeSize++) {
        testShoeWithoutJokerIsEndlessCore(shoeSize);
      }
    });

    test('Shoe deals different cards', () async {
      for (int shoeSize = 1; shoeSize <= maxShoeSizeToTest; shoeSize++) {
        testShoeSuppliesDifferentCardsCore(shoeSize);
      }
    });
  });
}
