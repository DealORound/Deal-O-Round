enum Value {
  Two,
  Three,
  Four,
  Five,
  Six,
  Seven,
  Eight,
  Nine,
  Ten,
  Jack,
  Queen,
  King,
  Ace,
  Joker,
  Invalid
}

int valueScore(Value value) => value.index * 5;

const valueCharacters = [
  "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A", "*", ""
];

String valueCharacter(Value value) {
  return valueCharacters[value.index];
}

const valueDisplayStrings = [
  "2", "3", "4", "5", "6", "7", "8", "9", "10",
  "Jack", "Queen", "King", "Ace", "Joker", ""
];

String valueDisplay(Value value) {
  return valueDisplayStrings[value.index];
}

Value valueFromCharacter(String value) {
  final index = valueCharacters.indexOf(value);
  return Value.values[index];
}
