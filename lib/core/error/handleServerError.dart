import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../network/custom_response.dart';
import '../utils/helpers/loger.dart';

class HandleServerError {
  CustomResponse<T> handleDioError<T>(DioException err) {
    LoggerDebug? log;
    // final dioException = DioExceptions.fromDioError(err);
    log!.red(err.toString());

    String errorMessage;
    int errorType;

    if (err.type == DioExceptionType.badResponse) {
      if (err.response!.data.toString().contains("DOCTYPE") ||
          err.response!.data.toString().contains("<script>") ||
          err.response!.data["exception"] != null) {
        return CustomResponse(
          success: false,
          errType: 1,
          statusCode: err.response!.statusCode ?? 500,
          msg: kDebugMode
              ? "${err.response!.data}"
              : "خطأ في الخادم يرجى المحاولة مرة أخرى في وقت لاحق",
          response: null,
        );
      }
      if (err.response!.statusCode == 401) {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 401,
          errType: 3,
          msg: err.response?.data["message"] ?? '',
          response: err.response,
        );
      }
      try {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 500,
          errType: 2,
          msg: (err.response!.data["errors"] as Map).values.first.first,
          response: err.response,
        );
      } catch (e) {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 500,
          errType: 2,
          msg: err.response?.data["message"],
          response: err.response,
        );
      }
    } else if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return CustomResponse(
        success: false,
        statusCode: err.response?.statusCode ?? 500,
        errType: 0,
        msg: "الاتصال ضعيف التحقق من جودة الإنترنت",
        response: null,
      );
    } else {
      if (err.response == null) {
        return CustomResponse(
          success: false,
          statusCode: 402,
          errType: 0,
          msg: "الاتصال ضعيف التحقق من جودة الإنترنت",
          response: null,
        );
      }
      return CustomResponse(
        success: false,
        statusCode: 402,
        errType: 1,
        msg: "خطأ في الخادم يرجى المحاولة مرة أخرى في وقت لاحق",
        response: null,
      );
    }
  }
}
