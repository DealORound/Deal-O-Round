import 'hand_class.dart';
import 'play_card.dart';
import 'scoring.dart';
import 'suit.dart';
import 'value.dart';

class Rules {
  String getHandDigest(List<PlayCard> hand, bool fast) {
    if (fast) {
      return "";
    }

    List<PlayCard> handClone = [];
    for (PlayCard card in hand) {
      handClone.add(card);
    }
    hand.sort((hi, hj) => hi.compareTo(hj));
    String handString = "";
    for (PlayCard card in handClone) {
      handString += (card.suit.index.toString() + "_" + card.value.index.toString() + "_");
    }
    return handString.toString();
  }

  bool addToResults(List<Scoring> results, Scoring scoring, bool fast) {
    if (!fast) {
      for (Scoring result in results) {
        if (result.score() != scoring.score()) {
          if ((result.toStringDisplay() == "None" || result.toStringDisplay() == "") &&
              (scoring.toStringDisplay() == "None" || scoring.toStringDisplay() == "")) {
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

  void rankHandCore(List<PlayCard> cards, List<Scoring> results, int subHandDrillDown,
      bool bestOnTop, bool fast) {
    if (cards.length <= 1) {
      return;
    }

    List<PlayCard> hand = [...cards];
    if (cards.any((card) => card.value == Value.Joker)) {
      var jokerIndex = 0;
      for (PlayCard card in hand) {
        if (card.value == Value.Joker) {
          break;
        }
        jokerIndex++;
      }
      final jokerCard = hand[jokerIndex];
      final jokerSuites = BLACK_SUITES.contains(jokerCard.suit) ? BLACK_SUITES : RED_SUITES;
      for (Suit suit in jokerSuites) {
        final nonJoker = Value.values.sublist(0, 13);
        for (Value value in nonJoker) {
          hand[jokerIndex] = PlayCard(suit, value);
          rankHandCore(hand, results, subHandDrillDown, bestOnTop, fast);
        }
      }
    } else {
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
    }
  }

  List<Scoring> rankHand(List<PlayCard> cards, int subHandDrillDown, bool bestOnTop, bool fast) {
    List<Scoring> results = [];

    if (cards.length <= 1) {
      return results;
    }

    rankHandCore(cards, results, subHandDrillDown, bestOnTop, fast);

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
        Scoring(HandClass.OnePair, hand[0], getHandDigest(hand, fast)),
        fast,
      );
    }
  }

  rankThreeCards(List<PlayCard> hand, int subHandDrillDown, List<Scoring> results, bool fast) {
    if (hand.length <= 2) {
      return;
    }

    if (hand[0].value == hand[1].value && hand[1].value == hand[2].value) {
      // Three of a kind
      addToResults(
        results,
        Scoring(HandClass.ThreeOfAKind, hand[0], getHandDigest(hand, fast)),
        fast,
      );
    }
    bool flush = (hand[0].suit == hand[1].suit && hand[1].suit == hand[2].suit);
    hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
    bool possibleWheel = (hand[0].value == Value.Two && hand[2].value == Value.Ace);
    if (hand[0].value.index + 1 == hand[1].value.index &&
        (hand[1].value.index + 1 == hand[2].value.index || possibleWheel)) {
      // It's a straight.
      if (flush) {
        // It's a flush too, making it a "small straight flush"
        addToResults(
          results,
          Scoring(
            HandClass.StraightFlush3,
            possibleWheel ? hand[1] : hand[0],
            getHandDigest(hand, fast),
          ),
          fast,
        );
      }
      addToResults(
        results,
        Scoring(
          HandClass.Straight3,
          possibleWheel ? hand[1] : hand[0],
          getHandDigest(hand, fast),
        ),
        fast,
      );
    }
    if (flush) {
      addToResults(
        results,
        Scoring(HandClass.Flush3, hand[0], getHandDigest(hand, fast)),
        fast,
      );
    }

    // Check maybe two card combinations
    if (subHandDrillDown > 0) {
      rankTwoCards(hand.sublist(0, 2), results, fast);
      rankTwoCards(hand.sublist(1, 3), results, fast);
      List<PlayCard> firstAndLast = [];
      firstAndLast.add(hand[0]);
      firstAndLast.add(hand[2]);
      rankTwoCards(firstAndLast, results, fast);
    }
  }

  rankFourCards(List<PlayCard> hand, int subHandDrillDown, List<Scoring> results, bool fast) {
    if (hand.length <= 3) {
      return;
    }

    if (hand[0].value == hand[1].value &&
        hand[1].value == hand[2].value &&
        hand[2].value == hand[3].value) {
      // Four of a kind
      addToResults(
        results,
        Scoring(HandClass.FourOfAKind, hand[0], getHandDigest(hand, fast)),
        fast,
      );
    }
    bool flush = (hand[0].suit == hand[1].suit &&
        hand[1].suit == hand[2].suit &&
        hand[2].suit == hand[3].suit);
    hand.sort((hi, hj) => hi.value.index.compareTo(hj.value.index));
    bool possibleWheel = (hand[0].value == Value.Two && hand[3].value == Value.Ace);
    if (hand[0].value.index + 1 == hand[1].value.index &&
        hand[1].value.index + 1 == hand[2].value.index &&
        (hand[2].value.index + 1 == hand[3].value.index || possibleWheel)) {
      // It's a straight
      if (flush) {
        // It's a flush too, making it a "medium straight flush"
        addToResults(
          results,
          Scoring(
            HandClass.StraightFlush4,
            possibleWheel ? hand[1] : hand[0],
            getHandDigest(hand, fast),
          ),
          fast,
        );
      }
      addToResults(
        results,
        Scoring(
          HandClass.Straight4,
          possibleWheel ? hand[1] : hand[0],
          getHandDigest(hand, fast),
        ),
        fast,
      );
    }
    if (flush) {
      addToResults(
        results,
        Scoring(HandClass.Flush4, hand[0], getHandDigest(hand, fast)),
        fast,
      );
    }

    if (hand[0].value == hand[1].value && hand[2].value == hand[3].value) {
      // Two pairs
      addToResults(
        results,
        Scoring(
          HandClass.TwoPair,
          hand[0],
          getHandDigest(hand, fast),
          highCard: hand[3],
        ),
        fast,
      );
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

  rankFiveCards(List<PlayCard> hand, int subHandDrillDown, List<Scoring> results, bool fast) {
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
        Scoring(HandClass.FiveOfAKind, hand[0], getHandDigest(hand, fast)),
        fast,
      );
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
    bool possibleWheel = (hand[0].value == Value.Two && hand[4].value == Value.Ace);
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
            HandClass.StraightFlush5,
            possibleWheel ? hand[1] : hand[0],
            getHandDigest(hand, fast),
          ),
          fast,
        );
      }
      addToResults(
        results,
        Scoring(
          HandClass.Straight5,
          possibleWheel ? hand[1] : hand[0],
          getHandDigest(hand, fast),
        ),
        fast,
      );
    }
    if (flush) {
      addToResults(
        results,
        Scoring(
          HandClass.Flush5,
          hand[0],
          getHandDigest(hand, fast),
        ),
        fast,
      );
    }
    // Look for full house
    if (hand[0].value == hand[1].value &&
        hand[3].value == hand[4].value &&
        (hand[1].value == hand[2].value || hand[2].value == hand[3].value)) {
      addToResults(
        results,
        Scoring(
          HandClass.FullHouse,
          hand[0],
          getHandDigest(hand, fast),
          highCard: hand[4],
        ),
        fast,
      );
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
