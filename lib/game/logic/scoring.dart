import 'hand_class.dart';
import 'play_card.dart';
import 'suit.dart';
import 'value.dart';

class Scoring {
  HandClass handClass;
  PlayCard lowCard;
  PlayCard? highCard;
  String handDigest;

  Scoring(this.handClass, this.lowCard, this.handDigest, {this.highCard}) {
    if (handClass == HandClass.twoPair || handClass == HandClass.fullHouse) {
      assert(highCard != null);
    }
  }

  int score() {
    int score = handBaseValue(handClass);
    if (lowCard.value != Value.invalid) {
      score += valueScore(lowCard.value);
    }
    if (highCard != null && highCard?.value != Value.invalid) {
      score += 2 * valueScore(highCard!.value);
    }
    return score;
  }

  String toStringDisplay() {
    String handString = handDisplayString(handClass);
    if (handClass == HandClass.none) {
      return handString;
    }

    if (lowCard.value == Value.invalid || lowCard.suit == Suit.invalid) {
      return "None";
    }

    String displayStr = "$handString of ";
    final String suitString = lowCard.suit.toString().split('.').last;
    final lowCardValueString = valueDisplay(lowCard.value);
    switch (handClass) {
      case HandClass.onePair:
        displayStr += lowCardValueString;
        break;
      case HandClass.flush3:
        displayStr += suitString;
        break;
      case HandClass.straight3:
        displayStr += "$lowCardValueString and up";
        break;
      case HandClass.straightFlush3:
        displayStr += "$suitString, $lowCardValueString and up";
        break;
      case HandClass.threeOfAKind:
        displayStr += lowCardValueString;
        break;
      case HandClass.straight4:
        displayStr += "$lowCardValueString and up";
        break;
      case HandClass.twoPair:
        displayStr +=
            "${valueDisplay(highCard?.value ?? Value.invalid)} + $lowCardValueString";
        break;
      case HandClass.flush4:
        displayStr += suitString;
        break;
      case HandClass.straight5:
        displayStr += "$lowCardValueString and up";
        break;
      case HandClass.straightFlush4:
        displayStr += "$suitString, $lowCardValueString and up";
        break;
      case HandClass.flush5:
        displayStr += suitString;
        break;
      case HandClass.fullHouse:
        displayStr +=
            "$suitString, $lowCardValueString and up + ${(highCard?.suit ?? Suit.invalid).toString().split('.').last}, ${valueDisplay(highCard?.value ?? Value.invalid)} and up";
        break;
      case HandClass.fourOfAKind:
        displayStr += lowCardValueString;
        break;
      case HandClass.straightFlush5:
        displayStr += "$suitString, $lowCardValueString and up";
        break;
      case HandClass.fiveOfAKind:
        displayStr += lowCardValueString;
        break;
      default:
        break;
    }
    return displayStr;
  }
}
