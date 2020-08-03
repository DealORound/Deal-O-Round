enum HandClass {
  None,
  OnePair,
  Flush3,
  Straight3,
  StraightFlush3,
  ThreeOfAKind,  // Terc
  Straight4,
  TwoPair,
  Flush4,
  Straight5,
  StraightFlush4,
  Flush5,
  FullHouse,
  FourOFAKind,  // Poker
  StraightFlush5,  // Royal Flush
  FiveOfAKind,
  Invalid
}

const handDisplayStrings = [
  "None",
  "Pair",
  "Lesser (3) Flush",
  "Lesser (3) Straight",
  "Lesser (3) Straight Flush",
  "Three of a kind",
  "Lesser (4) Straight",
  "Pairs",
  "Lesser (4) Flush",
  "Straight",
  "Lesser (4) Straight Flush",
  "Flush",
  "Full house",
  "Four of a kind",
  "Straight Flush",
  "FiveOfAKind",
  "Invalid"
];

String handDisplayString(HandClass handClass) {
  return handDisplayStrings[handClass.index];
}

const baseValueList =
  [0, 1, 15, 30, 50, 100, 125, 150, 170, 200,
    250, 300, 350, 2000, 5000, 10000, 0];

int handBaseValue(HandClass handClass) {
  return baseValueList[handClass.index];
}

const timeBonuses = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 60, 0];

int getTimeBonus(HandClass handClass) {
  return timeBonuses[handClass.index];
}
