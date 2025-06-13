import 'package:flutter_test/flutter_test.dart';
import 'package:deal_o_round/game/logic/suit.dart';

void main() {
  group('Suit tests', () {
    test('Spades has right "value" (index)', () async {
      expect(Suit.spades.index, 0);
    });

    test('Clubs has right "value" (index)', () async {
      expect(Suit.clubs.index, 1);
    });

    test('Diamonds has right "value" (index)', () async {
      expect(Suit.diamonds.index, 2);
    });

    test('Hearts has right "value" (index)', () async {
      expect(Suit.hearts.index, 3);
    });

    test('Invalid has right "value" (index)', () async {
      expect(Suit.invalid.index, 4);
    });

    test('Spades has right display string', () async {
      expect(Suit.spades.toString().split('.').last, "spades");
    });

    test('Clubs has right display string', () async {
      expect(Suit.clubs.toString().split('.').last, "clubs");
    });

    test('Diamonds has right display string', () async {
      expect(Suit.diamonds.toString().split('.').last, "diamonds");
    });

    test('Hearts has right display string', () async {
      expect(Suit.hearts.toString().split('.').last, "hearts");
    });

    test('Invalid has right display string', () async {
      expect(Suit.invalid.toString().split('.').last, "invalid");
    });

    test('Spades has right character string', () async {
      expect(suitCharacter(Suit.spades), "s");
    });

    test('Clubs has right character string', () async {
      expect(suitCharacter(Suit.clubs), "c");
    });

    test('Diamonds has right character string', () async {
      expect(suitCharacter(Suit.diamonds), "4");
    });

    test('Hearts has right character string', () async {
      expect(suitCharacter(Suit.hearts), "3");
    });

    test('Invalid has right character string', () async {
      expect(suitCharacter(Suit.invalid), "");
    });
  });
}
