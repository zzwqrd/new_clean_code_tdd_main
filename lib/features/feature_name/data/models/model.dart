import 'package:equatable/equatable.dart';

class RegisterModel extends Equatable {
  RegisterModel({
    required this.status,
    required this.data,
    required this.message,
    required this.devMessage,
  });

  final String status;
  final dynamic data;
  final String message;
  final int devMessage;

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: json["status"] ?? "",
      data: json["data"],
      message: json["message"] ?? "",
      devMessage: json["dev_message"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
        "message": message,
        "dev_message": devMessage,
      };

  @override
  List<Object?> get props => [
        status,
        data,
        message,
        devMessage,
      ];
}
