class UserModel {
  final int? id; // Make id nullable
  final String name;
  final String email;

  UserModel({this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
