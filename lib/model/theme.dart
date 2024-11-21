import 'package:flutter/material.dart';

class CardGameTheme {
  Color textColor, bgColor;
  String name;
  bool isLight;
  Icon icon;

  CardGameTheme(
      {required this.name,
      required this.textColor,
      required this.bgColor,
      required this.isLight,
      required this.icon});
}
