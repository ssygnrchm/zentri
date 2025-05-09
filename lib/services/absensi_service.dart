import 'package:http/http.dart' as http;
import 'package:zentri/api/endpoint.dart';
import 'package:zentri/services/pref_handler.dart';

class AbsensiService {
  late PreferenceHandler _prefHandler;
  String? token;

  // Initialize with preference handler
  Future<void> initialize() async {
    _prefHandler = await PreferenceHandler.getInstance();
    token = _prefHandler.getToken();
  }

  Future<http.Response> checkin(
    String checkinLat,
    String checkinLng,
    String checkinAddress,
    String status, [
    String? alasanIzin,
  ]) async {
    final Map<String, dynamic> body = {
      'check_in_lat': checkinLat,
      'check_in_lng': checkinLng,
      'check_in_address': checkinAddress,
      'status': status,
    };

    // Only add alasan_izin to body if it's not null
    if (alasanIzin != null) {
      body['alasan_izin'] = alasanIzin;
    }
    print('token in service: $token');
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/absen/check-in'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token!}',
      },
      body: body,
    );

    return response;
  }

  Future<http.Response> checkout(
    String checkoutLat,
    String checkoutLng,
    String checkoutLocation,
    String checkoutAddress,
  ) async {
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/absen/check-out'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token!}',
      },
      body: {
        'check_out_lat': checkoutLat,
        'check_out_lng': checkoutLng,
        'check_out_location': checkoutLocation,
        'check_out_address': checkoutAddress,
      },
    );

    return response;
  }

  // New method to get attendance history
  Future<http.Response> getHistory(String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse(
        '${Endpoint.baseUrlApi}/absen/history?start=$startDate&end=$endDate',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token!}',
      },
    );

    return response;
  }

  // New method to get attendance history
  Future<http.Response> deleteAbsen(id) async {
    final response = await http.delete(
      Uri.parse('${Endpoint.baseUrlApi}/absen/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token!}',
      },
    );

    return response;
  }
}
