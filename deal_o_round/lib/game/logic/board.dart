import 'package:flutter/material.dart';
import '../../services/settings_constants.dart';
import '../logic/suit.dart';
import '../logic/value.dart';
import '../chip_widget.dart';
import '../game_page.dart';
import 'play_card.dart';
import 'shoe.dart';

class Board {
  static const SHOE_SIZE = 4;

  final shoe = Shoe(SHOE_SIZE);
  List<List<PlayCard>> board;
  final BoardLayout layout;
  final indexes = Iterable<int>.generate(GameState.BOARD_SIZE).toList();

  Board({this.layout}) {
    shoe.shuffleAll();
    board = indexes
        .map((i) => getRandomCards(GameState.BOARD_SIZE +
            (layout == BoardLayout.Hexagonal && i % 2 == 0 ? -1 : 0)))
        .toList();
  }

  @override
  String toString() {
    return board
        .map((col) => col.map((c) => c.toString()).toList().join('_'))
        .toList()
        .join('|');
  }

  List<PlayCard> getRandomCards(int size) {
    return List<PlayCard>.generate(size, (i) => shoe.dealCard());
  }

  static Widget buildItem(PlayCard card, Animation<double> animation) {
    return RotationTransition(
      turns: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: ChipWidget(key: Key(card.toString()), card: card),
      ),
    );
  }

  removeHand(List<GlobalKey<AnimatedListState>> listKeys, int animationDelay) {
    // Step 1: bubble the selected cards to the top for removal
    // And remove (animated) them from the AnimatedLists
    for (var x in indexes) {
      int displacement = 0;
      int maxY = GameState.BOARD_SIZE +
          (layout == BoardLayout.Hexagonal && x % 2 == 0 ? -1 : 0);
      final listKey = listKeys[x];
      for (var y = maxY - 1; y >= 0; y--) {
        if (board[x][y].selected) {
          listKey.currentState.removeItem(
              y, (context, animation) => buildItem(board[x][y], animation),
              duration: Duration(milliseconds: animationDelay));
          displacement += 1;
        } else if (displacement > 0) {
          board[x][y + displacement] = board[x][y];
          board[x][y] = PlayCard(suit: Suit.Invalid, value: Value.Invalid);
          board[x][y].selected = true;
        }
      }
    }
    // Step 2: deal new cards in place of the removed (selected) cards
    // And insert (animated) them to the AnimatedLists
    for (var x in indexes) {
      int maxY = GameState.BOARD_SIZE +
          (layout == BoardLayout.Hexagonal && x % 2 == 0 ? -1 : 0);
      final listKey = listKeys[x];
      for (var y = 0; y < maxY; y++) {
        if (board[x][y].selected) {
          board[x][y] = shoe.dealCard();
          listKey.currentState.insertItem(y);
        }
      }
    }
  }
}
