import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  // Singleton instance
  static PreferenceHandler? _instance;
  late SharedPreferences _prefs;

  // Keys
  static const String _keyId = 'idUser';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyToken = 'token';
  static const String _keyLookWelcoming = 'lookWelcoming';

  // Private constructor
  PreferenceHandler._();

  // Factory constructor to get instance
  static Future<PreferenceHandler> getInstance() async {
    if (_instance == null) {
      _instance = PreferenceHandler._();
      await _instance!._init();
    }
    return _instance!;
  }

  // Initialize SharedPreferences
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save User Info
  Future<void> saveUser({
    required int id,
    required String name,
    required String email,
  }) async {
    await _prefs.setInt(_keyId, id);
    await _prefs.setString(_keyName, name);
    await _prefs.setString(_keyEmail, email);
  }

  /// Save Token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  /// Save Look Welcoming
  Future<void> saveLookWelcoming(bool look) async {
    await _prefs.setBool(_keyLookWelcoming, look);
  }

  /// Getters
  String? getToken() {
    return _prefs.getString(_keyToken);
  }

  int? getId() {
    return _prefs.getInt(_keyId);
  }

  String? getName() {
    return _prefs.getString(_keyName);
  }

  String? getEmail() {
    return _prefs.getString(_keyEmail);
  }

  bool getLookWelcoming() {
    return _prefs.getBool(_keyLookWelcoming) ?? false;
  }

  /// Remove Functions
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  Future<void> removeToken() async {
    await _prefs.remove(_keyToken);
  }

  Future<void> removeUser() async {
    await _prefs.remove(_keyId);
    await _prefs.remove(_keyName);
    await _prefs.remove(_keyEmail);
  }
}
