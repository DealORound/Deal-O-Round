import 'package:flutter/material.dart';

import '../services/size.dart';
import 'logic/game_constants.dart';
import 'logic/board.dart';
import 'logic/play_card.dart';
import 'game_page.dart';

class GameBoard extends StatelessWidget {
  Column getColumn(List<PlayCard> column, int index, BoardLayout layout,
      GlobalKey<AnimatedListState> listKey, double diameter) {
    var height = 0.0;
    var itemCount = GameState.BOARD_SIZE;
    if (index % 2 == 0 && layout == BoardLayout.Hexagonal) {
      height = diameter / 2;
      itemCount--;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: itemCount * diameter,
              width: diameter,
              child: AnimatedList(
                key: listKey,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index, animation) =>
                    buildItem(context, index, animation, column),
              )),
          SizedBox(height: height, width: diameter)
        ]);
  }

  Widget buildItem(
      BuildContext context, int index, Animation<double> animation, List<PlayCard> column) {
    if (index > column.length - 1) {
      return SizedBox(width: 40, height: 0);
    }

    return Board.buildItem(column[index], animation);
  }

  Row getColumns(
    Board board,
    BoardLayout layout,
    List<GlobalKey<AnimatedListState>> listKeys,
    double diameter,
  ) {
    List<Widget> columns = [];
    board.board.asMap().forEach((index, column) =>
        columns.add(getColumn(column, index, layout, listKeys[index], diameter)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: columns,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = GamePage.of(context);
    if (state == null) {
      return Container();
    }

    final greenDecoration = BoxDecoration(
      color: Colors.green.shade900,
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(color: Colors.green.shade700, width: 3.0),
    );
    final diameter = chipSize(context);
    final size = diameter * GameState.BOARD_SIZE;
    final textStyle = TextStyle(
      fontSize: diameter * 0.4, // ~32
      fontFamily: 'Roboto Condensed',
      color: Colors.white,
    );

    return Container(
      decoration: greenDecoration,
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: size,
        height: size,
        child: IndexedStack(
          index: state.paused ? 0 : 1,
          children: [
            Center(child: Text("Paused\u{2026}", style: textStyle)),
            Listener(
              onPointerDown: (PointerEvent details) => state.onPointerDown(details),
              onPointerMove: (PointerEvent details) => state.onPointerMove(details),
              onPointerUp: (PointerEvent details) => state.onPointerUp(details),
              child: getColumns(state.board, state.layout, state.listKeys, diameter),
            ),
          ],
        ),
      ),
    );
  }
}
