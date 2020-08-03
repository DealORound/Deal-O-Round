enum Suit {
  Spades,
  Clubs,
  Diamonds,
  Hearts,
  Invalid
}

// Suit.Spades.index // == 0
// Suit.Clubs.index // == 1


String suiteCharacter(Suit suit) {
  switch (suit) {
    case Suit.Spades:
      return "S";
    case Suit.Clubs:
      return "C";
    case Suit.Diamonds:
      return "4";
    case Suit.Hearts:
      return "3";
    default:
      return "";
  }
}
