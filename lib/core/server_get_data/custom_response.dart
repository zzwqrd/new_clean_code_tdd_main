import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_response.freezed.dart';

@freezed
class CustomResponse with _$CustomResponse {
  const factory CustomResponse({
    required int statusCode,
    required String message,
    dynamic data,
  }) = _CustomResponse;

  factory CustomResponse.fromJson(Map<String, dynamic> json) {
    return CustomResponse(
      statusCode: json['statusCode'] != null
          ? json['statusCode'].toInt()
          : 0, // إذا كانت null، يتم إرجاع 0
      message: json['message'] != null
          ? json['message'] as String
          : 'No message', // رسالة افتراضية إذا كانت null
      data: json['data'], // ترك الحقل كما هو للتعامل معه لاحقاً
    );
  }
}
