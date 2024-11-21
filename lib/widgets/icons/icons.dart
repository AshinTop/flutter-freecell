import 'package:flutter/widgets.dart';

class SuitIcons {
  SuitIcons._();

  static const _kFontFam = 'Suits';
  static const String? _kFontPkg = null;

  static const IconData spades =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clubs =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData diamond =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData heart =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
