import 'package:http/http.dart' as http;
import 'package:zentri/api/endpoint.dart';
import 'package:zentri/services/pref_handler.dart';

class AuthService {
  String token = PreferenceHandler.getToken().toString();

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    return response;
  }

  Future<http.Response> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/register'),
      headers: {'Accept': 'application/json'},
      body: {'name': name, 'email': email, 'password': password},
    );

    return response;
  }

  Future<http.Response> getUser() async {
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/profile'),
      headers: {'Accept': 'application/json', 'Authorization': token},
      body: {},
    );

    return response;
  }
}
