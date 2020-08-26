import 'hand_class.dart';
import 'play_card.dart';
import 'scoring.dart';
import 'value.dart';

class Rules {
  String getHandDigest(List<PlayCard> hand, bool fast) {
    if (fast) {
      return null;
    }

    List<PlayCard> handClone = List<PlayCard>();
    for (PlayCard card in hand) {
      handClone.add(card);
    }
    hand.sort((hi, hj) => hi.compareTo(hj));
    String handString = "";
    for (PlayCard card in handClone) {
      handString += (card.suit.index.toString() +
          "_" +
          card.value.index.toString() +
          "_");
    }
    return handString.toString();
  }

  bool addToResults(List<Scoring> results, Scoring scoring, bool fast) {
    if (!fast) {
      for (Scoring result in results) {
        if (result.score() != scoring.score()) {
          if (result.toStringDisplay() == null &&
              scoring.toStringDisplay() == null) {
            return false;
          }
          if (result.toStringDisplay() == scoring.toStringDisplay()) {
            return false;
          }
        }
      }
    }
    results.add(scoring);
    return true;
  }

  // Conversion method
  Scoring rankHandPlayCard(
      List<PlayCard> hand, int subHandDrillDown, bool bestOnTop, bool fast) {
    List<PlayCard> cards = List<PlayCard>();
    for (PlayCard card in hand) {
      cards.add(card);
    }
    List<Scoring> results =
        rankHand(cards, subHandDrillDown, false, bestOnTop, fast);
    if (results.isNotEmpty) {
      return results[0];
    }
    return Scoring();
  }

  // Accessing directly for testing only
  List<Scoring> rankHand(List<PlayCard> cards, int subHandDrillDown,
      bool shouldClone, bool bestOnTop, bool fast) {
    final results = List<Scoring>();

    if (cards == null) {
      return results;
    }
    List<PlayCard> hand = [...cards];

    switch (hand.length) {
      case 2:
        rankTwoCards(hand, results, fast);
        break;
      case 3:
        rankThreeCards(hand, subHandDrillDown, results, fast);
        break;
      case 4:
        rankFourCards(hand, subHandDrillDown, results, fast);
        break;
      case 5:
        rankFiveCards(hand, subHandDrillDown, results, fast);
        break;
      default:
        break;
    }
    if (results.isNotEmpty) {
      results.sort((ra, rb) => rb.score().compareTo(ra.score()));
    }

    return results;
  }

  rankTwoCards(List<PlayCard> hand, List<Scoring> results, bool fast) {
    if (hand.length <= 1) {
      return;
    }

    if (hand[0].value == hand[1].value) {
      // One pair
      addToResults(
          results,
          Scoring(
              handClass: HandClass.OnePair,
              lowCard: hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }
  }

  rankThreeCards(List<PlayCard> hand, int subHandDrillDown,
      List<Scoring> results, bool fast) {
    if (hand.length <= 2) {
      return;
    }

    if (hand[0].value == hand[1].value && hand[1].value == hand[2].value) {
      // Three of a kind
      addToResults(
          results,
          Scoring(
              handClass: HandClass.ThreeOfAKind,
              lowCard: hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }
    bool flush = (hand[0].suit == hand[1].suit && hand[1].suit == hand[2].suit);
    hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
    bool possibleWheel =
        (hand[0].value == Value.Two && hand[2].value == Value.Ace);
    if (hand[0].value.index + 1 == hand[1].value.index &&
        (hand[1].value.index + 1 == hand[2].value.index || possibleWheel)) {
      // It's a straight.
      if (flush) {
        // It's a flush too, making it a "small straight flush"
        addToResults(
            results,
            Scoring(
                handClass: HandClass.StraightFlush3,
                lowCard: possibleWheel ? hand[1] : hand[0],
                handDigest: getHandDigest(hand, fast)),
            fast);
      }
      addToResults(
          results,
          Scoring(
              handClass: HandClass.Straight3,
              lowCard: possibleWheel ? hand[1] : hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }
    if (flush) {
      addToResults(
          results,
          Scoring(
              handClass: HandClass.Flush3,
              lowCard: hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }

    // Check maybe two card combinations
    if (subHandDrillDown > 0) {
      rankTwoCards(hand.sublist(0, 2), results, fast);
      rankTwoCards(hand.sublist(1, 3), results, fast);
      List<PlayCard> firstAndLast = List<PlayCard>();
      firstAndLast.add(hand[0]);
      firstAndLast.add(hand[2]);
      rankTwoCards(firstAndLast, results, fast);
    }
  }

  rankFourCards(List<PlayCard> hand, int subHandDrillDown,
      List<Scoring> results, bool fast) {
    if (hand.length <= 3) {
      return;
    }

    if (hand[0].value == hand[1].value &&
        hand[1].value == hand[2].value &&
        hand[2].value == hand[3].value) {
      // Four of a kind
      addToResults(
          results,
          Scoring(
              handClass: HandClass.FourOfAKind,
              lowCard: hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }
    bool flush = (hand[0].suit == hand[1].suit &&
        hand[1].suit == hand[2].suit &&
        hand[2].suit == hand[3].suit);
    hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
    bool possibleWheel =
        (hand[0].value == Value.Two && hand[3].value == Value.Ace);
    if (hand[0].value.index + 1 == hand[1].value.index &&
        hand[1].value.index + 1 == hand[2].value.index &&
        (hand[2].value.index + 1 == hand[3].value.index || possibleWheel)) {
      // It's a straight
      if (flush) {
        // It's a flush too, making it a "medium straight flush"
        addToResults(
            results,
            Scoring(
                handClass: HandClass.StraightFlush4,
                lowCard: possibleWheel ? hand[1] : hand[0],
                handDigest: getHandDigest(hand, fast)),
            fast);
      }
      addToResults(
          results,
          Scoring(
              handClass: HandClass.Straight4,
              lowCard: possibleWheel ? hand[1] : hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }
    if (flush) {
      addToResults(
          results,
          Scoring(
              handClass: HandClass.Flush4,
              lowCard: hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }

    if (hand[0].value == hand[1].value && hand[2].value == hand[3].value) {
      // Two pairs
      addToResults(
          results,
          Scoring(
              handClass: HandClass.TwoPair,
              lowCard: hand[0],
              highCard: hand[3],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }

    // Check maybe three card combinations
    if (subHandDrillDown > 0) {
      rankThreeCards(hand.sublist(0, 3), subHandDrillDown - 1, results, fast);
      rankThreeCards(hand.sublist(1, 4), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.suit.index.compareTo(hj.suit.index));
      rankThreeCards(hand.sublist(0, 3), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.suit.index.compareTo(hj.suit.index));
      rankThreeCards(hand.sublist(1, 4), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
      rankThreeCards(hand.sublist(0, 3), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
      rankThreeCards(hand.sublist(1, 4), subHandDrillDown - 1, results, fast);
    }
  }

  rankFiveCards(List<PlayCard> hand, int subHandDrillDown,
      List<Scoring> results, bool fast) {
    if (hand.length <= 4) {
      return;
    }

    if (hand[0].value == hand[1].value &&
        hand[1].value == hand[2].value &&
        hand[2].value == hand[3].value &&
        hand[3].value == hand[4].value) {
      // Five of a kind
      addToResults(
          results,
          Scoring(
              handClass: HandClass.FiveOfAKind,
              lowCard: hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }

    hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
    /*if (hand[1].getValue() == hand[2].getValue() &&
			hand[2].getValue() == hand[3].getValue() &&
			(hand[0].getValue() == hand[1].getValue() ||
			 hand[3].getValue() == hand[4].getValue()))
		{
			// Four of a kind
			return 1500 + offsetRank(hand[1]);
		}*/
    bool possibleWheel =
        (hand[0].value == Value.Two && hand[4].value == Value.Ace);
    bool flush = (hand[0].suit == hand[1].suit &&
        hand[1].suit == hand[2].suit &&
        hand[2].suit == hand[3].suit &&
        hand[3].suit == hand[4].suit);
    if (hand[0].value.index + 1 == hand[1].value.index &&
        hand[1].value.index + 1 == hand[2].value.index &&
        hand[2].value.index + 1 == hand[3].value.index &&
        (hand[3].value.index + 1 == hand[4].value.index || possibleWheel)) {
      // It's a straight
      if (flush) {
        // It's a flush too, making it a straight flush
        addToResults(
            results,
            Scoring(
                handClass: HandClass.StraightFlush5,
                lowCard: possibleWheel ? hand[1] : hand[0],
                handDigest: getHandDigest(hand, fast)),
            fast);
      }
      addToResults(
          results,
          Scoring(
              handClass: HandClass.Straight5,
              lowCard: possibleWheel ? hand[1] : hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }
    if (flush) {
      addToResults(
          results,
          Scoring(
              handClass: HandClass.Flush5,
              lowCard: hand[0],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }
    // Look for full house
    if (hand[0].value == hand[1].value &&
        hand[3].value == hand[4].value &&
        (hand[1].value == hand[2].value || hand[2].value == hand[3].value)) {
      addToResults(
          results,
          Scoring(
              handClass: HandClass.FullHouse,
              lowCard: hand[0],
              highCard: hand[4],
              handDigest: getHandDigest(hand, fast)),
          fast);
    }

    // Check maybe four card combinations
    if (subHandDrillDown > 0) {
      rankFourCards(hand.sublist(0, 4), subHandDrillDown - 1, results, fast);
      rankFourCards(hand.sublist(1, 5), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
      rankFourCards(hand.sublist(0, 4), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
      rankFourCards(hand.sublist(1, 5), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.suit.index.compareTo(hj.suit.index));
      rankFourCards(hand.sublist(0, 4), subHandDrillDown - 1, results, fast);
      hand.sort((hi, hj) => hi.suit.index.compareTo(hj.suit.index));
      rankFourCards(hand.sublist(1, 5), subHandDrillDown - 1, results, fast);
    }
  }
}
