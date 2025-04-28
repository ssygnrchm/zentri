import 'dart:convert';

import 'package:zentri/models/user_model.dart';
import 'package:zentri/services/api/repo/profile_repo.dart';

class ProfileServices {
  Future<UserModel> getProfile(String token) async {
    // dapatkan response dari API
    final response = await getProfileAPI(token);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(json as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load Profile');
    }
  }

  Future<String> updateProfile(String token, String nama) async {
    final response = await updateProfileAPI(token, nama);
    final json = jsonDecode(response.body);

    return json["message"] ?? "default message update profile";
  }
}
