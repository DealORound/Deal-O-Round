import 'package:flutter/material.dart';
import '../settings/settings_constants.dart';
import 'logic/board.dart';
import 'chip_widget.dart';
import 'game_page.dart';

class GameBoard extends StatelessWidget {
  Column getColumn(int row, int size, Board board) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        for(var i = 0; i < size; i += 1)
          ChipWidget(card: board.board[row][i])
      ]
    );
  }

  Row getColumns(int size, BoardLayout layout, Board board) {
    debugPrint("redraw");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for(var i = 0; i < size; i += 1)
          getColumn(i, size +
              (layout == BoardLayout.Hexagonal && i % 2 == 0 ? -1 : 0), board)
      ]
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
          child: getColumns(GameState.boardSize, layout, board)
        )
      )
    );
  }
}
