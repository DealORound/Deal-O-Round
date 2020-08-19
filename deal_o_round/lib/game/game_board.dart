import 'package:flutter/material.dart';
import '../settings/settings_constants.dart';
import 'logic/play_card.dart';
import 'chip_widget.dart';
import 'game_page.dart';

class GameBoard extends StatelessWidget {
  Column getColumn(List<PlayCard> column) {
    return Column(
      key: Key(column.map((c) => c.toString()).toList().join('_')),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: column.map((c) => ChipWidget(card: c)).toList()
    );
  }

  Row getColumns(BoardLayout layout, List<List<PlayCard>> board) {
    debugPrint("redraw");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: board.map((col) => getColumn(col)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = GamePage.of(context);
    final layout = state.layout;
    final board = state.board;
    final greenDecoration = BoxDecoration(
      color: Colors.green.shade900,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.green.shade700,
        width: 3.0
      )
    );
    const size = ChipWidgetState.chipSize * GameState.boardSize;
    const textStyle = TextStyle(
        fontSize: 32.0,
        fontFamily: 'Roboto Condensed',
        color: Colors.white
    );

    return Container(
      decoration: greenDecoration,
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: size,
        height: size,
        child: state.paused ?
        Center(child: Text("Paused...", style: textStyle)) :
        Listener(
          onPointerDown: (PointerEvent details) => state.onPointerDown(details),
          onPointerMove: (PointerEvent details) => state.onPointerMove(details),
          onPointerUp: (PointerEvent details) => state.onPointerUp(details),
          child: getColumns(layout, board.board)
        )
      )
    );
  }
}
