import 'package:flutter/material.dart';
import 'package:zentri/models/absen_model.dart';
import 'package:zentri/services/api/crud/attendance/attendance_services.dart';
import 'package:zentri/services/shared_preferences/prefs_handler.dart';
import 'package:zentri/utils/widgets/dialog.dart';

class AttendanceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
        getListAbsensi();
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
        getListAbsensi();
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
        getListAbsensi();
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
      getListAbsensi();
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: resultMsg);
    } catch (e) {
      CustomDialog().hide(context);
      CustomDialog().message(context, pesan: "error saat delete: $e");
    }
  }
}
