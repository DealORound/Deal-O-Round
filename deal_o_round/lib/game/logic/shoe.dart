import 'deck.dart';
import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Shoe {
  List<Deck> decks;
  int decksUsed;

  Shoe(int deckCount) {
    decks = List<Deck>();
    for (int i = 0; i < deckCount; i++) {
      decks.add(Deck());
    }
    decksUsed = 0;
  }

  shuffleAll() {
    for(Deck deck in decks) {
      deck.shuffle();
    }
    decksUsed = 0;
  }

  PlayCard dealCard() {
    if (decks.length <= 0) {
      return PlayCard(suit: Suit.Invalid, value: Value.Invalid);
    }

    if (decks[decksUsed].cardsLeft() <= 0) {
      decks[decksUsed].shuffle();
      if (decks.length > 1) {
        decksUsed = (decksUsed + 1) % (decks.length - 1);
      }
    }
    return decks[decksUsed].dealCard();
  }
}
