import 'package:dio/dio.dart';

abstract class Failure<T> {
  bool success;
  int? errType;
  String? status;
  // 0 => network error
  // 1 => error from the server
  // 3 => unAuth
  // 2 => other error

  String message;
  int? statusCode;
  Response? response;
  T? data;
  Failure({
    this.success = false,
    this.errType = 0,
    this.message = "",
    this.status = "",
    this.statusCode = 0,
    this.response,
    this.data,
  });
  // Failure({this.message, this.statusCode, this.response});

  @override
  List<Object?> get props => [message, statusCode, response];
}

class ServerFailure<T> extends Failure<T> {
  ServerFailure({
    bool? success,
    int? errType,
    String? message,
    String? status,
    int? statusCode,
    Response? response,
    T? data,
  }) : super(
          message: message!,
          status: status,
          statusCode: statusCode,
          response: response,
          success: success!,
          errType: errType,
          data: data,
        );
}

class ClientFailure extends Failure {
  ClientFailure({
    String? message,
    int? statusCode,
    Response? response,
  }) : super(
          message: message!,
          statusCode: statusCode,
          response: response,
        );
}

class NetworkFailure extends Failure {
  NetworkFailure({
    String? message,
    int? statusCode,
    Response? response,
  }) : super(
          message: message!,
          statusCode: statusCode,
          response: response,
        );
}

class RequestCancelledFailure extends Failure {
  RequestCancelledFailure({
    String? message,
    int? statusCode,
    Response? response,
  }) : super(
          message: message!,
          statusCode: statusCode,
          response: response,
        );
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure({
    String? message,
    int? statusCode,
    Response? response,
  }) : super(
          message: message!,
          statusCode: statusCode,
          response: response,
        );
}
