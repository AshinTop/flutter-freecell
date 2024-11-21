import 'package:flutter/material.dart';
import 'package:freecell/config/app.dart';
import 'package:freecell/data.dart';
import 'package:freecell/model/card.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/utils/logger.dart';
import 'package:freecell/widgets/game/item_card.dart';

class Done extends StatefulWidget {
  final int index;
  const Done({super.key, required this.index});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  int startNum = 0;
  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.of(context).orientation == Orientation.portrait;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<List<GameCard>>(
      valueListenable: currentCards[9],
      builder: (context, snap, child) {
        if (snap[widget.index].num == 0) {
          return SizedBox(
            key: keys[widget.index],
            height: p ? w / 5 : h / 5.5,
            width: p ? w / 8 : h / 8,
            child: DragTarget(
              onWillAccept: (data) {
                return (data as List<GameCard>).length == 1 &&
                    (data[0].sign == snap[widget.index].sign) &&
                    (data[0].num == snap[widget.index].num + 1);
              },
              onAccept: (data) {
                List<GameCard> list = data as List<GameCard>;
                currentCards[9].value[widget.index] = list[0];
                doMove();
                refreshCol(currentCards[9], [], true);
              },
              builder: (context, col1, col2) {
                if (snap[widget.index].num != 0) {
                  snap[widget.index].highlight = true;
                  return ItemCard(
                      card: snap[widget.index], pg: false, pd: false);
                } else {
                  return Card(
                    key: snap[widget.index].key,
                    shadowColor: Colors.transparent,
                    margin: const EdgeInsets.all(1.5),
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1, //p ? w / 140 : h / 140,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                        child: Icon(
                      cardIcons[widget.index],
                      color: widget.index > 1
                          ? Colors.blueGrey.shade300
                          : Colors.red.shade300,
                    )),
                  );
                }
              },
            ),
          );
        } else {
          GameCard card = snap[widget.index];
          List<GameCard> arr = [card];

          return Draggable(
            data: arr,
            onDragStarted: () {
              startNum = card.num;
              logger.d({'onDragStarted': startNum});
              refreshCol(currentCards[9], [], true);
              List<GameCard> l = currentCards[9].value.toList();
              l[widget.index] = GameCard(
                num: startNum - 1,
                sign: widget.index,
                key: GlobalKey(),
                highlight: true,
                hint: false,
              );
              currentCards[9].value = l;
            },
            onDraggableCanceled: (velocity, offset) {
              List<GameCard> l = currentCards[9].value.toList();
              logger.d({'onDraggableCanceled': startNum});
              l[widget.index] = GameCard(
                num: startNum,
                sign: widget.index,
                key: GlobalKey(),
                highlight: true,
                hint: false,
              );
              currentCards[9].value = l;
            },
            feedback: ItemCard(card: card, pg: false, pd: false),
            child: SizedBox(
              width: p ? w / 8 : h / 8,
              child: InkWell(
                enableFeedback: false,
                onTap: () {},
                child: ItemCard(
                  card: card,
                  pd: false,
                  pg: false,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
