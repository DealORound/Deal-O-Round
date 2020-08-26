enum Suit { Spades, Clubs, Diamonds, Hearts, Invalid }

const suitCharacters = ["S", "C", "4", "3", ""];

String suitCharacter(Suit suit) {
  return suitCharacters[suit.index];
}

Suit suitFromCharacter(String suit) {
  final index = suitCharacters.indexOf(suit);
  return Suit.values[index];
}
