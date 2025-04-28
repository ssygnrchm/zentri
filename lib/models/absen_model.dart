// To parse this JSON data, do
//
//     final absenModel = absenModelFromJson(jsonString);

import 'dart:convert';

AbsenModel absenModelFromJson(String str) => AbsenModel.fromJson(json.decode(str));

String absenModelToJson(AbsenModel data) => json.encode(data.toJson());

class AbsenModel {
    final String? message;
    final List<Datum>? data;

    AbsenModel({
        this.message,
        this.data,
    });

    factory AbsenModel.fromJson(Map<String, dynamic> json) => AbsenModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? id;
    final int? userId;
    final DateTime? checkIn;
    final String? checkInLocation;
    final String? checkInAddress;
    final DateTime? checkOut;
    final String? checkOutLocation;
    final String? checkOutAddress;
    final String? status;
    final dynamic alasanIzin;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final double? checkInLat;
    final double? checkInLng;
    final double? checkOutLat;
    final double? checkOutLng;

    Datum({
        this.id,
        this.userId,
        this.checkIn,
        this.checkInLocation,
        this.checkInAddress,
        this.checkOut,
        this.checkOutLocation,
        this.checkOutAddress,
        this.status,
        this.alasanIzin,
        this.createdAt,
        this.updatedAt,
        this.checkInLat,
        this.checkInLng,
        this.checkOutLat,
        this.checkOutLng,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        checkIn: json["check_in"] == null ? null : DateTime.parse(json["check_in"]),
        checkInLocation: json["check_in_location"],
        checkInAddress: json["check_in_address"],
        checkOut: json["check_out"] == null ? null : DateTime.parse(json["check_out"]),
        checkOutLocation: json["check_out_location"],
        checkOutAddress: json["check_out_address"],
        status: json["status"],
        alasanIzin: json["alasan_izin"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        checkInLat: json["check_in_lat"]?.toDouble(),
        checkInLng: json["check_in_lng"]?.toDouble(),
        checkOutLat: json["check_out_lat"]?.toDouble(),
        checkOutLng: json["check_out_lng"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "check_in": checkIn?.toIso8601String(),
        "check_in_location": checkInLocation,
        "check_in_address": checkInAddress,
        "check_out": checkOut?.toIso8601String(),
        "check_out_location": checkOutLocation,
        "check_out_address": checkOutAddress,
        "status": status,
        "alasan_izin": alasanIzin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "check_in_lat": checkInLat,
        "check_in_lng": checkInLng,
        "check_out_lat": checkOutLat,
        "check_out_lng": checkOutLng,
    };
}
