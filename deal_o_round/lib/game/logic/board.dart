import '../../settings/settings_constants.dart';
import '../game_page.dart';
import 'play_card.dart';
import 'shoe.dart';
import 'suit.dart';
import 'value.dart';

class Board {
  final shoe = Shoe(4);
  List<List<PlayCard>> board;
  final BoardLayout layout;
  final int size;
  final indexes = Iterable<int>.generate(GameState.boardSize).toList();

  Board({this.layout, this.size}) {
    shoe.shuffleAll();
    board = List<List<PlayCard>>();
    for (int i = 0; i < size; i++) {
      board.add(getRandomCards(size +
          (layout == BoardLayout.Hexagonal && i % 2 == 0 ? -1 : 0)));
    }
  }

  List<PlayCard> getRandomCards(int size) {
    return List<PlayCard>.generate(size, (i) => shoe.dealCard());
  }

  removeHand() {
    // TODO: animate remove cards
    // Step 1: bubble the removed cards to the top
    for (var x in indexes) {
      int displacement = 0;
      for (var y in indexes.reversed) {
        if (board[x][y].selected) {
          displacement += 1;
        } else if (displacement > 0) {
          board[x][y + displacement] = board[x][y];
          board[x][y] =
              PlayCard(suit: Suit.Invalid, value: Value.Invalid);
          board[x][y].selected = true;
        }
      }
    }
    // Step 2: deal the removed cards
    for (var x in indexes) {
      for (var y in indexes) {
        if (board[x][y].selected) {
          board[x][y] = shoe.dealCard();
        }
      }
    }
  }
}
