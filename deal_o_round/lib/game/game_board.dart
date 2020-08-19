import 'package:flutter/material.dart';
import '../settings/settings_constants.dart';
import 'logic/board.dart';
import 'logic/play_card.dart';
import 'chip_widget.dart';
import 'game_page.dart';

class GameBoard extends StatelessWidget {
  Column getColumn(String columnString) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: columnString.split('_').map((c) {
        final strs = c.split('-');
        final card = PlayCard.fromString(strs[0], strs[1], strs[2], strs[3]);
        return ChipWidget(card: card);
      }).toList()
    );
  }

  Row getColumns(BoardLayout layout, String boardString) {
    debugPrint("redraw");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: boardString.split('|').map((col) => getColumn(col)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = GamePage.of(context);
    final layout = state.layout;
    final boardString = state.boardString;
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
          child: getColumns(layout, boardString)
        )
      )
    );
  }
}
