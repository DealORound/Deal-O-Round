enum Suit { Spades, Clubs, Diamonds, Hearts, Invalid }

const BLACK_SUITES = [Suit.Spades, Suit.Clubs];
const RED_SUITES = [Suit.Diamonds, Suit.Hearts];

const suitCharacters = ["S", "C", "4", "3", ""];

String suitCharacter(Suit suit) {
  return suitCharacters[suit.index];
}

Suit suitFromCharacter(String suit) {
  final index = suitCharacters.indexOf(suit);
  return Suit.values[index];
}
