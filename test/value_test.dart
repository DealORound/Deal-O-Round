import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/value.dart';

void main() {
  group('Value tests', () {
    test('Two has right "value" (index)', () async {
      expect(Value.two.index, 0);
    });

    test('Three has right "value" (index)', () async {
      expect(Value.three.index, 1);
    });

    test('Four has right "value" (index)', () async {
      expect(Value.four.index, 2);
    });

    test('Five has right "value" (index)', () async {
      expect(Value.five.index, 3);
    });

    test('Six has right "value" (index)', () async {
      expect(Value.six.index, 4);
    });

    test('Seven has right "value" (index)', () async {
      expect(Value.seven.index, 5);
    });

    test('Eight has right "value" (index)', () async {
      expect(Value.eight.index, 6);
    });

    test('Nine has right "value" (index)', () async {
      expect(Value.nine.index, 7);
    });

    test('Ten has right "value" (index)', () async {
      expect(Value.ten.index, 8);
    });

    test('Jack has right "value" (index)', () async {
      expect(Value.jack.index, 9);
    });

    test('Queen has right "value" (index)', () async {
      expect(Value.queen.index, 10);
    });

    test('King has right "value" (index)', () async {
      expect(Value.king.index, 11);
    });

    test('Ace has right "value" (index)', () async {
      expect(Value.ace.index, 12);
    });

    test('Joker has right "value" (index)', () async {
      expect(Value.joker.index, 13);
    });

    test('Invalid has right "value" (index)', () async {
      expect(Value.invalid.index, 14);
    });

    test('Two has right string value', () async {
      expect(Value.two.toString().split('.').last, "two");
    });

    test('Three has right string value', () async {
      expect(Value.three.toString().split('.').last, "three");
    });

    test('Four has right string value', () async {
      expect(Value.four.toString().split('.').last, "four");
    });

    test('Five has right string value', () async {
      expect(Value.five.toString().split('.').last, "five");
    });

    test('Six has right string value', () async {
      expect(Value.six.toString().split('.').last, "six");
    });

    test('Seven has right string value', () async {
      expect(Value.seven.toString().split('.').last, "seven");
    });

    test('Eight has right string value', () async {
      expect(Value.eight.toString().split('.').last, "eight");
    });

    test('Nine has right string value', () async {
      expect(Value.nine.toString().split('.').last, "nine");
    });

    test('Ten has right string value', () async {
      expect(Value.ten.toString().split('.').last, "ten");
    });

    test('Jack has right string value', () async {
      expect(Value.jack.toString().split('.').last, "jack");
    });

    test('Queen has right string value', () async {
      expect(Value.queen.toString().split('.').last, "queen");
    });

    test('King has right string value', () async {
      expect(Value.king.toString().split('.').last, "king");
    });

    test('Ace has right string value', () async {
      expect(Value.ace.toString().split('.').last, "ace");
    });

    test('Joker has right string value', () async {
      expect(Value.joker.toString().split('.').last, "joker");
    });

    test('Invalid has right string value', () async {
      expect(Value.invalid.toString().split('.').last, "invalid");
    });

    test('Two has right value character', () async {
      expect(valueCharacter(Value.two), "2");
    });

    test('Three has right "value" (index)', () async {
      expect(valueCharacter(Value.three), "3");
    });

    test('Four has right "value" (index)', () async {
      expect(valueCharacter(Value.four), "4");
    });

    test('Five has right "value" (index)', () async {
      expect(valueCharacter(Value.five), "5");
    });

    test('Six has right "value" (index)', () async {
      expect(valueCharacter(Value.six), "6");
    });

    test('Seven has right "value" (index)', () async {
      expect(valueCharacter(Value.seven), "7");
    });

    test('Eight has right "value" (index)', () async {
      expect(valueCharacter(Value.eight), "8");
    });

    test('Nine has right "value" (index)', () async {
      expect(valueCharacter(Value.nine), "9");
    });

    test('Ten has right "value" (index)', () async {
      expect(valueCharacter(Value.ten), "10");
    });

    test('Jack has right "value" (index)', () async {
      expect(valueCharacter(Value.jack), "J");
    });

    test('Queen has right "value" (index)', () async {
      expect(valueCharacter(Value.queen), "Q");
    });

    test('King has right "value" (index)', () async {
      expect(valueCharacter(Value.king), "K");
    });

    test('Ace has right "value" (index)', () async {
      expect(valueCharacter(Value.ace), "A");
    });

    test('Joker has right "value" (index)', () async {
      expect(valueCharacter(Value.joker), "*");
    });

    test('Invalid has right "value" (index)', () async {
      expect(valueCharacter(Value.invalid), "");
    });

    test('Two has right "valueScore"', () async {
      expect(valueScore(Value.two), 5 * 0);
    });

    test('Three has right "valueScore"', () async {
      expect(valueScore(Value.three), 5 * 1);
    });

    test('Four has right "valueScore"', () async {
      expect(valueScore(Value.four), 5 * 2);
    });

    test('Five has right "valueScore"', () async {
      expect(valueScore(Value.five), 5 * 3);
    });

    test('Six has right "valueScore"', () async {
      expect(valueScore(Value.six), 5 * 4);
    });

    test('Seven has right "valueScore"', () async {
      expect(valueScore(Value.seven), 5 * 5);
    });

    test('Eight has right "valueScore"', () async {
      expect(valueScore(Value.eight), 5 * 6);
    });

    test('Nine has right "valueScore"', () async {
      expect(valueScore(Value.nine), 5 * 7);
    });

    test('Ten has right "valueScore"', () async {
      expect(valueScore(Value.ten), 5 * 8);
    });

    test('Jack has right "valueScore"', () async {
      expect(valueScore(Value.jack), 5 * 9);
    });

    test('Queen has right "valueScore"', () async {
      expect(valueScore(Value.queen), 5 * 10);
    });

    test('King has right "valueScore"', () async {
      expect(valueScore(Value.king), 5 * 11);
    });

    test('Ace has right "valueScore"', () async {
      expect(valueScore(Value.ace), 5 * 12);
    });

    test('Joker has right "valueScore"', () async {
      expect(valueScore(Value.joker), 5 * 13);
    });

    test('Invalid has right "valueScore"', () async {
      expect(valueScore(Value.invalid), 5 * 14);
    });
  });
}
