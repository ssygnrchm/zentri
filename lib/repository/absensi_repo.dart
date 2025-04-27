import 'dart:convert';

import 'package:zentri/absensi/model/absensi_model.dart';
import 'package:zentri/services/absensi_service.dart';

class AbsensiRepo {
  final AbsensiService _service = AbsensiService();

  Future<AbsensiResponse> checkin(
    String checkinLat,
    String checkinLng,
    String checkinAddress,
    String status, [
    String? alasanIzin,
  ]) async {
    final response = await _service.checkin(
      checkinLat,
      checkinLng,
      checkinAddress,
      status,
      alasanIzin,
    );
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AbsensiResponse.fromJson(responseData);
    } else {
      return AbsensiResponse(message: responseData['message'], data: null);
    }
  }

  Future<AbsensiResponse> checkout(
    String checkoutLat,
    String checkoutLng,
    String checkoutLocation,
    String checkoutAddress,
  ) async {
    final response = await _service.checkout(
      checkoutLat,
      checkoutLng,
      checkoutLocation,
      checkoutAddress,
    );
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AbsensiResponse.fromJson(responseData);
    } else {
      return AbsensiResponse(message: responseData['message'], data: null);
    }
  }
}
