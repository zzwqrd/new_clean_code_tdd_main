import 'dart:convert';

import 'package:dio/dio.dart';

import '../utils/loger.dart';

class CustomApiInterceptor extends Interceptor {
  LoggerDebug log;

  CustomApiInterceptor(this.log);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.headers.value('content-type')?.contains('text/html') ??
        false) {
      final errorHtml = err.response?.data.toString() ?? 'Unknown HTML error';
      log.red(
          "Error Response (HTML): $errorHtml (Status code: ${err.response?.statusCode})");
    } else {
      log.red(
          "Error Response: ${err.response?.data} (Status code: ${err.response?.statusCode})");
    }
    log.red(" (Status code: ${err.response?.statusCode})");
    if (err.response?.statusCode == 302) {
      final newUrl = err.response?.headers.value('location');
      if (newUrl != null) {
        final options = err.requestOptions;
        options.path = newUrl;

        try {
          final response = await Dio().fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }

    return super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    log.green("------ Current Response ------");
    log.green(jsonEncode(response.data));
    log.green("------ Current statusCode ------");
    log.green(jsonEncode(response.statusCode));
    return super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.cyan("------ Current Request Parameters Data -----");
    log.cyan("${options.queryParameters}");
    log.yellow("------ Current Request Headers -----");
    log.yellow("${options.headers}");
    log.green("------ Current Request Path -----");
    log.green(
        "${options.path} ${LogColors.red}API METHOD : (${options.method})${LogColors.reset}");
    return super.onRequest(options, handler);
  }
}

// class CustomApiInterceptor extends Interceptor {
//   LoggerDebug log;
//
//   CustomApiInterceptor(this.log);
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     // Check if the error response is HTML content
//     if (err.response?.headers.value('content-type')?.contains('text/html') ??
//         false) {
//       final errorHtml = err.response?.data.toString() ?? 'Unknown HTML error';
//       log.red(
//           "Error Response (HTML): $errorHtml (Status code: ${err.response?.statusCode})");
//     } else {
//       log.red(
//           "Error Response: ${err.response?.data} (Status code: ${err.response?.statusCode})");
//     }
//
//     if (err.response?.statusCode == 302) {
//       final newUrl = err.response?.headers.value('location');
//       if (newUrl != null) {
//         final options = err.requestOptions;
//         options.path = newUrl;
//
//         try {
//           final response = await Dio().fetch(options);
//           return handler.resolve(response);
//         } catch (e) {
//           return handler.next(err);
//         }
//       }
//     }
//
//     return super.onError(err, handler);
//   }
//
//   @override
//   Future<void> onResponse(
//       Response response, ResponseInterceptorHandler handler) async {
//     log.green("------ Current Response ------");
//     log.green(jsonEncode(response.data));
//     log.green("------ Current statusCode ------");
//     log.green(jsonEncode(response.statusCode));
//     return super.onResponse(response, handler);
//   }
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     log.cyan("------ Current Request Parameters Data -----");
//     log.cyan("${options.queryParameters}");
//     log.yellow("------ Current Request Headers -----");
//     log.yellow("${options.headers}");
//     log.green("------ Current Request Path -----");
//     log.green(
//         "${options.path} ${LogColors.red}API METHOD : (${options.method})${LogColors.reset}");
//     return super.onRequest(options, handler);
//   }
// }
