import 'suit.dart';
import 'value.dart';

class Card implements Comparable<Card> {
  final Suit suit;
  final Value value;

  Card({
    this.suit,
    this.value
  });

  @override
  int compareTo(Card other) {
    final valueDiff = value.index - other.value.index;
    final suitDiff = suit.index - other.suit.index;
    return valueDiff != 0 ? valueDiff : suitDiff;
  }
}

String cardDisplay(Card card) {
  if (card.suit == Suit.Invalid || card.value == Value.Invalid) {
    return "Invalid";
  }

  final valueString = card.value.toString().split('.').last;
  final suitString = card.suit.toString().split('.').last;
  return "$valueString of $suitString";
}
