import 'dart:convert';

import 'package:zentri/auth/login_model.dart';
import 'package:zentri/auth/register_model.dart';
import 'package:zentri/services/auth_services.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<LoginResponse> login(String email, String password) async {
    final response = await _service.login(email, password);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(responseData);
    } else {
      return LoginResponse(message: responseData['message'], data: null);
    }
  }

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _service.register(name, email, password);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterResponse.fromJson(responseData);
    } else {
      return RegisterResponse(
        message: responseData['message'] ?? 'Registration failed',
        success: false,
      );
    }
  }

  Future<LoginResponse> getUser() async {
    final response = await _service.getUser();
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(responseData);
    } else {
      return LoginResponse(message: responseData['message'], data: null);
    }
  }
}
