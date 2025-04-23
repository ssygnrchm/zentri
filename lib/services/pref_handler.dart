import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  // Keys
  static const String _keyId = 'idUser';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyToken = 'token';
  static const String _keyLookWelcoming = 'lookWelcoming';

  /// Save User Info
  static Future<void> saveUser({
    required int id,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyId, id);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
  }

  /// Save Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  /// Save Look Welcoming
  static Future<void> saveLookWelcoming(bool look) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLookWelcoming, look);
  }

  /// Getters
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<int?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyId);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<bool> getLookWelcoming() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLookWelcoming) ?? false;
  }

  /// Remove Functions
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
  }
}
