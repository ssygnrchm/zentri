import 'package:http/http.dart' as http;
import 'package:zentri/services/api/endpoint.dart';

Future<http.Response> checkInUserAPI(
  double lat,
  double long,
  String address,
  String token,
) {
  return http.post(
    Uri.parse("${Endpoint.baseUrl}/api/absen/check-in"),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    body: ({
      "check_in_lat": "$lat",
      "check_in_lng": "$long",
      "check_in_address": address,
      "status": "masuk",
    }),
  );
}

Future<http.Response> checkOutUserAPI(
  double lat,
  double long,
  String location,
  String address,
  String token,
) {
  return http.post(
    Uri.parse("${Endpoint.baseUrl}/api/absen/check-out"),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    body: ({
      "check_out_lat": "$lat",
      "check_out_lng": "$long",
      "check_out_location": location,
      "check_out_address": address,
    }),
  );
}

Future<http.Response> checkInIzinUserAPI(
  double lat,
  double long,
  String address,
  String token,
  String alasan_izin,
) {
  return http.post(
    Uri.parse("${Endpoint.baseUrl}/api/absen/check-in"),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
    body: ({
      "check_in_lat": "$lat",
      "check_in_lng": "$long",
      "check_in_address": address,
      "status": "izin",
      "alasan_izin": alasan_izin,
    }),
  );
}

Future<http.Response> getAbsensiAPI(String token) {
  return http.get(
    Uri.parse("${Endpoint.baseUrl}/api/absen/history"),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
  );
}

Future<http.Response> getAbsensiFilteredAPI(
  String token,
  String tgl_start,
  String tgl_end,
) {
  return http.get(
    Uri.parse(
      "${Endpoint.baseUrl}/api/absen/history?start=$tgl_start&end=$tgl_end",
    ),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
  );
}

Future<http.Response> deleteAbsenAPI(String token, int id) {
  return http.delete(
    Uri.parse("${Endpoint.baseUrl}/api/absen/$id"),
    headers: {'Accept': 'application/json', 'Authorization': "Bearer $token"},
  );
}
