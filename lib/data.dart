import 'package:flutter/material.dart';
import 'package:freecell/config/app.dart';
import 'package:freecell/model/card.dart';

Map appConfigs = Map.from(defaultAppConfig);
Duration duration = const Duration(milliseconds: animationDuration);
List<List<ValueNotifier<List<GameCard>>>> allMoves = [];
DateTime gameTimes = DateTime.now();

List<GlobalKey> colKeys = [
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey()
];
List<ValueNotifier<List<GameCard>>> currentCards = [
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
  ValueNotifier([]),
];

final ValueNotifier<int> moves = ValueNotifier(0);
final ValueNotifier<bool> shuffling = ValueNotifier(false);
final ValueNotifier<bool> endScreen = ValueNotifier(false);
final ValueNotifier<bool> theme = ValueNotifier(false);

late BuildContext ctx;
bool animating = false;
bool toolbar = true;

List<GlobalKey> keys = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];
