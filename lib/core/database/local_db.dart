import 'package:shared_preferences/shared_preferences.dart';

mixin CacheManeger {
  static Future<void> saveList(String key, List<String> list) async {
    // listeyi kaydet
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key.toString(), list);
    print("kaydedildi => $list");
  }

  static Future getList(String key) async {
    // listeyi getir
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(key);
  }

  static Future remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }
}

enum SharedPreferencesKey { TOKEN }
