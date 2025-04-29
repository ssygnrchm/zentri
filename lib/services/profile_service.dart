import 'package:http/http.dart' as http;
import 'package:zentri/api/endpoint.dart';
import 'package:zentri/services/pref_handler.dart';

class ProfileService {
  late PreferenceHandler _prefHandler;
  String? token;

  // Initialize with preference handler
  Future<void> initialize() async {
    _prefHandler = await PreferenceHandler.getInstance();
    token = _prefHandler.getToken();
  }

  Future<http.Response> getProfile() async {
    // Ensure token is initialized
    if (token == null) {
      await initialize();
    }

    final response = await http.get(
      Uri.parse('${Endpoint.baseUrlApi}/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token' ?? '',
      },
    );

    print(response.body);
    return response;
  }

  Future<http.Response> updateProfile(String name, String email) async {
    // Ensure token is initialized
    if (token == null) {
      await initialize();
    }

    final response = await http.put(
      Uri.parse('${Endpoint.baseUrlApi}/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token' ?? '',
      },
      body: {'name': name, 'email': email},
    );

    _prefHandler = await PreferenceHandler.getInstance();
    await _prefHandler.saveUser(
      id: _prefHandler.getId()!,
      name: name,
      email: email,
    );

    return response;
  }
}
