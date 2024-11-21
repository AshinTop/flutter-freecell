import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/model/card.dart';
import 'package:freecell/utils/logger.dart';
import 'package:freecell/utils/sound.dart';
import 'package:freecell/widgets/game/item_card.dart';

int flyingCount = 0;
Future<void> animateSolve(ValueNotifier<List<GameCard>> fromList, int i) async {
  try {
    GameCard last = fromList.value.last;
    if (i < 9) {
      last = currentCards[8].value[i];
      List<GameCard> l = currentCards[8].value.toList();
      l[i] = GameCard(num: 0, sign: 0, highlight: true, key: GlobalKey());
      currentCards[8].value = l;
      refreshCol(fromList, [], false);
    } else {
      refreshCol(fromList, [last], false);
    }
    final entry = OverlayEntry(
      builder: (BuildContext context) {
        return TweenAnimationBuilder(
          tween: Tween<Offset>(
            begin: (last.key.currentContext!.findRenderObject() as RenderBox)
                .localToGlobal(Offset.zero),
            end: (currentCards[9]
                    .value[last.sign]
                    .key
                    .currentContext!
                    .findRenderObject() as RenderBox)
                .localToGlobal(Offset.zero),
          ),
          duration: duration,
          curve: Curves.easeOutCubic,
          builder: (context2, Offset value, child) {
            final p =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final w = MediaQuery.of(context).size.width;
            final h = MediaQuery.of(context).size.height;
            return Positioned(
              left: value.dx,
              top: value.dy,
              child: SizedBox(
                height: colHeight([last], p, w, h),
                width: p ? w / 8 : h / 8,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index2) {
                    last.key = GlobalKey();
                    last.highlight = true;
                    return ItemCard(
                      card: last,
                      pd: false,
                      pg: false,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
    Overlay.of(ctx).insert(entry);
    await Future.delayed(const Duration(milliseconds: 64));
    unawaited(Future.delayed(duration, () {
      entry.remove();
    }));
    if (appConfigs['haptic']) HapticFeedback.selectionClick();
    refreshCol(currentCards[9], [], false);
    List<GameCard> l = currentCards[9].value.toList();
    l[last.sign].num++;
    currentCards[9].value = l;
    doMove();
  } catch (e) {
    logger.e('animateSolve error:', error: e);
  }
}

Future<void> animateShuffle(
    GameCard fromcard, ValueNotifier<List<GameCard>> toList) async {
  try {
    bool empty = toList.value.isEmpty;
    GameCard toCard;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final box1 =
            keys[fromcard.sign].currentContext!.findRenderObject() as RenderBox;
        final pos1 = box1.localToGlobal(Offset.zero);
        final RenderBox box2;

        if (!empty) {
          toCard = toList.value.last;
          box2 = toCard.key.currentContext!.findRenderObject() as RenderBox;
        } else {
          box2 = colKeys[currentCards.indexOf(toList)]
              .currentContext!
              .findRenderObject() as RenderBox;
        }

        Offset pos2 = box2.localToGlobal(
          Offset(
            0,
            empty ? 0 : 32,
          ),
        );

        animating = true;
        final entry = OverlayEntry(
          builder: (BuildContext context) {
            return TweenAnimationBuilder(
              tween: Tween<Offset>(begin: pos1, end: pos2),
              duration: duration,
              curve: Curves.easeOutQuad,
              builder: (_, Offset value, child) {
                return Positioned(
                  left: value.dx,
                  top: value.dy,
                  child: SizedBox(
                    child: ItemCard(
                      card: fromcard,
                      pd: false,
                      pg: false,
                    ),
                  ),
                );
              },
            );
          },
        );
        Overlay.of(ctx).insert(entry);
        await Future.delayed(duration);
        entry.remove();
        flyingCount--;
        animating = false;
        refreshCol(toList, [fromcard], true);
      },
    );
  } catch (e) {
    logger.e('animateShuffle error:', error: e);
  }
}

Future<void> animate(
  List<GameCard> fromArr,
  GameCard toCard,
  ValueNotifier<List<GameCard>> fromList,
  ValueNotifier<List<GameCard>> toList,
) async {
  try {
    bool empty = toList.value.isEmpty;
    GameCard fromcard = fromArr.first;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final box1 =
            fromArr.first.key.currentContext!.findRenderObject() as RenderBox;
        final pos1 = box1.localToGlobal(Offset.zero);
        final RenderBox box2;
        if (!empty) {
          box2 = toCard.key.currentContext!.findRenderObject() as RenderBox;
        } else {
          box2 = colKeys[currentCards.indexOf(toList)]
              .currentContext!
              .findRenderObject() as RenderBox;
        }

        if (fromList == currentCards[8]) {
          List<GameCard> l = currentCards[8].value.toList();
          l[fromList.value.indexOf(fromcard)] =
              GameCard(num: 0, sign: 0, highlight: true, key: GlobalKey());

          currentCards[8].value = l;
          refreshCol(fromList, [], false);
        } else {
          refreshCol(fromList, fromArr, false);
        }
        animating = true;
        flyingCount++;
        final entry = OverlayEntry(
          builder: (BuildContext context) {
            final p =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final w = MediaQuery.of(context).size.width;
            final h = MediaQuery.of(context).size.height;
            Offset pos2 =
                box2.localToGlobal(Offset(0, colHeight([1], p, w, h)));
            if (toList == currentCards[8] || toList == currentCards[9]) {
              pos2 = box2.localToGlobal(Offset.zero);
            } else if (empty) {
              pos2 = box2.localToGlobal(Offset.zero);
            }
            return TweenAnimationBuilder(
              tween: Tween<Offset>(begin: pos1, end: pos2),
              duration: duration,
              curve: Curves.easeOutCubic,
              builder: (context2, Offset value, child) {
                return Positioned(
                  left: value.dx,
                  top: value.dy,
                  child: SizedBox(
                    height: colHeight(fromArr, p, w, h),
                    width: p ? w / 8 : h / 8,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: fromArr.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index2) {
                        fromArr[index2].key = GlobalKey();
                        fromArr[index2].highlight =
                            index2 == fromArr.length - 1;
                        return ItemCard(
                          card: fromArr[index2],
                          pd: index2 != fromArr.length - 1,
                          pg: index2 != 0,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
        Overlay.of(ctx).insert(entry);
        await Future.delayed(duration);
        playSound();
        entry.remove();
        if (toList == currentCards[8] || toList == currentCards[9]) {
          List<GameCard> l = toList.value.toList();
          l[l.indexOf(toCard)] = fromArr.first;
          toList.value = l;
          refreshCol(toList, [], true);
        } else {
          refreshCol(toList, fromArr, true);
        }
        flyingCount--;
        if (toList != fromList) {
          doMove();
        }
        animating = false;
      },
    );
  } catch (e) {
    logger.e('animate error:', error: e);
  }
}

Future<void> animateHint(
  GameCard card,
  ValueNotifier<List<GameCard>> fromList,
) async {
  try {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        int index = fromList.value.indexOf(card);
        final box1 = card.key.currentContext!.findRenderObject() as RenderBox;
        final pos1 = box1.localToGlobal(Offset.zero);

        if (fromList == currentCards[8]) {
          List<GameCard> l = currentCards[8].value.toList();
          l[fromList.value.indexOf(card)] =
              GameCard(num: 0, sign: 0, highlight: true, key: GlobalKey());
          currentCards[8].value = l;
        } else {
          refreshCol(fromList, [card], false);
        }
        animating = true;
        final entry = OverlayEntry(
          builder: (BuildContext context) {
            final p =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final w = MediaQuery.of(context).size.width;
            final h = MediaQuery.of(context).size.height;
            Offset pos2 = box1.localToGlobal(Offset(0, (p ? w / 10 : h / 11)));

            return TweenAnimationBuilder(
              tween: Tween<Offset>(begin: pos1, end: pos2),
              duration: duration,
              curve: Curves.easeOutCubic,
              builder: (context2, Offset value, child) {
                return Positioned(
                  left: value.dx,
                  top: value.dy,
                  child: SizedBox(
                    height: colHeight([card], p, w, h),
                    width: p ? w / 8 : h / 8,
                    child: ItemCard(
                      card: card,
                      pd: false,
                      pg: false,
                    ),
                  ),
                );
              },
            );
          },
        );
        Overlay.of(ctx).insert(entry);
        await Future.delayed(duration);
        playSound();
        entry.remove();
        if (fromList == currentCards[8]) {
          List<GameCard> l = currentCards[8].value.toList();
          l[index] = card;
          fromList.value = l;
        } else {
          refreshCol(fromList, [card], true);
        }
        flyingCount--;
        animating = false;
      },
    );
  } catch (e) {
    logger.e('animateHint error:', error: e);
  }
}
