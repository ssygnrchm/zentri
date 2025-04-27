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
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/absen/check-in'),
      headers: {'Accept': 'application/json', 'Authorization': token ?? ''},
      body: {
        'check_in_lat': checkinLat,
        'check_in_lng': checkinLng,
        'check_in_address': checkinAddress,
        'status': status,
        'alasan_izin': alasanIzin,
      },
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
      headers: {'Accept': 'application/json', 'Authorization': token ?? ''},
      body: {
        'check_out_lat': checkoutLat,
        'check_out_lng': checkoutLng,
        'check_out_location': checkoutLocation,
        'check_out_address': checkoutAddress,
      },
    );

    return response;
  }
}
