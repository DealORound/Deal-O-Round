import 'deck.dart';
import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Shoe {
  final bool includeJokers;
  final bool initialShuffle;
  late List<Deck> decks;
  late int decksUsed;

  Shoe({this.includeJokers = false, this.initialShuffle = true}) {
    decks = [];
    decks.add(Deck(
        includeJokers: includeJokers,
        initialShuffle: initialShuffle,
        index: 0));
    decksUsed = 0;
  }

  PlayCard dealCard() {
    if (decks.isEmpty) {
      return PlayCard(Suit.Invalid, Value.Invalid);
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
