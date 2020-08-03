import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Deck {
  List<PlayCard> deck;
  int cardsUsed;
  final bool includeJokers;

  Deck({this.includeJokers: false}) {
    for (int suitIndex = 0; suitIndex < 4; suitIndex++) {
      for (int valueIndex = 0; valueIndex < 13; valueIndex++) {
        deck.add(new PlayCard(suit: Suit.values[suitIndex], value: Value.values[valueIndex]));
      }
    }
    cardsUsed = 0;
  }

  int cardsLeft() => deck.length - cardsUsed;

  void shuffle() {
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
