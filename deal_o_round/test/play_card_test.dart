import 'dart:math';

import 'package:deal_o_round/game/logic/play_card.dart';
import 'package:deal_o_round/game/logic/suit.dart';
import 'package:deal_o_round/game/logic/value.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final maxDeckCount = 8;

  group('PlayCard tests', () {
    test('Hash codes of different cards are different', () async {
      final hashCodes = [];
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card = PlayCard(suit, value, deck: deck);
                card.selected = selected;
                card.neighbor = neighbor;
                final hashCode = card.hashCode;
                expect(hashCodes.contains(hashCode), false);
                hashCodes.add(hashCode);
              }
            }
          }
        }
      }
    });

    test('String representation of different cards are different', () async {
      final strings = [];
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card = PlayCard(suit, value, deck: deck);
                card.selected = selected;
                card.neighbor = neighbor;
                final str = card.toString();
                expect(strings.contains(str), false);
                strings.add(str);
              }
            }
          }
        }
      }
    });

    test('Equal cards are equal', () async {
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card1 = PlayCard(suit, value, deck: deck);
                card1.selected = selected;
                card1.neighbor = neighbor;
                final card2 = PlayCard(suit, value, deck: deck);
                card2.selected = selected;
                card2.neighbor = neighbor;
                expect(card1 == card2, true);
                expect(card1.compareTo(card2), 0);
              }
            }
          }
        }
      }
    });

    test('Selection influence equality, does not influence compare', () async {
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card1 = PlayCard(suit, value, deck: deck);
                card1.selected = selected;
                card1.neighbor = neighbor;
                final card2 = PlayCard(suit, value, deck: deck);
                card2.selected = !selected;
                card2.neighbor = neighbor;
                expect(card1 == card2, false);
                expect(card1.compareTo(card2), 0);
              }
            }
          }
        }
      }
    });

    test('Neighborhood influence equality, does not influence compare', () async {
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card1 = PlayCard(suit, value, deck: deck);
                card1.selected = selected;
                card1.neighbor = neighbor;
                final card2 = PlayCard(suit, value, deck: deck);
                card2.selected = selected;
                card2.neighbor = !neighbor;
                expect(card1 == card2, false);
                expect(card1.compareTo(card2), 0);
              }
            }
          }
        }
      }
    });

    test('Deck number influence equality, does not influence compare', () async {
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card1 = PlayCard(suit, value, deck: deck);
                card1.selected = selected;
                card1.neighbor = neighbor;
                int deck2;
                do {
                  deck2 = Random().nextInt(maxDeckCount);
                } while (deck2 == deck);

                final card2 = PlayCard(suit, value, deck: deck2);
                card2.selected = selected;
                card2.neighbor = neighbor;
                expect(card1 == card2, false);
                expect(card1.compareTo(card2), 0);
              }
            }
          }
        }
      }
    });

    test('Different suit cards are not equal', () async {
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card1 = PlayCard(suit, value, deck: deck);
                card1.selected = selected;
                card1.neighbor = neighbor;
                Suit suit2;
                do {
                  suit2 = Suit.values[Random().nextInt(Suit.values.length)];
                } while (suit2 == suit);

                final card2 = PlayCard(suit2, value, deck: deck);
                card2.selected = selected;
                card2.neighbor = neighbor;
                expect(card1 == card2, false);
                expect(card1.compareTo(card2), suit.index - suit2.index);
              }
            }
          }
        }
      }
    });

    test('Different value cards are not equal', () async {
      for (int deck = 0; deck < maxDeckCount; deck++) {
        for (Value value in Value.values) {
          for (Suit suit in Suit.values) {
            for (bool selected in [true, false]) {
              for (bool neighbor in [true, false]) {
                final card1 = PlayCard(suit, value, deck: deck);
                card1.selected = selected;
                card1.neighbor = neighbor;
                Value value2;
                do {
                  value2 = Value.values[Random().nextInt(Value.values.length)];
                } while (value2 == value);

                final card2 = PlayCard(suit, value2, deck: deck);
                card2.selected = selected;
                card2.neighbor = neighbor;
                expect(card1 == card2, false);
                expect(card1.compareTo(card2), value.index - value2.index);
              }
            }
          }
        }
      }
    });
  });
}
