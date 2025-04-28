import 'package:flutter/material.dart';
import 'package:zentri/models/user_model.dart';
import 'package:zentri/services/api/crud/profile/profile_services.dart';
import 'package:zentri/services/shared_preferences/prefs_handler.dart';
import 'package:zentri/utils/widgets/dialog.dart';

class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Data _dataProfile = new Data();
  Data get dataProfile => _dataProfile;

  Future<void> getdataProfile() async {
    _isLoading = true;
    notifyListeners();
    String token = await PrefsHandler.getToken();
    try {
      UserModel dataP = await ProfileServices().getProfile(token);
      _dataProfile = dataP.data!;
    } catch (e) {
      throw Exception("Failed to load data profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfileUser(
    BuildContext context, {
    required String nama,
  }) async {
    String token = await PrefsHandler.getToken();

    try {
      String resultMsg = await ProfileServices().updateProfile(token, nama);
      getdataProfile();
      CustomDialog().hide(context); // hide loading
      CustomDialog().hide(context); // hide edit nama dialog
      CustomDialog().hide(context); // hide profile sheet
      CustomDialog().message(context, pesan: resultMsg);
    } catch (e) {
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: "error saat delete: $e");
    }
  }
}
