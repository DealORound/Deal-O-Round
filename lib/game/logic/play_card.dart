import 'suit.dart';
import 'value.dart';

class PlayCard implements Comparable<PlayCard> {
  final Suit suit;
  final Value value;
  final int deck;
  var selected = false;
  var neighbor = false;

  PlayCard(this.suit, this.value, {this.deck = 0});

  PlayCard.fromString(
      String suitStr, String valueStr, String selectedChar, String neighborChar)
      : suit = suitFromCharacter(suitStr),
        value = valueFromCharacter(valueStr),
        deck = 0,
        selected = selectedChar == '1',
        neighbor = neighborChar == '1';

  @override
  int compareTo(PlayCard other) {
    final valueDiff = value.index - other.value.index;
    final suitDiff = suit.index - other.suit.index;
    return valueDiff != 0 ? valueDiff : suitDiff;
  }

  @override
  String toString() {
    final suitChar = suitCharacter(suit);
    final valueChar = valueCharacter(value);
    final selectedChar = selected ? "1" : "0";
    final neighborChar = neighbor ? "1" : "0";
    return "$suitChar-$valueChar-$deck-$selectedChar-$neighborChar";
  }

  @override
  bool operator ==(Object other) {
    return other is PlayCard &&
        suit == other.suit &&
        value == other.value &&
        deck == other.deck &&
        selected == other.selected &&
        neighbor == other.neighbor;
  }

  @override
  int get hashCode =>
      suit.index +
      8 *
          (value.index +
              64 * ((selected ? 1 : 0) + 2 * ((neighbor ? 1 : 0) + 2 * deck)));
}

String cardDisplay(PlayCard card) {
  if (card.suit == Suit.invalid || card.value == Value.invalid) {
    return "Invalid";
  }

  final valueString = card.value.toString().split('.').last;
  final suitString = card.suit.toString().split('.').last;
  return "$valueString of $suitString";
}
