import 'package:flutter/material.dart';
import 'package:freecell/model/theme.dart';
import 'package:freecell/widgets/icons/icons.dart';

List<IconData> cardIcons = [
  SuitIcons.heart,
  SuitIcons.diamond,
  SuitIcons.spades,
  SuitIcons.clubs,
];

const String gameName = 'FreeCell';

const String supportEmail = '783767826@qq.com';

const String appFont = 'JetBrainsMono';

const int animationDuration = 320;

const String appVersion = '1.0.0';

Map<String, CardGameTheme> appThemes = {
  'whiteTheme': CardGameTheme(
      name: 'Light Theme',
      textColor: Colors.black,
      bgColor: Colors.white,
      isLight: true,
      icon: const Icon(Icons.light_mode)),
  'blackTheme': CardGameTheme(
      name: 'Dark Theme',
      textColor: Colors.grey.shade300,
      bgColor: Colors.black,
      isLight: false,
      icon: const Icon(Icons.dark_mode)),
  'classicTheme': CardGameTheme(
      name: 'Classic Theme',
      textColor: Colors.teal.shade900,
      bgColor: const Color(0xFF2b875a),
      isLight: true,
      icon: const Icon(SuitIcons.clubs)),
};

// Map<String, Color> backgroundColors = {
//   'whiteTheme': Colors.white,
//   'frogTheme': const Color(0xFFcbe2d4),
//   'greenTheme': const Color(0xFF2b875a),
//   'yellowTheme': const Color(0xFFd4be98),
//   'pinkTheme': const Color(0xFFFEDBD0),
//   'greyTheme': Colors.blueGrey,
//   'catTheme': const Color(0xFF282a36),
//   'darkTheme': const Color(0xFF121212),
//   'brownTheme': const Color(0xFF292828),
//   'purpleTheme': const Color(0xFF1d2733),
//   'anchorTheme': const Color(0xFF11150D),
//   'blackTheme': Colors.black,
// };

// Map<String, Color> textColors = {
//   'whiteTheme': Colors.black,
//   'frogTheme': const Color(0xFF374540),
//   'greenTheme': Colors.teal.shade900,
//   'yellowTheme': const Color(0xFF292828),
//   'pinkTheme': const Color(0xFF442C2E),
//   'greyTheme': Colors.blueGrey.shade900,
//   'catTheme': const Color(0xFFFEDBD0),
//   'darkTheme': const Color(0xFFcf6679),
//   'brownTheme': const Color(0xFFd4be98),
//   'purpleTheme': const Color(0xFF906fff),
//   'anchorTheme': const Color(0xFFcbe2d4),
//   'blackTheme': Colors.grey.shade300,
// };

Map defaultAppConfig = {
  'theme': 'whiteTheme',
  'currentTimes': 0,
  'currentMoves': 0,
  'coins': 0,
  'wins': 0,
  'minMoves': 0,
  'minTimes': 0,
  'firstBoot': true,
  'soundPref': true,
  'haptic': true,
  'timer': true,
};
