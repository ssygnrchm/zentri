import 'package:http/http.dart' as http;
import 'package:zentri/services/api/endpoint.dart';

Future<http.Response> registerUserAPI(
  String name,
  String email,
  String password,
) {
  return http.post(
    Uri.parse("${Endpoint.baseUrl}/api/register"),
    headers: {'Accept': 'application/json'},
    body: ({'name': name, 'email': email, 'password': password}),
  );
}

Future<http.Response> loginUserAPI(String email, String password) {
  return http.post(
    Uri.parse("${Endpoint.baseUrl}/api/login"),
    headers: {'Accept': 'application/json'},
    body: ({'email': email, 'password': password}),
  );
}
