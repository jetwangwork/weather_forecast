import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._internal();

  static const String cwaApiKey = "cwaApiKey";
}

class SharedPref {
  SharedPref._internal(); // 私有建構函數，確保無法直接實例化

  static final SharedPref _instance = SharedPref._internal();
  SharedPreferences? _prefs;

  factory SharedPref() {
    return _instance;
  }

  // 需要初始化
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 儲存數據
  Future<void> setValue(String key, Object value) async {
    if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key, value);
    } else {
      throw UnsupportedError("Type not supported");
    }
  }

  // 讀取數據
  Object getValue(String key, Object defaultValue) {
    // 由於 SharedPreferences 不支援動態類型的 getter，
    // 所以需要嘗試取得不同類型的數據
    if (_prefs != null && _prefs!.containsKey(key)) {
      if (_prefs?.get(key) is bool) return _prefs?.getBool(key) ?? defaultValue;
      if (_prefs?.get(key) is int) return _prefs?.getInt(key) ?? defaultValue;
      if (_prefs?.get(key) is double) return _prefs?.getDouble(key) ?? defaultValue;
      if (_prefs?.get(key) is String) return _prefs?.getString(key) ?? defaultValue;
      if (_prefs?.get(key) is List<String>) return _prefs?.getStringList(key) ?? defaultValue;
    }
    return defaultValue;
  }

  // 移除指定鍵的數據
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  // 清除所有數據
  Future<void> clear() async {
    await _prefs?.clear();
  }
}