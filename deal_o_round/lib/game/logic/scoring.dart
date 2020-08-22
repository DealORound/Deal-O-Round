import 'hand_class.dart';
import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Scoring {
  HandClass handClass;
  PlayCard lowCard;
  PlayCard highCard;
  String handDigest;

  Scoring({this.handClass, this.lowCard, this.highCard, this.handDigest});

  int score() {
    int score = handBaseValue(handClass);
    if (lowCard != null && lowCard.value != Value.Invalid) {
      score += valueScore(lowCard.value);
    }
    if (highCard != null && highCard.value != Value.Invalid) {
      score += 2 * valueScore(highCard.value);
    }
    return score;
  }

  String toStringDisplay() {
    String handString = handDisplayString(handClass);
    if (handClass == HandClass.None) {
      return handString;
    }
    if (lowCard == null || lowCard.value == Value.Invalid || lowCard.suit == Suit.Invalid) {
      return "None";
    }

    String displayStr = "$handString of ";
    final String suitString = lowCard.suit.toString().split('.').last;
    final lowCardValueString = valueDisplay(lowCard.value);
    switch(handClass) {
      case HandClass.OnePair: displayStr += lowCardValueString; break;
      case HandClass.Flush3: displayStr += suitString; break;
      case HandClass.Straight3: displayStr += "$lowCardValueString and up"; break;
      case HandClass.StraightFlush3: displayStr += "$suitString, $lowCardValueString and up"; break;
      case HandClass.ThreeOfAKind: displayStr += lowCardValueString; break;
      case HandClass.Straight4: displayStr += "$lowCardValueString and up"; break;
      case HandClass.TwoPair: displayStr += valueDisplay(highCard.value) + " + $lowCardValueString"; break;
      case HandClass.Flush4: displayStr += suitString; break;
      case HandClass.Straight5: displayStr += "$lowCardValueString and up"; break;
      case HandClass.StraightFlush4: displayStr += "$suitString, $lowCardValueString and up"; break;
      case HandClass.Flush5: displayStr += suitString; break;
      case HandClass.FullHouse: displayStr += "$suitString, $lowCardValueString and up + " +
          highCard.suit.toString().split('.').last + ", " + valueDisplay(highCard.value) + " and up"; break;
      case HandClass.FourOfAKind: displayStr += lowCardValueString; break;
      case HandClass.StraightFlush5: displayStr += "$suitString, $lowCardValueString and up"; break;
      case HandClass.FiveOfAKind: displayStr += lowCardValueString; break;
      default: break;
    }
    return displayStr;
  }

}
