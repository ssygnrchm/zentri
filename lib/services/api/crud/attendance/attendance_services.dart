import 'dart:convert';

import 'package:zentri/models/absen_model.dart';
import 'package:zentri/services/api/repo/attendance_repo.dart';

class AttendanceServices {
  Future<Map<String, dynamic>> checkIn(
    double lat,
    double long,
    String address,
    String token,
  ) async {
    // dapatkan response dari API
    final response = await checkInUserAPI(lat, long, address, token);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': json};
    } else {
      return {
        'success': false,
        'message': json['message'] ?? 'Terjadi kesalahan saat check in',
      };
    }
  }

  Future<Map<String, dynamic>> checkOut(
    double lat,
    double long,
    String location,
    String address,
    String token,
  ) async {
    // dapatkan response dari API
    final response = await checkOutUserAPI(lat, long, location, address, token);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': json};
    } else {
      return {
        'success': false,
        'message': json['message'] ?? 'Terjadi kesalahan saat check out',
      };
    }
  }

  Future<Map<String, dynamic>> checkInIzin(
    double lat,
    double long,
    String address,
    String token,
    String alasan_izin,
  ) async {
    // dapatkan response dari API
    final response = await checkInIzinUserAPI(
      lat,
      long,
      address,
      token,
      alasan_izin,
    );
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': json};
    } else {
      return {
        'success': false,
        'message': json['message'] ?? 'Terjadi kesalahan saat izin',
      };
    }
  }

  Future<AbsenModel> getAbsensi(String token) async {
    // dapatkan response dari API
    final response = await getAbsensiAPI(token);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AbsenModel.fromJson(json as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load absensi');
    }
  }

  Future<AbsenModel> getAbsensiFiltered(
    String token,
    String tgl_start,
    String tgl_end,
  ) async {
    // dapatkan response dari API
    final response = await getAbsensiFilteredAPI(token, tgl_start, tgl_end);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AbsenModel.fromJson(json as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load absensi filtered');
    }
  }

  Future<String> deleteAbsen(String token, int id) async {
    final response = await deleteAbsenAPI(token, id);
    final json = jsonDecode(response.body);

    return json["message"] ?? "default error delete";
  }
}
