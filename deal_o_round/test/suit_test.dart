import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/suit.dart';

void main() {
  group('Suit tests', () async {
    test('Spades has right "value" (index)', () async {
      expect(Suit.Spades.index, 0);
    });

    test('Clubs has right "value" (index)', () async {
      expect(Suit.Clubs.index, 1);
    });

    test('Diamonds has right "value" (index)', () async {
      expect(Suit.Diamonds.index, 2);
    });

    test('Hearts has right "value" (index)', () async {
      expect(Suit.Hearts.index, 3);
    });

    test('Invalid has right "value" (index)', () async {
      expect(Suit.Invalid.index, 4);
    });

    test('Spades has right display string', () async {
      expect(Suit.Spades.toString().split('.').last, "Spades");
    });

    test('Clubs has right display string', () async {
      expect(Suit.Clubs.toString().split('.').last, "Clubs");
    });

    test('Diamonds has right display string', () async {
      expect(Suit.Diamonds.toString().split('.').last, "Diamonds");
    });

    test('Hearts has right display string', () async {
      expect(Suit.Hearts.toString().split('.').last, "Hearts");
    });

    test('Invalid has right display string', () async {
      expect(Suit.Invalid.toString().split('.').last, "Invalid");
    });

    test('Spades has right character string', () async {
      expect(suiteCharacter(Suit.Spades), "S");
    });

    test('Clubs has right character string', () async {
      expect(suiteCharacter(Suit.Clubs), "C");
    });

    test('Diamonds has right character string', () async {
      expect(suiteCharacter(Suit.Diamonds), "4");
    });

    test('Hearts has right character string', () async {
      expect(suiteCharacter(Suit.Hearts), "3");
    });

    test('Invalid has right character string', () async {
      expect(suiteCharacter(Suit.Invalid), "");
    });
  });
}
