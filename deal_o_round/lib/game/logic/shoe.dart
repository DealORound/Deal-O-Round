import 'package:deal_o_round/game/logic/card.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';

import 'deck.dart';

class Shoe {
  List<Deck> decks;
  int decksUsed;

  Shoe(int deckCount) {
    for (int i = 0; i < deckCount; i++)
      decks.add(new Deck());
    decksUsed = 0;
  }

  void shuffleAll() {
    for(Deck deck in decks) {
      deck.shuffle();
    }
    decksUsed = 0;
  }

  Card dealCard() {
    if (decks.length <= 0) {
      return Card(suit: Suit.Invalid, value: Value.Invalid);
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
