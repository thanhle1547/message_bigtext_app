import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences prefs;
  static const String KEY_FONT_SIZE_FACTOR = 'fontSizeFactor';
  static const String KEY_PINNED_PHONE_NUMBER = 'pinnedPhoneNumber';

  static init() async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(KEY_FONT_SIZE_FACTOR, 1);
    await prefs.setStringList(KEY_PINNED_PHONE_NUMBER, []);
    await prefs.commit();
  }

  static Future<double> getFontSizeFactor() async {
    return prefs.getDouble(KEY_FONT_SIZE_FACTOR);
  }

  static Future<void> setFontSizeFactor(double value) async {
    await prefs.setDouble(KEY_FONT_SIZE_FACTOR, value);
    await prefs.commit();
  }

  static Future<List<String>> getPinnedPhoneNumber() async {
    return prefs.getStringList(KEY_PINNED_PHONE_NUMBER);
  }

  static Future<void> setPinnedPhoneNumber(List<String> value) async {
    await prefs.setStringList(KEY_PINNED_PHONE_NUMBER, value);
    await prefs.commit();
  }
}
