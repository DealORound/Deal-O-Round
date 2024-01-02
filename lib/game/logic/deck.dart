import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Deck {
  late List<PlayCard> deck;
  late int cardsUsed;
  final bool includeJokers;
  final bool initialShuffle;
  final int index;

  Deck(
      {this.includeJokers = false,
      this.initialShuffle = true,
      this.index = 0}) {
    deck = [];
    for (int suitIndex = 0; suitIndex < 4; suitIndex++) {
      for (int valueIndex = 0; valueIndex < 13; valueIndex++) {
        deck.add(PlayCard(
          Suit.values[suitIndex],
          Value.values[valueIndex],
          deck: index,
        ));
      }
    }

    if (includeJokers) {
      deck.add(PlayCard(Suit.spades, Value.joker, deck: index));
      deck.add(PlayCard(Suit.diamonds, Value.joker, deck: index));
    }

    if (initialShuffle) {
      deck.shuffle();
    }

    cardsUsed = 0;
  }

  int cardsLeft() => deck.length - cardsUsed;

  PlayCard dealCard() {
    if (cardsUsed == deck.length) {
      return PlayCard(Suit.invalid, Value.invalid);
    }

    cardsUsed++;
    return deck[cardsUsed - 1];
  }
}
