import 'package:shared_preferences/shared_preferences.dart';

class PrefsHandler {
  static const String _token = "token";

  static void saveToken(String token){
    SharedPreferences.getInstance().then((value) {
      value.setString(_token, token);
    });
  }
  static Future getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_token) ?? "";
    return token;
  }

  static void removeToken(){
    SharedPreferences.getInstance().then((value) {
      value.remove(_token);
    });
  }
}