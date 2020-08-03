enum Suit {
  Spades,
  Clubs,
  Diamonds,
  Hearts,
  Invalid
}

// Suit.Spades.index // == 0
// Suit.Clubs.index // == 1

const suitCharacters = [
  "S", "C", "4", "3", ""
];

String suitCharacter(Suit suit) {
  return suitCharacters[suit.index];
}
