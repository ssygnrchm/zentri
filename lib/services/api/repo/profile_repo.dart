import 'package:http/http.dart' as http;
import 'package:zentri/services/api/endpoint.dart';

Future<http.Response> getProfileAPI(String token) {
  return http.get(
    Uri.parse("${Endpoint.baseUrl}/api/profile"),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
  );
}

Future<http.Response> updateProfileAPI(String token, String nama) {
  return http.put(
    Uri.parse("${Endpoint.baseUrl}/api/profile"),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    body: ({"name": nama}),
  );
}
