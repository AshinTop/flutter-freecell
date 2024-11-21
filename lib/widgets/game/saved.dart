import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/model/card.dart';
import 'package:freecell/utils/card.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/widgets/game/item_card.dart';

class Saved extends StatelessWidget {
  final int index;

  const Saved({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.of(context).orientation == Orientation.portrait;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<List<GameCard>>(
      valueListenable: currentCards[8],
      builder: (context, data, child) {
        if (data[index].num == 0) {
          return SizedBox(
            width: (p ? w / 8 : h / 8),
            height: p ? w / 5 : h / 5.5,
            child: DragTarget(
              builder: (context, col01, col02) {
                return Card(
                  key: data[index].key,
                  shadowColor: Colors.transparent,
                  margin: const EdgeInsets.all(1.5),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1, //p ? w / 140 : h / 140,
                      ),
                      borderRadius: BorderRadius.circular(6)),
                );
              },
              onWillAccept: (value) {
                return (value as List<GameCard>).length == 1;
              },
              onAccept: (value) {
                List<GameCard> list = value as List<GameCard>;
                List<GameCard> l = currentCards[8].value.toList();
                l[index] = list[0];
                currentCards[8].value = l;
                doMove();
                refreshCol(currentCards[8], [], true);
              },
            ),
          );
        } else {
          GameCard card = data[index];
          List<GameCard> arr = [card];
          card.highlight = true;
          return Draggable(
            data: arr,
            onDragStarted: () {
              refreshCol(currentCards[8], [], true);
              List<GameCard> l = currentCards[8].value.toList();
              l[index] = GameCard(
                num: 0,
                sign: index,
                key: GlobalKey(),
                highlight: true,
                hint: false,
              );
              currentCards[8].value = l;
            },
            onDraggableCanceled: (velocity, offset) {
              List<GameCard> l = currentCards[8].value.toList();
              l[index] = card;
              currentCards[8].value = l;
            },
            feedback: ItemCard(card: card, pg: false, pd: false),
            child: SizedBox(
              width: p ? w / 8 : h / 8,
              child: InkWell(
                enableFeedback: false,
                onTap: () {
                  if (!animating) {
                    tap(context, currentCards[8], arr);
                  }
                },
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
