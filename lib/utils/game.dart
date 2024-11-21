import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecell/config/app.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/animation.dart';
import 'package:freecell/model/card.dart';
import 'package:freecell/utils/logger.dart';
import 'package:freecell/utils/prefs.dart';
import 'package:freecell/utils/sound.dart';
import 'package:url_launcher/url_launcher.dart';

bool gameOver = false;

Future initApp() async {
  try {
    await initPrefs();
    startGameFromPref();
    initAppConfigs();
    initSound();
  } catch (e) {
    logger.e('initApp error:', error: e);
  }
}

startGameFromPref() async {
  try {
    if (!hasSavedGame()) {
      return;
    }
    moves.value = getPrefs('moves', 0) ?? 0;
    for (var col = 0; col < 10; col++) {
      List<String> column = [];
      column = getPrefs('col$col', column) ?? [];
      for (var move = 0; move < column.length; move++) {
        allMoves.add([]);
        allMoves[move].add(ValueNotifier([]));
        for (var i = 0; i < column[move].length / 3; i++) {
          allMoves[move][col].value.add(
                GameCard(
                  num: int.parse(column[move][i * 3]) * 10 +
                      int.parse(column[move][(i * 3) + 1]),
                  sign: int.parse(column[move][(i * 3) + 2]),
                  key: GlobalKey(),
                  highlight: false,
                ),
              );
        }
      }
    }
    currentCards = allMoves[moves.value].toList();
    gameTimes =
        DateTime.now().subtract(Duration(seconds: getPrefs('time', 0) ?? 0));
    backup();
  } catch (e) {
    logger.e('startGameFromPref error:', error: e);
  }
}

saveGameInfoToPref() {
  try {
    for (var col = 0; col < 10; col++) {
      List<String> cols = [];
      for (var move = 0; move < allMoves.length; move++) {
        cols.add('');
        if (allMoves[move].length <= col) {
          break;
        }
        for (var i = 0; i < allMoves[move][col].value.length; i++) {
          GameCard card = allMoves[move][col].value[i];
          if (card.num < 10) {
            cols[move] += ('0${card.num}${card.sign}');
          } else {
            cols[move] += ('${card.num}${card.sign}');
          }
        }
      }
      savePrefs('col$col', cols);
    }

    savePrefs('moves', moves.value);
    DateTime timer = DateTime.now().subtract(Duration(
        hours: gameTimes.hour,
        minutes: gameTimes.minute,
        seconds: gameTimes.second));
    savePrefs('time', timer.hour + timer.minute * 60 + timer.second);
  } catch (e) {
    logger.e('saveGameInfoToPref error:', error: e);
  }
}

initAppConfigs() {
  try {
    for (var i = 0; i < appConfigs.length; i++) {
      String key = appConfigs.keys.elementAt(i);
      if (key == 'firstBoot') {
        setConfigsAndSavePrefs(key, false);
      } else {
        final value = getPrefs(key, appConfigs[key]) ?? appConfigs[key];
        setConfigsAndSavePrefs(key, value);
      }
    }
    logger.d(appConfigs);
  } catch (e) {
    logger.e('initAppConfigs error:', error: e);
  }
}

List<GameCard> createAllCards() {
  try {
    List<GameCard> allCards = [];
    List<GameCard> ls = [], ld = [];
    for (var i = 0; i < 4; i++) {
      ls.add(GameCard(num: 0, sign: 0, highlight: true, key: GlobalKey()));
      ld.add(GameCard(num: 0, sign: i, highlight: true, key: GlobalKey()));
    }
    currentCards[8].value = ls;
    currentCards[9].value = ld;
    for (var i = 0; i < 8; i++) {
      currentCards[i].value = [];
    }

    gameTimes = DateTime.now();
    for (var n = 13; n > 0; n--) {
      for (var s = 0; s < 4; s++) {
        allCards
            .add(GameCard(num: n, sign: s, highlight: true, key: GlobalKey()));
      }
    }
    allCards.shuffle();
    return allCards;
  } catch (e) {
    logger.e('initAppConfigs error:', error: e);
    return [];
  }
}

Future shuffleCards() async {
  try {
    shuffling.value = true;
    endScreen.value = false;
    moves.value = 0;
    gameOver = false;
    allMoves.clear();
    List<GameCard> allCards = createAllCards();
    if (appConfigs['firstBoot']) {
      for (int i = 0; i < allCards.length; i++) {
        currentCards[i % 8].value.add(allCards[i]);
      }
    } else {
      int i = 0;
      duration = const Duration(milliseconds: 256);
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 24));
        if (i % 4 == 0 && appConfigs['haptic']) HapticFeedback.selectionClick();
        animateShuffle(
            allCards[i], currentCards[(((i ~/ 8) % 2) * 7 - i % 8).abs()]);
        i++;
        return i < allCards.length;
      });
    }
    await Future.delayed(const Duration(milliseconds: 512));
    gameTimes = DateTime.now();
    duration = const Duration(milliseconds: animationDuration);
    appConfigs['firstBoot'] = false;
    backup();
    saveGameInfoToPref();
  } catch (e) {
    logger.e('shuffleCards error:', error: e);
  } finally {
    shuffling.value = false;
  }
}

bool isCardsEmpty() {
  try {
    for (var i = 0; i < 4; i++) {
      if (currentCards[9].value[i].num != 13) {
        return false;
      }
    }
    return true;
  } catch (e) {
    logger.e('isCardsEmpty error:', error: e);
    return false;
  }
}

doGameOverActions() {
  try {
    appConfigs['currentMoves'] = moves.value;
    if (appConfigs['minMoves'] > 0) {
      appConfigs['minMoves'] = min(appConfigs['minMoves'] as int, moves.value);
    } else {
      appConfigs['minMoves'] = moves.value;
    }
    savePrefs('minMoves', appConfigs['minMoves']);

    DateTime timer = DateTime.now().subtract(Duration(
        hours: gameTimes.hour,
        minutes: gameTimes.minute,
        seconds: gameTimes.second));
    int clock = timer.hour * 360 + timer.minute * 60 + timer.second;
    appConfigs['currentTimes'] = clock;
    if (appConfigs['minTimes'] > 0) {
      appConfigs['minTimes'] = min(appConfigs['minTimes'] as int, clock);
    } else {
      appConfigs['minTimes'] = clock;
    }
    savePrefs('minTimes', appConfigs['minTimes']);
    setConfigsAndSavePrefs('coins', appConfigs['coins'] + 20);
    setConfigsAndSavePrefs('wins', ++appConfigs['wins']);
    gameOver = true;
  } catch (e) {
    logger.e('doGameOverActions error:', error: e);
  }
}

bool isGameEnd() {
  bool isEmpty = isCardsEmpty();
  if (isEmpty && !gameOver) {
    doGameOverActions();
  }
  return isEmpty;
}

refreshCol(ValueNotifier<List<GameCard>> col, List<GameCard> arr, bool add) {
  if (appConfigs['haptic'] && !shuffling.value) {
    for (var i = 0; i < 12; i++) {
      HapticFeedback.heavyImpact();
    }
  }
  if (add) {
    for (var i = 0; i < arr.length; i++) {
      List<GameCard> l = col.value.toList();
      l.add(arr[i]);
      col.value = l;
    }
  } else {
    for (var i = 0; i < arr.length; i++) {
      List<GameCard> l = col.value.toList();
      l.removeLast();
      col.value = l;
    }
  }
}

double colHeight(List col, p, w, h) {
  return ((col.length - 1) * ((p ? (w / 13) : h / 15)) +
          (p ? (w / 5) : h / 5.5))
      .toDouble();
}

void doRestart() {
  try {
    moves.value = 0;
    for (var i = 0; i < allMoves[moves.value].length; i++) {
      currentCards[i].value = allMoves[moves.value][i].value;
    }
    gameTimes = DateTime.now();
    backup();
  } catch (e) {
    logger.e('restart error:', error: e);
  }
}

void doUndo() {
  try {
    if (moves.value != 0) {
      moves.value--;
      for (var i = 0; i < allMoves[moves.value].length; i++) {
        currentCards[i].value = allMoves[moves.value][i].value.toList();
      }
      backup();
    }
  } catch (e) {
    logger.e('restart error:', error: e);
  }
}

void doMove() {
  try {
    moves.value++;
    endScreen.value = isGameEnd();
    backup();
    saveGameInfoToPref();
  } catch (e) {
    logger.e('doMove error:', error: e);
  }
}

int freeSpace() {
  int fs = 1;
  for (var i = 0; i < 4; i++) {
    if (currentCards[8].value[i].num == 0) fs++;
  }
  for (var i = 0; i < 8; i++) {
    if (currentCards[i].value.isEmpty) fs *= 2;
  }
  return fs;
}

backup() {
  List<ValueNotifier<List<GameCard>>> deck2 = [];
  for (var i = 0; i < 10; i++) {
    deck2.add(ValueNotifier([]));
  }
  for (var i = 0; i < 10; i++) {
    for (var q = 0; q < currentCards[i].value.length; q++) {
      deck2[i].value.add(currentCards[i].value.toList()[q]);
    }
  }
  allMoves.insert(moves.value, deck2.toList());
}

Color getDarkTextColor() {
  final theme = appThemes[appConfigs['theme']];
  if (theme == null) {
    return Colors.black;
  }
  return theme.isLight ? theme.bgColor : theme.textColor;
}

Future autoSolve() async {
  try {
    duration = const Duration(milliseconds: 256);
    shuffling.value = true;
    while (!isGameEnd()) {
      for (int c = 0; c < 8; c++) {
        if (currentCards[c].value.isNotEmpty) {
          GameCard last = currentCards[c].value.last;
          if (last.num == currentCards[9].value[last.sign].num + 1) {
            await animateSolve(currentCards[c], 9);
          }
        }
      }
      for (int c = 0; c < 4; c++) {
        GameCard card = currentCards[8].value[c];
        if (card.num == currentCards[9].value[card.sign].num + 1) {
          await animateSolve(currentCards[8], c);
        }
      }
    }
  } catch (e) {
    logger.e('autoSolve error:', error: e);
  } finally {
    duration = const Duration(milliseconds: animationDuration);
    shuffling.value = false;
  }
}

void openSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: SelectableText(text),
  );

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> openEmailApp(BuildContext context) async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: supportEmail,
  );
  try {
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      openSnackBar(context, 'Send email to $supportEmail');
    }
  } catch (e) {
    openSnackBar(context, 'Send email to $supportEmail');
  }
}

Future<void> openUrl(str) async {
  try {
    final Uri url = Uri.parse(str); // URL 链接

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      logger.e('Could not launch: $str');
    }
  } catch (e) {
    logger.e('Could not launch: $str', error: e);
  }
}
