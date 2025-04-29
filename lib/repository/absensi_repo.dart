import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:zentri/absensi/model/absensi_model.dart';
import 'package:zentri/services/absensi_service.dart';

class AbsensiRepo {
  final AbsensiService _service = AbsensiService();
  bool _initialized = false;

  // Make sure service is initialized before any operation
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _service.initialize();
      _initialized = true;
    }
  }

  Future<AbsensiResponse> checkin(
    String checkinLat,
    String checkinLng,
    String checkinAddress,
    String status, [
    String? alasanIzin,
  ]) async {
    try {
      await _ensureInitialized();

      final response = await _service.checkin(
        checkinLat,
        checkinLng,
        checkinAddress,
        status,
        alasanIzin,
      );

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          return AbsensiResponse.fromJson(responseData);
        } catch (e) {
          print('Error parsing response: $e');
          return AbsensiResponse(
            message: 'Failed to parse response: $e',
            data: null,
          );
        }
      } else {
        try {
          final responseData = jsonDecode(response.body);
          // Make sure we always return a non-null message
          String message = 'Error occurred';
          if (responseData != null && responseData['message'] != null) {
            message = responseData['message'];
          }
          return AbsensiResponse(message: message, data: null);
        } catch (e) {
          print('Error parsing error response: $e');
          return AbsensiResponse(
            message: 'Error code: ${response.statusCode}',
            data: null,
          );
        }
      }
    } catch (e) {
      print('Error in checkin repo: $e');
      return AbsensiResponse(message: 'Failed to check in: $e', data: null);
    }
  }

  Future<AbsensiResponse> checkout(
    String checkoutLat,
    String checkoutLng,
    String checkoutLocation,
    String checkoutAddress,
  ) async {
    await _ensureInitialized();

    try {
      final response = await _service.checkout(
        checkoutLat,
        checkoutLng,
        checkoutLocation,
        checkoutAddress,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return AbsensiResponse.fromJson(responseData);
      } else {
        final responseData = jsonDecode(response.body);
        // Make sure we always return a non-null message
        String message = 'Error occurred';
        if (responseData != null && responseData['message'] != null) {
          message = responseData['message'];
        }
        return AbsensiResponse(message: message, data: null);
      }
    } catch (e) {
      print('Error in checkout repo: $e');
      return AbsensiResponse(message: 'Failed to check out: $e', data: null);
    }
  }

  // New method to get attendance history
  Future<AbsensiResponse> getHistory({
    String? startDate,
    String? endDate,
  }) async {
    try {
      await _ensureInitialized();

      // If dates are not provided, use today's date
      final today = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(today);

      final start = startDate ?? formattedDate;
      final end = endDate ?? formattedDate;

      final response = await _service.getHistory(start, end);

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          return AbsensiResponse.fromJson(responseData);
        } catch (e) {
          print('Error parsing history response: $e');
          return AbsensiResponse(
            message: 'Failed to parse response: $e',
            data: null,
          );
        }
      } else {
        try {
          final responseData = jsonDecode(response.body);
          String message = 'Error occurred';
          if (responseData != null && responseData['message'] != null) {
            message = responseData['message'];
          }
          return AbsensiResponse(message: message, data: null);
        } catch (e) {
          print('Error parsing error response: $e');
          return AbsensiResponse(
            message: 'Error code: ${response.statusCode}',
            data: null,
          );
        }
      }
    } catch (e) {
      print('Error in getHistory repo: $e');
      return AbsensiResponse(
        message: 'Failed to get attendance history: $e',
        data: null,
      );
    }
  }

  Future<String> deleteAbsen(id) async {
    final response = await _service.deleteAbsen(id);
    final json = jsonDecode(response.body);
    return json['message'] ?? "default error";
  }
}
