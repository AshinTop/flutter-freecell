import 'package:flutter/material.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/animation.dart';
import 'package:freecell/utils/game.dart';
import 'package:freecell/model/card.dart';

bool par(GameCard k1, GameCard k2) {
  int sign1 = 2;
  int sign2 = 3;
  if (k1.sign >= 2) {
    sign1 = 0;
    sign2 = 1;
  }
  return (k2.num == k1.num - 1) && (k2.sign == sign1 || k2.sign == sign2);
}

ValueNotifier<List<GameCard>> findList(
    GameCard card, ValueNotifier<List<GameCard>> fromList, bool isArr) {
  bool nijeArr = !isArr;
  for (var i = 0; i < 4; i++) {
    if (card.sign == currentCards[9].value[i].sign &&
        card.num == currentCards[9].value[i].num + 1 &&
        nijeArr) {
      return currentCards[9];
    }
  }
  for (var i = 0; i < 8; i++) {
    if (currentCards[i].value.isNotEmpty &&
        par(currentCards[i].value.last, card)) {
      return (currentCards[i]);
    }
  }
  for (var i = 0; i < 8; i++) {
    if (currentCards[i].value.isEmpty) {
      return (currentCards[i]);
    }
  }
  for (var i = 0; i < 4; i++) {
    if (currentCards[8].value[i].num == 0 && nijeArr) {
      return (currentCards[8]);
    }
  }
  return fromList;
}

Future tap(
  BuildContext context,
  ValueNotifier<List<GameCard>> fromList,
  List<GameCard> fromArr,
) async {
  GameCard fromKarta = fromArr.first;
  ValueNotifier<List<GameCard>> toList =
      findList(fromKarta, fromList, fromArr.length > 1);
  GameCard toKarta = toList.value.isEmpty
      ? GameCard(num: 0, sign: 0, key: GlobalKey(), highlight: true)
      : toList.value.last;
  if (fromList != currentCards[8] || toList != currentCards[8]) {
    if (toList == currentCards[9]) {
      for (var i = 0; i < 4; i++) {
        if ((fromKarta.sign == currentCards[9].value[i].sign) &&
            (fromKarta.num == currentCards[9].value[i].num + 1)) {
          toKarta = currentCards[9].value[i];
          break;
        }
      }
    } else if (toList == currentCards[8]) {
      for (var i = 0; i < 4; i++) {
        if (currentCards[8].value[i].num == 0) {
          toKarta = currentCards[8].value[i];
          break;
        }
      }
    }
    animate(fromArr, toKarta, fromList, toList);
  }
}

void hint(BuildContext context) {
  bool ima = false;
  for (var c = 0; c < 9; c++) {
    if (c == 8) {
      for (var i = 0; i < 4; i++) {
        if (currentCards[8].value[i].num != 0 &&
            findList(currentCards[8].value[i], currentCards[8], false) !=
                currentCards[8]) {
          animateHint(currentCards[8].value[i], currentCards[c]);
          //currentCards[8].value[i].hint = true;
          //currentCards[c].value = currentCards[c].value.toList();
          ima = true;
        }
      }
    } else {
      for (var i = 0; i < currentCards[c].value.length; i++) {
        List<GameCard> arr =
            array(currentCards[c].value[i], currentCards[c].value);
        bool m = arr.length <= freeSpace();
        if ((moze(currentCards[c].value[i], currentCards[c].value)) &&
            m &&
            (findList(currentCards[c].value[i], currentCards[c],
                    arr.length > 1) !=
                currentCards[c]) &&
            (findList(currentCards[c].value[i], currentCards[c],
                    arr.length > 1) !=
                currentCards[8])) {
          animate(arr, currentCards[c].value.last, currentCards[c],
              currentCards[c]);
          i = currentCards[c].value.length;
          //c++;
          ima = true;
        }
      }
    }
  }
  if (!ima) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('No hints'),
      duration: Duration(seconds: 1),
    ));
  }
}

bool moze(GameCard k1, List<GameCard> list) {
  List<GameCard> listArr = [k1];
  bool dalje = true;
  for (var i = list.indexOf(k1); i + 1 < list.length && dalje; i++) {
    if (par(list[i], list[i + 1])) {
      listArr.add(GameCard(
        num: list[i + 1].num,
        key: list[i + 1].key,
        sign: list[i + 1].sign,
        highlight: list[i + 1].highlight,
      ));
    } else {
      dalje = false;
    }
  }
  return listArr.last.highlight;
}

List<GameCard> array(GameCard k1, List<GameCard> list) {
  bool dalje = true;
  List<GameCard> listArr = [k1];
  for (var i = list.indexOf(k1); i + 1 < list.length && dalje; i++) {
    if (par(list[i], list[i + 1])) {
      listArr.add(GameCard(
        num: list[i + 1].num,
        sign: list[i + 1].sign,
        key: list[i + 1].key,
        highlight: list[i + 1].highlight,
      ));
    } else {
      dalje = false;
    }
  }
  return listArr;
}

bool end() {
  for (var i = 0; i < 8; i++) {
    if (i < currentCards.length) {
      if (!(currentCards[i].value.isEmpty ||
          moze(currentCards[i].value[0], currentCards[i].value))) {
        return false;
      }
    }
  }
  return true;
}
