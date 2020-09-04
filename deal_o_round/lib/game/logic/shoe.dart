import 'deck.dart';
import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Shoe {
  final bool includeJokers;
  final bool initialShuffle;
  List<Deck> decks;
  int decksUsed;

  Shoe({this.includeJokers: false, this.initialShuffle: true}) {
    decks = List<Deck>();
    decks.add(Deck(
        includeJokers: includeJokers,
        initialShuffle: initialShuffle,
        index: 0));
    decksUsed = 0;
  }

  PlayCard dealCard() {
    if (decks.length <= 0) {
      return PlayCard(suit: Suit.Invalid, value: Value.Invalid);
    }

    if (decks[decksUsed].cardsLeft() <= 0) {
      decksUsed += 1;
      decks.add(Deck(
          includeJokers: includeJokers,
          initialShuffle: initialShuffle,
          index: decksUsed));
    }
    return decks[decksUsed].dealCard();
  }
}
