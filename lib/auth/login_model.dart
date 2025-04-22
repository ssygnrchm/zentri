import 'package:zentri/auth/user_model.dart';

class LoginResponse {
  final String message;

  final LoginData? data;

  LoginResponse({required this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],

      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final String token;

  final UserModel user;

  LoginData({required this.token, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'],

      user: UserModel.fromJson(json['user']),
    );
  }
}
