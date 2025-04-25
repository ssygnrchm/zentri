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
      userId: json['userID'],
      checkIn: json['checkIn'],
      checkInLocation: json['checkInLocation'],
      checkInAddress: json['checkInAddress'],
      status: json['status'],
      alasanIzin: json['alasanIzin'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      id: json['id'],
      checkInLat: json['checkInLat'],
      checkInLng: json['checkInLng'],
      checkOutLat: json['checkOutLat'],
      checkOutLng: json['checkOutLng'],
    );
  }
}
