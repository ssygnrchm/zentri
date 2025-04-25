import 'package:http/http.dart' as http;
import 'package:zentri/api/endpoint.dart';

class AbsensiService {
  String? token;

  Future<http.Response> checkin(
    String checkinLat,
    String checkinLng,
    String checkinAddress,
    String status,
  ) async {
    final response = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/absen/check-in'),
      headers: {'Accept': 'application/json'},
      // body: {'email': email, 'password': password},
    );
  }
}
