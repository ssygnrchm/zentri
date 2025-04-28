import 'dart:convert';

import 'package:zentri/services/api/repo/auth_repo.dart';

class AuthServices {
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    // dapatkan response dari API
    final response = await registerUserAPI(name, email, password);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': json};
    } else {
      return {
        'success': false,
        'message': json['message'] ?? 'Terjadi kesalahan saat register',
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    // dapatkan response dari API
    final response = await loginUserAPI(email, password);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': json};
    } else {
      return {
        'success': false,
        'message': json['message'] ?? 'Terjadi kesalahan saat login',
      };
    }
  }
}
