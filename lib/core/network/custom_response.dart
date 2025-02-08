import 'package:dio/dio.dart';

class CustomResponse<T> {
  bool success;
  int? errType;
  String msg;
  int statusCode;
  Response? response;
  T? data;

  CustomResponse({
    this.success = false,
    this.errType = 0,
    this.msg = "",
    this.statusCode = 0,
    this.response,
    this.data,
  });
}
