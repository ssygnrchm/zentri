import 'package:http/http.dart' as http;
import 'package:zentri/api/endpoint.dart';
import 'package:zentri/services/pref_handler.dart';

class AuthService {
  late PreferenceHandler _prefHandler;
  String? token;

  // Initialize with preference handler
  Future<void> initialize() async {
    _prefHandler = await PreferenceHandler.getInstance();
    token = _prefHandler.getToken();
  }

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
    // Ensure token is initialized
    if (token == null) {
      await initialize();
    }

    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/profile'),
      headers: {'Accept': 'application/json', 'Authorization': token ?? ''},
      body: {},
    );

    return response;
  }
}
