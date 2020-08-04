import 'package:flutter/material.dart';
import '../game/logic/play_card.dart';
import '../game/logic/suit.dart';
import '../game/logic/value.dart';
import 'chip_painter.dart';
import 'chip_selection_painter.dart';
import 'game_page.dart';

class ChipWidget extends StatefulWidget {
  final PlayCard card;
  ChipWidget({this.card});

  @override
  State<StatefulWidget> createState() {
    return ChipWidgetState(card: card);
  }
}

class ChipWidgetState extends State<ChipWidget> {
  final PlayCard card;
  String _suit;
  String _value;
  bool _selected = false;
  bool _neighbor = false;

  ChipWidgetState({
    this.card
  }) {
    this._suit = suitCharacter(card.suit);
    this._value = valueCharacter(card.value);
  }

  toggleSelected() {
    _selected = !_selected;
  }

  toggleNeighbor() {
    _neighbor = !_neighbor;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = (_suit == 'C' || _suit == 'S') ?
      Colors.black : Colors.red;
    final suitStyle = TextStyle(
      fontSize: 50,
      fontFamily: 'Cards',
      color: textColor
    );
    final valueStyle = TextStyle(
      fontSize: 50,
      fontFamily: 'Stint-Ultra-Condensed',
      fontWeight: FontWeight.w700,
      color: textColor
    );

    return SizedBox(
      width: 80,
      height: 80,
      child: GestureDetector(
        onDoubleTap: null,
        onTap: () {
          DateTime now = DateTime.now();
          debugPrint("onTap at $now!");
          setState(() {
            now = DateTime.now();
            debugPrint("onTap setState1 at $now!");
            toggleSelected();
            (context as Element).markNeedsBuild();
            final state = GamePage.of(context);
            state.setState(() {
              now = DateTime.now();
              debugPrint("onTap setState2 at $now!");
              state.incrementSelected();
            });
            // TODO: toggle board as well
            // TODO: display hand
          });
        },
        child: CustomPaint(
          painter: ChipPainter(),
          foregroundPainter: ChipSelectionPainter(
            selected: _selected, neighbor: _neighbor),
          child: Center(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.visible,
              text: TextSpan(
                text: _value,
                style: valueStyle,
                children: <TextSpan>[
                  TextSpan(text: _suit, style: suitStyle)
                ]
              )
            )
          )
        )
      )
    );
  }
}
