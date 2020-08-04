import '../../settings/settings_constants.dart';
import 'play_card.dart';
import 'shoe.dart';

class Board {
  final shoe = Shoe(4);
  List<List<PlayCard>> board;
  final BoardLayout layout;
  final int size;

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
}
