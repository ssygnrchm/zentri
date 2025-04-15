import 'package:http/http.dart' as http;
import 'package:zentri/api/endpoint.dart';

class AuthService {
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    return response;
  }
}
