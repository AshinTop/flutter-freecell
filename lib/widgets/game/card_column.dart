import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/card.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/model/card.dart';
import 'package:freecell/widgets/game/item_card.dart';

class CardColumn extends StatelessWidget {
  final int listIndex;
  const CardColumn({super.key, required this.listIndex});

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.of(context).orientation == Orientation.portrait;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<bool>(
      valueListenable: theme,
      builder: (context, themeMode, widget) {
        return ValueListenableBuilder<List<GameCard>>(
          valueListenable: currentCards[listIndex],
          builder: (context, snap, child) {
            return SizedBox(
              key: colKeys[listIndex],
              width: p ? w / 8 : h / 8,
              height: colHeight(snap, p, w, h) < h / 3
                  ? h / 3
                  : colHeight(snap, p, w, h) + (p ? (w / 5) : h / 5.5),
              child: snap.isNotEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snap.length,
                      itemBuilder: (context2, i) {
                        List<GameCard> snapList = snap.toList();
                        GameCard card = snapList[i];
                        List<GameCard> arr = array(card, snapList);
                        card.highlight = i == snap.length - 1;
                        return Draggable(
                          feedback: SizedBox(
                            height: colHeight(arr, p, w, h),
                            width: p ? w / 8 : h / 8,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: arr.length,
                              itemBuilder: (BuildContext context, int index2) {
                                if (arr.length <= freeSpace() &&
                                    i == currentCards[listIndex].value.length) {
                                  arr[index2].highlight =
                                      index2 == arr.length - 1;
                                  return ItemCard(
                                    card: arr[index2],
                                    // pd: arr.length > index2 + 1
                                    //     ? (par(arr[index2], arr[index2 + 1]))
                                    //     : false,
                                    // pg: arr.length > index2 && index2 != 0
                                    //     ? (par(arr[index2 - 1], arr[index2]))
                                    //     : false,
                                    pd: arr.length > index2 + 1 ? true : false,
                                    pg: arr.length > index2 && index2 != 0
                                        ? true
                                        : false,
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          onDraggableCanceled: (velocity, offset) {
                            if (arr.length <= freeSpace() &&
                                i == currentCards[listIndex].value.length) {
                              refreshCol(currentCards[listIndex], arr, true);
                            }
                          },
                          onDragStarted: () {
                            if (arr.length <= freeSpace() &&
                                i == snap.length - arr.length) {
                              refreshCol(currentCards[listIndex], arr, false);
                            } else if (arr.length > freeSpace()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'Free space: ${freeSpace()}',
                                ),
                                duration: const Duration(seconds: 1),
                              ));
                            }
                          },
                          data: (arr.length <= freeSpace() &&
                                  i == snap.length - arr.length)
                              ? arr
                              : <GameCard>[],
                          child: InkWell(
                            enableFeedback: false,
                            onTap: () {
                              if (arr.length <= freeSpace() &&
                                  i == snap.length - arr.length &&
                                  !animating) {
                                tap(context, currentCards[listIndex], arr);
                              } else if (arr.length > freeSpace()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Free space: ${freeSpace()}',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ));
                              }
                            },
                            child: DragTarget(
                              builder: (context, col01, col02) {
                                return ItemCard(
                                  card: card,
                                  // pd: snap.length - 1 > i
                                  //     ? (par(snap[i], snap[i + 1]))
                                  //     : false,
                                  // pg: snap.length > i && i != 0
                                  //     ? (par(snap[i - 1], snap[i]))
                                  //     : false,
                                  pd: snap.length - 1 > i ? true : false,
                                  pg: snap.length > i && i != 0 ? true : false,
                                );
                              },
                              onWillAccept: (data) {
                                return i == snap.length - 1 &&
                                    (data as List<GameCard>).isNotEmpty &&
                                    par(card, data[0]) &&
                                    data.length <= freeSpace();
                              },
                              onAccept: (data) {
                                refreshCol(currentCards[listIndex],
                                    data as List<GameCard>, true);
                                doMove();
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      width: w / 8 - 1,
                      child: DragTarget(
                        builder: (context, col01, col02) {
                          return Container();
                        },
                        onWillAccept: (data) {
                          return (data as List<GameCard>).isNotEmpty;
                        },
                        onAccept: (data) {
                          refreshCol(currentCards[listIndex],
                              data as List<GameCard>, true);
                          doMove();
                        },
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
