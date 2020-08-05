import 'suit.dart';
import 'value.dart';

class PlayCard implements Comparable<PlayCard> {
  final Suit suit;
  final Value value;
  bool selected = false;
  bool neighbor = false;

  PlayCard({
    this.suit,
    this.value
  });

  @override
  int compareTo(PlayCard other) {
    final valueDiff = value.index - other.value.index;
    final suitDiff = suit.index - other.suit.index;
    return valueDiff != 0 ? valueDiff : suitDiff;
  }
}

String cardDisplay(PlayCard card) {
  if (card.suit == Suit.Invalid || card.value == Value.Invalid) {
    return "Invalid";
  }

  final valueString = card.value.toString().split('.').last;
  final suitString = card.suit.toString().split('.').last;
  return "$valueString of $suitString";
}
