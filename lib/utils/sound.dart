import 'dart:math';

import 'package:flutter/services.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/logger.dart';
import 'package:soundpool/soundpool.dart';

List<String> winSoundList = [
  'assets/winSounds/001.mp3',
  'assets/winSounds/002.mp3',
  'assets/winSounds/003.mp3',
  'assets/winSounds/004.mp3',
  'assets/winSounds/005.mp3',
  'assets/winSounds/006.mp3',
];

late Soundpool soundPool;
late int soundId;
Map<int, int> winSoundIds = {};

Future<void> initSound() async {
  try {
    soundPool = Soundpool.fromOptions();
    //click sound
    ByteData soundData = await rootBundle.load('assets/flick.mp3');
    soundId = await soundPool.load(soundData);
    //win sound
    for (var i = 0; i < winSoundList.length; i++) {
      rootBundle.load(winSoundList[i]).then((ByteData sData) async {
        int sId = await soundPool.load(sData);
        winSoundIds[i] = sId;
      });
    }
  } catch (e) {
    logger.e('initSound error:', error: e);
  }
}

playSound() {
  try {
    if (appConfigs['soundPref']) {
      soundPool.play(soundId);
    }
  } catch (e) {
    logger.e('playSound error:', error: e);
  }
}

Future playEndSound() async {
  try {
    if (appConfigs['soundPref']) {
      Random random = Random();
      int winInt = random.nextInt(winSoundList.length);
      if (winSoundIds[winInt] != null) {
        await soundPool.play(winSoundIds[winInt]!);
      }
    }
  } catch (e) {
    logger.e('playEndSound error:', error: e);
  }
}
