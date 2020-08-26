import 'package:flutter/material.dart';
import '../services/settings_constants.dart';
import '../services/size.dart';
import 'logic/board.dart';
import 'logic/play_card.dart';
import 'chip_widget.dart';
import 'game_page.dart';

class GameBoard extends StatelessWidget {
  Column getColumn(List<PlayCard> column, int index, BoardLayout layout,
      double radius)
  {
    final key = column.map((c) => c.toString()).toList().join('_');
    final items = column.map((c) => ChipWidget(card: c) as Widget).toList();
    if (index % 2 == 0 && layout == BoardLayout.Hexagonal) {
      items.add(SizedBox(height: radius));
    }
    return Column(
      key: Key(key),
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items
    );
  }

  Row getColumns(Board board, BoardLayout layout, double radius) {
    List<Widget> columns = [];
    board.board.asMap().forEach((index, column) =>
      columns.add(getColumn(column, index, layout, radius))
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: columns
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = GamePage.of(context);
    final greenDecoration = BoxDecoration(
      color: Colors.green.shade900,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: Colors.green.shade700,
        width: 3.0
      )
    );
    final diameter = chipSize(context);
    final size = diameter * GameState.boardSize;
    final textStyle = TextStyle(
        fontSize: diameter * 0.4,  // ~32
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
        Center(child: Text("Paused\u{2026}", style: textStyle)) :
        Listener(
          onPointerDown: (PointerEvent details) => state.onPointerDown(details),
          onPointerMove: (PointerEvent details) => state.onPointerMove(details),
          onPointerUp: (PointerEvent details) => state.onPointerUp(details),
          child: getColumns(state.board, state.layout, diameter / 2)
        )
      )
    );
  }
}
