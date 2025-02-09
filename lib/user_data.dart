class UserDetailsRm {
  UserDetailsRm({
    required this.data,
    required this.message,
    required this.status,
  });

  final Data? data;
  final String message;
  final int status;

  factory UserDetailsRm.fromJson(Map<String, dynamic> json) {
    return UserDetailsRm(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
    );
  }
}

class Data {
  Data(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.fcmToken,
      required this.status,
      required this.isVerified,
      required this.createdAt,
      required this.token,
      required this.expiry});

  final int id;
  final String name;
  final String email;
  final String phone;
  final dynamic image;
  final dynamic fcmToken;
  final String status;
  final String isVerified;
  final DateTime? createdAt;
  final String token;
  final int? expiry;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      image: json["image"],
      fcmToken: json["fcm_token"],
      status: json["status"] ?? "",
      isVerified: json["is_verified"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      token: json["token"] ?? "",
      expiry: json['expiry'] ?? 0,
    );
  }
}
