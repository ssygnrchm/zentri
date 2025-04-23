import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  // Keys
  static const String _keyToken = 'user_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyLookWelcoming = 'lookWelcoming';

  /// Save all user data
  static Future<void> saveUserData({
    required String token,
    required int id,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyUserId, id);
    await prefs.setString(_keyUserName, name);
    print('name in saveuser prefs: $_keyUserName');
    await prefs.setString(_keyUserEmail, email);
  }

  /// Save token only
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  /// Getters
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    print('name in getuser prefs: $_keyUserName');
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<bool> getLookWelcoming() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLookWelcoming) ?? false;
  }

  static Future<void> saveLookWelcoming(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLookWelcoming, value);
  }

  /// Remove specific data
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  static Future<void> removeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  /// Clear all data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
