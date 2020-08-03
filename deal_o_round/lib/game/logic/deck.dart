import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Deck {
  List<PlayCard> deck;
  int cardsUsed;
  final bool includeJokers;

  Deck({this.includeJokers: false}) {
    deck = List<PlayCard>();
    final valueLimit = includeJokers ? 14 : 13;
    for (int suitIndex = 0; suitIndex < 4; suitIndex++) {
      for (int valueIndex = 0; valueIndex < valueLimit; valueIndex++) {
        deck.add(PlayCard(suit: Suit.values[suitIndex], value: Value.values[valueIndex]));
      }
    }
    cardsUsed = 0;
  }

  int cardsLeft() => deck.length - cardsUsed;

  shuffle() {
    deck.shuffle();
    cardsUsed = 0;
  }

  PlayCard dealCard() {
    if (cardsUsed == deck.length) {
      return PlayCard(suit: Suit.Invalid, value: Value.Invalid);
    }

    cardsUsed++;
    return deck[cardsUsed - 1];
  }
}
