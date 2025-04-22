import 'package:zentri/auth/user_model.dart';

class RegisterResponse {
  final String message;
  final bool success;
  final UserModel? data;

  RegisterResponse({required this.message, this.success = true, this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? true,
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
    );
  }
}
