import 'dart:io';

import 'package:dio/dio.dart';

import '../../features/feature_name/presentation/bloc/bloc.dart';
import '../network/custom_response.dart';
import '../utils/app_string.dart';
import 'failures.dart';
import 'handle_error.dart';

class DioErrorHandler {
  static CustomResponse<T> handleDioError<T>(DioException e) {
    String errorMessage;
    int errorType;

    if (e.response?.data is Map &&
        e.response?.data['message'] == AppString.accountSuspended) {
      errorMessage =
          AppString.accountSuspended; // Specific error message in Arabic
      errorType = 1;
    } else {
      if (e.response?.headers.value('content-type')?.contains('text/html') ??
          false) {
        final errorHtml = e.response?.data.toString() ?? 'Unknown HTML error';
        errorMessage = "Error Response (HTML): $errorHtml";
        errorType = 1;
      } else {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            errorMessage = AppString.connectionTimeout;
            errorType = 0;
            break;
          case DioExceptionType.badResponse:
            errorMessage = HandleError()
                .handleError(e.response?.statusCode, e.response?.data);
            if (e.response?.statusCode == 404) {
              showErrorDialogue(AppString.notFound);
              // _showNotification(
              //     "خطأ", AppString.notFound); // Show notification for 404 error
            }
            errorType = 1;
            break;
          case DioExceptionType.cancel:
            errorMessage = AppString.requestCancelled;
            errorType = 2;
            break;
          case DioExceptionType.connectionError:
            errorMessage = AppString.noInternetConnection;
            errorType = 0;
            break;
          default:
            errorMessage = AppString.unknownError;
            errorType = 2;
        }
      }
    }

    return CustomResponse<T>(
      success: false,
      errType: errorType,
      msg: errorMessage,
      statusCode: e.response?.statusCode ?? 0,
      response: e.response,
    );
  }

  static CustomResponse<T> handleDioErrorO<T>(DioException e) {
    String errorMessage;
    int errorType;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = AppString.connectionTimeout;
        errorType = 0;
        break;
      case DioExceptionType.badResponse:
        errorMessage =
            HandleError.i.handleError(e.response?.statusCode, e.response?.data);
        errorType = 1;
        break;
      case DioExceptionType.cancel:
        errorMessage = AppString.requestCancelled;
        errorType = 2;
        break;
      case DioExceptionType.connectionError:
        errorMessage = AppString.noInternetConnection;
        errorType = 0;
        break;
      case DioExceptionType.cancel:
        RequestCancelledFailure(
            statusCode: e.response!.statusCode, message: e.message);
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          NetworkFailure(
              statusCode: e.response!.statusCode, message: e.message);
        }
        UnexpectedFailure(
            statusCode: e.response!.statusCode, message: e.message);
      default:
        UnexpectedFailure(
            statusCode: e.response!.statusCode, message: e.message);

        errorMessage = AppString.unknownError;
        errorType = 2;
    }

    return CustomResponse<T>(
      success: false,
      errType: e.response!.statusCode,
      msg: e.message!,
      statusCode: e.response?.statusCode ?? 0,
      response: e.response,
    );
  }
}
