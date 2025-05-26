enum HandClass {
  none,
  onePair,
  flush3,
  straight3,
  straightFlush3,
  threeOfAKind, // Terc
  straight4,
  twoPair,
  flush4,
  straight5,
  straightFlush4,
  flush5,
  fullHouse,
  fourOfAKind, // Poker
  straightFlush5, // Royal Flush
  fiveOfAKind,
  invalid,
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
  "Five of a kind",
  "Invalid",
];

String handDisplayString(HandClass handClass) {
  if (handClass == HandClass.invalid) {
    return "";
  }

  return handDisplayStrings[handClass.index];
}

const baseValueList = [
  0,
  1,
  15,
  30,
  50,
  100,
  125,
  150,
  170,
  200,
  250,
  300,
  350,
  2000,
  5000,
  8000,
  0,
];

int handBaseValue(HandClass handClass) {
  return baseValueList[handClass.index];
}

const timeBonuses = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 30, 0];

int getTimeBonus(HandClass handClass) {
  return timeBonuses[handClass.index];
}
