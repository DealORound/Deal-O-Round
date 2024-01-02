enum Suit { spades, clubs, diamonds, hearts, invalid }

const blackSuites = [Suit.spades, Suit.clubs];
const redSuites = [Suit.diamonds, Suit.hearts];

const suitCharacters = ["S", "C", "4", "3", ""];

String suitCharacter(Suit suit) {
  return suitCharacters[suit.index];
}

Suit suitFromCharacter(String suit) {
  final index = suitCharacters.indexOf(suit);
  return Suit.values[index];
}
