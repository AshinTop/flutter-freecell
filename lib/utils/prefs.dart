import 'package:freecell/config/app.dart';
import 'package:freecell/data.dart';
import 'package:freecell/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

Future<void> initPrefs() async {
  SharedPreferences.setMockInitialValues({});
  prefs = await SharedPreferences.getInstance();
}

String getKeyName(String key) {
  return ('${gameName}_$key').toUpperCase();
}

savePrefs(key, value) {
  try {
    if (value is int) {
      prefs.setInt(getKeyName(key), value);
    } else if (value is bool) {
      prefs.setBool(getKeyName(key), value);
    } else if (value is String) {
      prefs.setString(getKeyName(key), value);
    } else if (value is List<String>) {
      prefs.setStringList(getKeyName(key), value);
    }
  } catch (e) {
    logger.e('savePrefs error:', error: e);
  }
}

getPrefs(key, value) {
  try {
    if (value is int) {
      return prefs.getInt(getKeyName(key));
    } else if (value is bool) {
      return prefs.getBool(getKeyName(key));
    } else if (value is String) {
      return prefs.getString(getKeyName(key));
    } else if (value is List<String>) {
      return prefs.getStringList(getKeyName(key));
    }
    return value;
  } catch (e) {
    logger.e('getPrefs error:', error: e);
    return value;
  }
}

setConfigsAndSavePrefs(key, value) {
  try {
    appConfigs[key] = value;
    savePrefs(key, value);
    theme.value = !theme.value;
  } catch (e) {
    logger.e('setConfigsAndSavePrefs error:', error: e);
  }
}

bool hasSavedGame() {
  return prefs.getStringList('col0') != null &&
      prefs.getInt('moves') != null &&
      prefs.getInt('moves')! >= 0;
}
