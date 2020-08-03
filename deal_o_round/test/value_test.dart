import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/value.dart';

void main() {
  group('Value tests', () {
    test('Two has right "value" (index)', () async {
      expect(Value.Two.index, 0);
    });

    test('Three has right "value" (index)', () async {
      expect(Value.Three.index, 1);
    });

    test('Four has right "value" (index)', () async {
      expect(Value.Four.index, 2);
    });

    test('Five has right "value" (index)', () async {
      expect(Value.Five.index, 3);
    });

    test('Six has right "value" (index)', () async {
      expect(Value.Six.index, 4);
    });

    test('Seven has right "value" (index)', () async {
      expect(Value.Seven.index, 5);
    });

    test('Eight has right "value" (index)', () async {
      expect(Value.Eight.index, 6);
    });

    test('Nine has right "value" (index)', () async {
      expect(Value.Nine.index, 7);
    });

    test('Ten has right "value" (index)', () async {
      expect(Value.Ten.index, 8);
    });

    test('Jack has right "value" (index)', () async {
      expect(Value.Jack.index, 9);
    });

    test('Queen has right "value" (index)', () async {
      expect(Value.Queen.index, 10);
    });

    test('King has right "value" (index)', () async {
      expect(Value.King.index, 11);
    });

    test('Ace has right "value" (index)', () async {
      expect(Value.Ace.index, 12);
    });

    test('Two has right string value', () async {
      expect(Value.Two.toString().split('.').last, "Two");
    });

    test('Three has right string value', () async {
      expect(Value.Three.toString().split('.').last, "Three");
    });

    test('Four has right string value', () async {
      expect(Value.Four.toString().split('.').last, "Four");
    });

    test('Five has right string value', () async {
      expect(Value.Five.toString().split('.').last, "Five");
    });

    test('Six has right string value', () async {
      expect(Value.Six.toString().split('.').last, "Six");
    });

    test('Seven has right string value', () async {
      expect(Value.Seven.toString().split('.').last, "Seven");
    });

    test('Eight has right string value', () async {
      expect(Value.Eight.toString().split('.').last, "Eight");
    });

    test('Nine has right string value', () async {
      expect(Value.Nine.toString().split('.').last, "Nine");
    });

    test('Ten has right string value', () async {
      expect(Value.Ten.toString().split('.').last, "Ten");
    });

    test('Jack has right string value', () async {
      expect(Value.Jack.toString().split('.').last, "Jack");
    });

    test('Queen has right string value', () async {
      expect(Value.Queen.toString().split('.').last, "Queen");
    });

    test('King has right string value', () async {
      expect(Value.King.toString().split('.').last, "King");
    });

    test('Ace has right string value', () async {
      expect(Value.Ace.toString().split('.').last, "Ace");
    });

    test('Two has right value character', () async {
      expect(valueCharacter(Value.Two), "2");
    });

    test('Three has right "value" (index)', () async {
      expect(valueCharacter(Value.Three), "3");
    });

    test('Four has right "value" (index)', () async {
      expect(valueCharacter(Value.Four), "4");
    });

    test('Five has right "value" (index)', () async {
      expect(valueCharacter(Value.Five), "5");
    });

    test('Six has right "value" (index)', () async {
      expect(valueCharacter(Value.Six), "6");
    });

    test('Seven has right "value" (index)', () async {
      expect(valueCharacter(Value.Seven), "7");
    });

    test('Eight has right "value" (index)', () async {
      expect(valueCharacter(Value.Eight), "8");
    });

    test('Nine has right "value" (index)', () async {
      expect(valueCharacter(Value.Nine), "9");
    });

    test('Ten has right "value" (index)', () async {
      expect(valueCharacter(Value.Ten), "10");
    });

    test('Jack has right "value" (index)', () async {
      expect(valueCharacter(Value.Jack), "J");
    });

    test('Queen has right "value" (index)', () async {
      expect(valueCharacter(Value.Queen), "Q");
    });

    test('King has right "value" (index)', () async {
      expect(valueCharacter(Value.King), "K");
    });

    test('Ace has right "value" (index)', () async {
      expect(valueCharacter(Value.Ace), "A");
    });
  });
}
