import 'package:flutter/material.dart';

class GameCard {
  int sign, num;
  bool highlight, hint;
  GlobalKey key;

  GameCard({
    required this.num,
    required this.sign,
    required this.key,
    required this.highlight,
    this.hint = false,
  });
}
