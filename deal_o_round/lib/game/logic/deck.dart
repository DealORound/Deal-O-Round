import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Deck {
  List<PlayCard> deck;
  int cardsUsed;
  final bool includeJokers;
  final bool initialShuffle;
  final index;

  Deck({this.includeJokers: false, this.initialShuffle: true, this.index}) {
    deck = List<PlayCard>();
    for (int suitIndex = 0; suitIndex < 4; suitIndex++) {
      for (int valueIndex = 0; valueIndex < 13; valueIndex++) {
        deck.add(PlayCard(
          suit: Suit.values[suitIndex],
          value: Value.values[valueIndex],
          deck: index,
        ));
      }
    }
    if (includeJokers) {
      deck.add(PlayCard(
        suit: Suit.Spades,
        value: Value.Joker,
        deck: index,
      ));
      deck.add(PlayCard(
        suit: Suit.Diamonds,
        value: Value.Joker,
        deck: index,
      ));
    }
    if (initialShuffle) {
      deck.shuffle();
    }
    cardsUsed = 0;
  }

  int cardsLeft() => deck.length - cardsUsed;

  PlayCard dealCard() {
    if (cardsUsed == deck.length) {
      return PlayCard(suit: Suit.Invalid, value: Value.Invalid);
    }

    cardsUsed++;
    return deck[cardsUsed - 1];
  }
}
