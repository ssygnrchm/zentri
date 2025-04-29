class AbsensiResponse {
  final String message;
  final dynamic data; // Can be either AbsensiData or List<AbsensiData>

  AbsensiResponse({required this.message, required this.data});

  factory AbsensiResponse.fromJson(Map<String, dynamic> json) {
    var dataField = json['data'];

    // Handle both single object and list responses
    dynamic processedData;
    if (dataField is List) {
      processedData =
          dataField.map((item) => AbsensiData.fromJson(item)).toList();
    } else if (dataField != null) {
      processedData = AbsensiData.fromJson(dataField);
    } else {
      processedData = null;
    }

    return AbsensiResponse(message: json['message'], data: processedData);
  }

  // Helper methods to access data in different formats
  AbsensiData? getSingleData() {
    return data is AbsensiData ? data : null;
  }

  List<AbsensiData>? getDataList() {
    return data is List ? data : null;
  }
}

class AbsensiData {
  int userId;
  DateTime checkIn;
  String checkInLocation;
  String checkInAddress;
  String status;
  String? alasanIzin;
  DateTime? checkOut; // Added field
  String? checkOutLocation; // Added field
  String? checkOutAddress; // Added field
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
    this.alasanIzin,
    this.checkOut, // Optional field
    this.checkOutLocation, // Optional field
    this.checkOutAddress, // Optional field
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
      userId: json['user_id'] ?? 0,
      checkIn:
          json['check_in'] != null
              ? DateTime.parse(json['check_in'])
              : DateTime.now(),
      checkInLocation: json['check_in_location'] ?? '',
      checkInAddress: json['check_in_address'] ?? '',
      status: json['status'] ?? '',
      alasanIzin: json['alasan_izin'],
      checkOut:
          json['check_out'] != null ? DateTime.parse(json['check_out']) : null,
      checkOutLocation: json['check_out_location'],
      checkOutAddress: json['check_out_address'],
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      id: json['id'] ?? 0,
      checkInLat: (json['check_in_lat'] ?? 0.0).toDouble(),
      checkInLng: (json['check_in_lng'] ?? 0.0).toDouble(),
      checkOutLat: (json['check_out_lat'] ?? 0.0).toDouble(),
      checkOutLng: (json['check_out_lng'] ?? 0.0).toDouble(),
    );
  }
}
