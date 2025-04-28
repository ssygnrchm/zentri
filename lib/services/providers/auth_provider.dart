import 'package:flutter/widgets.dart';
import 'package:zentri/services/api/crud/auth/auth_services.dart';
import 'package:zentri/services/shared_preferences/prefs_handler.dart';
import 'package:zentri/utils/widgets/dialog.dart';
import 'package:zentri/utils/widgets/snackbar.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic> _responseReg = {};

  bool get isLoading => _isLoading;
  Map<String, dynamic> get responseReg => _responseReg;

  Map<String, dynamic> _responseLog = {};
  Map<String, dynamic> get responseLog => _responseLog;

  Future<void> registerUser(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _responseReg = await AuthServices().register(name, email, password);

      if (_responseReg["success"] == true) {
        showSnackBar(context, _responseReg['data']['message']);
        CustomDialog().hide(context);
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        CustomDialog().hide(context);
        showSnackBar(context, _responseReg['message']);
      }
    } catch (e) {
      print("error saat register: $e");
      CustomDialog().hide(context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _responseLog = await AuthServices().login(email, password);

      if (_responseLog["success"] == true) {
        PrefsHandler.saveToken(_responseLog['data']['data']['token']);
        showSnackBar(context, _responseLog['data']['message']);
        CustomDialog().hide(context);
        Navigator.pushReplacementNamed(context, "/main");
      } else {
        CustomDialog().hide(context);
        showSnackBar(context, _responseLog['message']);
      }
    } catch (e) {
      print("error saat login: $e");
      CustomDialog().hide(context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
