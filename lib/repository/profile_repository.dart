import 'dart:convert';
import 'package:zentri/auth/model/login_model.dart';
import 'package:zentri/presentation/home_screen.dart';
import 'package:zentri/services/profile_service.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();

  Future<LoginResponse> getUserProfile() async {
    try {
      final response = await _service.getProfile();
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(responseData);
      } else {
        return LoginResponse(
          message: responseData['message'] ?? 'Failed to get profile',
          data: null,
        );
      }
    } catch (e) {
      return LoginResponse(message: 'Error: ${e.toString()}', data: null);
    }
  }

  Future<UpdateProfileResponse> updateUserProfile(
    String name,
    String email,
  ) async {
    try {
      final response = await _service.updateProfile(name, email);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UpdateProfileResponse.fromJson(responseData);
      } else {
        return UpdateProfileResponse(
          message: responseData['message'] ?? 'Failed to update profile',
          success: false,
        );
      }
    } catch (e) {
      return UpdateProfileResponse(
        message: 'Error: ${e.toString()}',
        success: false,
      );
    }
  }
}

class UpdateProfileResponse {
  final String message;
  final bool success;

  UpdateProfileResponse({required this.message, required this.success});

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
