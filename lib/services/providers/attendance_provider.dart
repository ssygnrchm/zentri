import 'package:flutter/material.dart';
import 'package:zentri/models/absen_model.dart';
import 'package:zentri/services/api/crud/attendance/attendance_services.dart';
import 'package:zentri/services/shared_preferences/prefs_handler.dart';
import 'package:zentri/utils/widgets/dialog.dart';

class AttendanceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Track today's check-in status
  bool _isCheckedIn = false;
  bool get isCheckedIn => _isCheckedIn;

  // Method to check if user is already checked in today
  bool isUserCheckedIn() {
    if (_listAbsen.isEmpty) return false;

    // Get the latest attendance record
    final latestAttendance = _listAbsen.first;

    // Check if it's today's record and has check-in time but no check-out time
    if (latestAttendance.checkIn == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Parse the attendance date (adjust this based on your actual date format)
    final attendanceDate = latestAttendance.checkIn!;
    final attendanceDay = DateTime(
      attendanceDate.year,
      attendanceDate.month,
      attendanceDate.day,
    );

    // Check if it's today's record and has check-in but no check-out
    return attendanceDay.isAtSameMomentAs(today) &&
        latestAttendance.checkIn != null &&
        (latestAttendance.checkOut == null);
  }

  // Update the check-in status after fetching data
  void _updateCheckInStatus() {
    _isCheckedIn = isUserCheckedIn();
    notifyListeners();
  }

  Future<void> checkInUser(
    BuildContext context, {
    required double lat,
    required double long,
    required String address,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> _responseReg = await AttendanceServices().checkIn(
        lat,
        long,
        address,
        token,
      );

      if (_responseReg["success"] == true) {
        await getListAbsensi(); // Get updated list after check-in
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().message(context, pesan: _responseReg['data']['message']);
      } else {
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().message(context, pesan: _responseReg['message']);
      }
    } catch (e) {
      CustomDialog().hide(context);
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: "error saat Check in: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkOutUser(
    BuildContext context, {
    required double lat,
    required double long,
    required String location,
    required String address,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> _responseReg = await AttendanceServices().checkOut(
        lat,
        long,
        location,
        address,
        token,
      );

      if (_responseReg["success"] == true) {
        await getListAbsensi(); // Get updated list after check-out
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().message(context, pesan: _responseReg['data']['message']);
      } else {
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().message(context, pesan: _responseReg['message']);
      }
    } catch (e) {
      CustomDialog().hide(context);
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: "error saat Check out: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkInIzinUser(
    BuildContext context, {
    required double lat,
    required double long,
    required String address,
    required String alasan,
  }) async {
    String token = await PrefsHandler.getToken();
    try {
      Map<String, dynamic> _responseReg = await AttendanceServices()
          .checkInIzin(lat, long, address, token, alasan);

      if (_responseReg["success"] == true) {
        await getListAbsensi(); // Get updated list after permission check-in
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().message(context, pesan: _responseReg['data']['message']);
      } else {
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().hide(context);
        CustomDialog().message(context, pesan: _responseReg['message']);
      }
    } catch (e) {
      CustomDialog().hide(context);
      CustomDialog().hide(context);
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: "error saat Izin: $e");
    }
  }

  List<Datum> _listAbsen = [];
  List<Datum> get listAbsen => _listAbsen;

  Future<void> getListAbsensi() async {
    _isLoading = true;
    notifyListeners();
    String token = await PrefsHandler.getToken();
    try {
      AbsenModel dataAbsen = await AttendanceServices().getAbsensi(token);
      _listAbsen = dataAbsen.data ?? [];
      _updateCheckInStatus(); // Update check-in status after fetching data
    } catch (e) {
      throw Exception("Failed to load data absen: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getListAbsensiFiltered({
    required String tgl_start,
    required String tgl_end,
  }) async {
    _isLoading = true;
    notifyListeners();
    String token = await PrefsHandler.getToken();
    try {
      AbsenModel dataAbsen = await AttendanceServices().getAbsensiFiltered(
        token,
        tgl_start,
        tgl_end,
      );
      _listAbsen = dataAbsen.data ?? [];
      _updateCheckInStatus(); // Update check-in status after fetching filtered data
    } catch (e) {
      throw Exception("Failed to load data absen filtered: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAbsenUser(BuildContext context, {required int id}) async {
    String token = await PrefsHandler.getToken();

    try {
      String resultMsg = await AttendanceServices().deleteAbsen(token, id);
      await getListAbsensi(); // Get updated list after deletion
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: resultMsg);
    } catch (e) {
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: "error saat delete: $e");
    }
  }
}
