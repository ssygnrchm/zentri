class AbsensiResponse {
  final String message;
  final AbsensiData? data;

  AbsensiResponse({required this.message, this.data});

  factory AbsensiResponse.fromJson(Map<String, dynamic> json) {
    return AbsensiResponse(
      message: json['message'],
      data: json['data'] != null ? AbsensiData.fromJson(json['data']) : null,
    );
  }
}

class AbsensiData {
  int userId;
  DateTime checkIn;
  String checkInLocation;
  String checkInAddress;
  String status;
  dynamic alasanIzin;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  double checkInLat;
  double checkInLng;
  double checkOutLat;
  double checkOutLng;

  AbsensiData({
    required this.userId,
    required this.checkIn,
    required this.checkInLocation,
    required this.checkInAddress,
    required this.status,
    required this.alasanIzin,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkOutLat,
    required this.checkOutLng,
  });

  factory AbsensiData.fromJson(Map<String, dynamic> json) {
    return AbsensiData(
      userId: json['user_id'],
      checkIn: json['check_in'],
      checkInLocation: json['check_in_location'],
      checkInAddress: json['check_in_address'],
      status: json['status'],
      alasanIzin: json['alasan_izin'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
      checkInLat: json['check_in_lat'],
      checkInLng: json['check_in_lng'],
      checkOutLat: json['check_out_lat'],
      checkOutLng: json['check_out_lng'],
    );
  }
}
