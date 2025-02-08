class StatusModel {
  StatusModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String status;
  final String message;
  final dynamic data;

  StatusModel copyWith({
    String? status,
    String? message,
    dynamic? data,
  }) {
    return StatusModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      data: json["data"],
    );
  }
}
