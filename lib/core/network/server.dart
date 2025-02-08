import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:clean_code_tdd_main/core/AppUrl/url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_string.dart';
import '../utils/helpers/loger.dart';
import 'base_url_service.dart';

class ServerGate {
  String? BASE_URL;
  final _dio = Dio();
  static final i = ServerGate._();
  final LoggerDebug log =
      LoggerDebug(headColor: LogColors.red, constTitle: "Server Gate Logger");

  ServerGate._() {
    BaseUrlService(AppUrl.BASE_URL);
    addInterceptors();
  }
  final _networkInfo = Connectivity();

  CancelToken cancelToken = CancelToken();

  Map<String, dynamic> _header() {
    return {
      // if (User.i.isAuth) "Authorization": "Bearer ${User.i.token}",
      "Accept": "application/json",
      "lang": "ar",
    };
  }

  void addInterceptors() {
    _dio.interceptors.add(CustomApiInterceptor(log));
  }

  // [][][][][][][][][][][][][] POST DATA TO SERVER [][][][][][][][][][][][][] //
  StreamController<double> onSingleReceive = StreamController.broadcast();
  // ------- POST delete TO SERVER -------//

  Future<CustomResponse<T>> sendToServer<T>({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
    T Function(dynamic)? callback,
    bool withoutHeader = false,
    String attribute = "data",
  }) async {
    // Ensure the base URL is set
    await _getBeaseUrl();

    /// add code
    if (await _networkInfo.checkConnectivity() == ConnectivityResult.none) {
      return CustomResponse<T>(
        success: false,
        errType: 0,
        message: AppString.noInternetConnection,
      );
    }

    // Remove null or empty values from the body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
      log.white("------ body for this req. -----");
      Map<String, String> buildBody =
          body.map((key, value) => MapEntry(key, value.toString()));
      log.white(jsonEncode(buildBody));
    }

    // Remove null or empty values from the params
    if (params != null) {
      params.removeWhere(
        (key, value) => params[key] == null || params[key] == "",
      );
    }

    // Add standard headers
    if (headers != null) {
      if (!withoutHeader) headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      if (!withoutHeader) headers = _header();
    }

    log.white("Request body: ${jsonEncode(body)}");
    log.white("Request params: ${jsonEncode(params)}");

    dynamic _prepareRequestBody(Map<String, dynamic>? body) {
      if (body != null && body.values.any((value) => value is MultipartFile)) {
        return FormData.fromMap(body);
      } else {
        return jsonEncode(body ?? {});
      }
    }

    try {
      dynamic requestBody = withoutHeader ? body : _prepareRequestBody(body);
      // Send POST request using Dio
      Response response = await _dio.post(
        url.startsWith("http") ? url : "$BASE_URL/$url",
        // data: withoutHeader ? body : FormData.fromMap(body ?? {}),
        data: requestBody,
        onSendProgress: (received, total) {
          onSingleReceive.add((received / total) - 0.05);
        },
        queryParameters: params,
        options: Options(
          method: "POST",
          sendTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
          // contentType: "application/json",
          headers: headers,

          /// add code
          contentType:
              body != null && body.values.any((value) => value is MultipartFile)
                  ? Headers.formUrlEncodedContentType
                  : Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      // Check if the response data is a Map
      if (response.data is! Map) {
        response.data = {
          "message": kDebugMode
              ? response.data.toString()
              : "sorry Something went wrong",
        };
        response.statusCode = 500;
        log.red("\x1B[37m------ Current Error Response -----\x1B[0m");
        log.red("\x1B[31m${response.data}\x1B[0m");
        log.red("\x1B[37m------ Current Error statusCode -----\x1B[0m");
        log.red("\x1B[31m${response.statusCode}\x1B[0m");
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.unknown,
        );
      }

      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        message:
            response.data["message"] ?? "Your request completed succesfully",
        response: response,
        data: callback == null
            ? null
            : objectFromJson<T>(callback, response, attribute: attribute),
      );
    } on DioException catch (err) {
      // Handle DioException and return a CustomResponse object
      return handleServerError(err);
    }
  }

  // ------- DELETE delete TO SERVER -------//
  Future<CustomResponse<T>> deleteFromServer<T>({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    T Function(dynamic)? callback,
    Map<String, dynamic>? params,
    String attribute = "data",
  }) async {
    // Ensure the base URL is set
    await _getBeaseUrl();

    // Remove null or empty values from the body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
    }

    // Remove null or empty values from the params
    if (params != null) {
      params.removeWhere(
        (key, value) => params[key] == null || params[key] == "",
      );
    }

    // Add standard headers
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      headers = _header();
    }

    try {
      // Send DELETE request using Dio
      Response response = await _dio.delete(
        "$BASE_URL/$url",
        data: FormData.fromMap(body ?? {}),
        queryParameters: params,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
        ),
      );
      // if (response.data["status"] == "fail") {
      //   return CustomResponse<T>(
      //     success: false,
      //     statusCode: 404,
      //     errType: null,
      //     message: (response.data["message"] ??
      //             "Your request completed successfully")
      //         .toString(),
      //     response: response,
      //     data: callback == null
      //         ? null
      //         : objectFromJson<T>(callback, response, attribute: attribute),
      //   );
      // }
      // Create a CustomResponse object and return it
      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        message:
            response.data["message"] ?? "Your request completed succesfully",
        response: response,
        data: callback == null
            ? null
            : objectFromJson<T>(callback, response, attribute: attribute),
      );
    } on DioException catch (err) {
      // Handle DioException and return a CustomResponse object
      return handleServerError(err);
    }
  }

  // ------- PUT DATA TO SERVER -------//

  Future<CustomResponse<T>> putToServer<T>({
    required String url,
    Map<String, dynamic>? headers,
    T Function(dynamic)? callback,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) async {
    // Ensure the base URL is set
    await _getBeaseUrl();

    /// add code
    if (await _networkInfo.checkConnectivity() == ConnectivityResult.none) {
      return CustomResponse<T>(
        success: false,
        errType: 0,
        message: AppString.noInternetConnection,
      );
    }
    // Remove null or empty values from the body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
    }

    // Add standard headers
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      headers = _header();
    }
    log.white("Request body: ${jsonEncode(body)}");
    log.white("Request params: ${jsonEncode(params)}");

    dynamic _prepareRequestBody(Map<String, dynamic>? body) {
      if (body != null && body.values.any((value) => value is MultipartFile)) {
        return FormData.fromMap(body);
      } else {
        return jsonEncode(body ?? {});
      }
    }

    try {
      // dynamic requestBody = withoutHeader ? body : _prepareRequestBody(body);

      // Send PUT request using Dio
      Response response = await _dio.put(
        "$BASE_URL/$url",
        // data: FormData.fromMap(body ?? {}),
        data: _prepareRequestBody(body),
        options: Options(
          headers: headers,

          /// add code
          contentType:
              body != null && body.values.any((value) => value is MultipartFile)
                  ? Headers.formUrlEncodedContentType
                  : Headers.jsonContentType,
          responseType: ResponseType.json,
          sendTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
        ),
      );

      // Create and return a CustomResponse object
      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        message:
            response.data["message"] ?? "Your request completed succesfully",
        response: response,
        data: callback == null ? null : objectFromJson<T>(callback, response),
      );
    } on DioException catch (err) {
      // Handle DioException and return a CustomResponse object
      return handleServerError(err);
    } catch (e) {
      // Handle other exceptions and return a CustomResponse object
      final option = RequestOptions(path: "$BASE_URL/$url");
      return handleServerError(DioException(
        requestOptions: option,
        response: Response(
          requestOptions: option,
          data: {
            "message": "خطأ في الخادم يرجى المحاولة مرة أخرى في وقت لاحق",
          },
        ),
        type: DioExceptionType.unknown,
      ));
    }
  }

  T objectFromJson<T>(T Function(dynamic) callback, Response response,
      {String? attribute}) {
    try {
      if (response.data != null) {
        if (attribute == "") return callback(response.data);
        if (response.data[attribute ?? "data"] != null) {
          return callback(response.data[attribute ?? "data"]);
        }
      }
      return callback(T is List ? <T>[] : <String, dynamic>{});
    } catch (e) {
      // Handle exceptions and throw a DioException
      response.data = {
        "message":
            kDebugMode ? e.toString() : "LocaleKeys.sorry_Something_went_wrong",
      };
      response.statusCode = 500;
      log.red("\x1B[37m------ Current Error Response -----\x1B[0m");
      log.red("\x1B[31m${response.data}\x1B[0m");
      log.red("\x1B[37m------ Current Error StatusCode -----\x1B[0m");
      log.red("\x1B[31m${response.statusCode}\x1B[0m");
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  // ------ GET DATA FROM SERVER -------//
  Future<CustomResponse<T>> getFromServer<T>({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    T Function(dynamic json)? callback,
    String? attribute,
    bool withoutHeader = false,
  }) async {
    // Ensure the base URL is set
    await _getBeaseUrl();

    // Add standard headers if not skipping
    if (!withoutHeader) {
      if (headers != null) {
        if (!withoutHeader) headers.addAll(_header());
        headers.removeWhere((key, value) => value == null || value == "");
      } else {
        if (!withoutHeader) headers = _header();
      }
    }

    // Remove nulls from params
    if (params != null) {
      params.removeWhere(
          (key, value) => params[key] == null || params[key] == "");
    }

    try {
      // Send GET request using Dio
      Response response = await _dio.get(
        url.startsWith("http") ? url : "$BASE_URL/$url",
        options: Options(
          headers: headers,
          sendTimeout: const Duration(milliseconds: 50000),
          receiveTimeout: const Duration(milliseconds: 50000),
        ),
        queryParameters: params,
      );

      // Check if response data is null or not a LinkedHashMap
      if (response.data == null || response.data is! LinkedHashMap) {
        response.statusCode = 500;
        throw DioException(
            requestOptions: response.requestOptions, response: response);
      }
      if (response.data["status"] == "fail") {
        return CustomResponse<T>(
          success: false,
          statusCode: 404,
          errType: null,
          message: (response.data["message"] ??
                  "Your request completed successfully")
              .toString(),
          response: response,
          data: callback == null
              ? null
              : objectFromJson<T>(callback, response, attribute: attribute),
        );
      }
      if (response.statusCode == 404) {
        // return CustomResponse(
        //   success: false,
        //   statusCode: response.statusCode ?? 404,
        //   errType: 0,
        //   message: response.data["message"] ?? '',
        //   response: response,
        // );
        // return CustomResponse<T>(
        //   success: false,
        //   statusCode: 404,
        //   errType: null,
        //   message: (response.data["message"] ??
        //           "Your request completed successfully")
        //       .toString(),
        //   response: response,
        //   data: callback == null
        //       ? null
        //       : objectFromJson<T>(callback, response, attribute: attribute),
        // );
      }

      // Create and return a CustomResponse object
      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        message:
            (response.data["message"] ?? "Your request completed successfully")
                .toString(),
        response: response,
        data: callback == null
            ? null
            : objectFromJson<T>(callback, response, attribute: attribute),
      );
    } on DioException catch (err) {
      // Handle DioException and return a CustomResponse object
      return handleServerError(err);
    } catch (e) {
      // Handle other exceptions and return a CustomResponse object
      final option = RequestOptions(path: "$BASE_URL/$url");
      return handleServerError(
        DioException(
          requestOptions: option,
          response: Response(
            requestOptions: option,
            data: {
              "message": "server error please try again later",
            },
          ),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  // ------ Download DATA FROM SERVER -------//

  Future<CustomResponse> downloadFromServer({
    required String url,
    required String path,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    await _getBeaseUrl();
    // add stander header
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      headers = _header();
    }

    try {
      Response response =
          await _dio.download(url, path, onReceiveProgress: (received, total) {
        onSingleReceive.add((received / total));
      });
      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        message:
            response.data['message'] ?? "Your request completed succesfully",
        response: response,
      );
    } on DioException catch (err) {
      return handleServerError(err);
    }
  }

  // -------- HANDLE ERROR ---------//
  // static CustomResponse<T> handleServerError<T>(DioException e) {
  //   String errorMessage;
  //   int errorType;
  //
  //   switch (e.type) {
  //     case DioExceptionType.connectionTimeout:
  //     case DioExceptionType.sendTimeout:
  //     case DioExceptionType.receiveTimeout:
  //       errorMessage = AppString.connectionTimeout;
  //       errorType = 0;
  //       break;
  //     case DioExceptionType.badResponse:
  //       if (e.response?.statusCode == 401) {
  //         errorMessage = "قم بتسجيل الدخول أولا";
  //         errorType = 3;
  //         e.response!.statusCode = 401;
  //       } else if (e.response?.statusCode == 404) {
  //         errorMessage = e.response!.data['message'];
  //         errorType = 3;
  //         e.response!.statusCode = 404;
  //         CustomResponse<T>(
  //           success: false,
  //           statusCode: 404,
  //           errType: null,
  //           message: (e.response!.data["message"] ?? "Error").toString(),
  //           response: e.response,
  //         );
  //       } else {
  //         errorMessage = HandleError.i
  //             .handleError(e.response?.statusCode, e.response?.data);
  //         errorType = 1;
  //       }
  //
  //       errorMessage =
  //           HandleError.i.handleError(e.response?.statusCode, e.response?.data);
  //       errorType = 1;
  //       // if (e.response!.statusCode == 404) {
  //       //   showErrorDialogue(e.response!.data['message'] ?? "");
  //       // }
  //
  //       break;
  //     case DioExceptionType.cancel:
  //       errorMessage = AppString.requestCancelled;
  //       errorType = 2;
  //       break;
  //     case DioExceptionType.connectionError:
  //       errorMessage = AppString.noInternetConnection;
  //       errorType = 0;
  //       break;
  //     case DioExceptionType.cancel:
  //       RequestCancelledFailure(
  //           statusCode: e.response!.statusCode, message: e.message);
  //     case DioExceptionType.unknown:
  //       if (e.error is SocketException) {
  //         NetworkFailure(
  //             statusCode: e.response!.statusCode, message: e.message);
  //       }
  //       UnexpectedFailure(
  //           statusCode: e.response!.statusCode, message: e.message);
  //     default:
  //       UnexpectedFailure(
  //           statusCode: e.response!.statusCode, message: e.message);
  //
  //       errorMessage = AppString.unknownError;
  //       errorType = 2;
  //   }
  //
  //   return CustomResponse<T>(
  //     success: false,
  //     errType: e.response!.statusCode,
  //     message: e.message!,
  //     statusCode: e.response?.statusCode ?? 0,
  //     response: e.response,
  //   );
  // }
  // CustomResponse<T> handleServerError<T>(DioException err) {
  //   if (err.type == DioExceptionType.badResponse) {
  //     if (err.response!.data.toString().contains("DOCTYPE") ||
  //         err.response!.data.toString().contains("<script>") ||
  //         err.response!.data["exception"] != null) {
  //       // firebaseCrashlytics.apiRecordError(
  //       //   err.response?.data,
  //       //   err.stackTrace ?? StackTrace.empty,
  //       //   "${err.requestOptions.path} (${err.requestOptions.method})",
  //       // );
  //       // if (kDebugMode) FlashHelper.errorBar(message: "${err.response!.data}");
  //       return CustomResponse(
  //         success: false,
  //         errType: 1,
  //         statusCode: err.response!.statusCode ?? 500,
  //         message: kDebugMode
  //             ? "${err.response!.data}"
  //             : "server error please try again later",
  //         response: null,
  //       );
  //     }
  //     if (err.response!.statusCode == 401) {
  //       return CustomResponse(
  //         success: false,
  //         statusCode: err.response?.statusCode ?? 401,
  //         errType: 3,
  //         message: err.response?.data["message"] ?? '',
  //         response: err.response,
  //       );
  //     }
  //     if (err.response!.statusCode == 404) {
  //       return CustomResponse(
  //         success: false,
  //         statusCode: err.response?.statusCode ?? 404,
  //         errType: 0,
  //         message: err.response?.data["message"] ?? '',
  //         response: err.response?.data["message"] ?? '',
  //       );
  //     }
  //     try {
  //       return CustomResponse(
  //         success: false,
  //         statusCode: err.response?.statusCode ?? 500,
  //         errType: 2,
  //         message: (err.response!.data["errors"] as Map).values.first.first,
  //         response: err.response,
  //       );
  //     } catch (e) {
  //       return CustomResponse(
  //         success: false,
  //         statusCode: err.response?.statusCode ?? 500,
  //         errType: 2,
  //         message: err.response?.data["message"],
  //         response: err.response,
  //       );
  //     }
  //   } else if (err.type == DioExceptionType.receiveTimeout ||
  //       err.type == DioExceptionType.sendTimeout) {
  //     return CustomResponse(
  //       success: false,
  //       statusCode: err.response?.statusCode ?? 500,
  //       errType: 0,
  //       message: "poor connection check the quality of the internet",
  //       response: null,
  //     );
  //   } else {
  //     if (err.response == null) {
  //       return CustomResponse(
  //         success: false,
  //         statusCode: 402,
  //         errType: 0,
  //         message: "no connection check the quality of the internet",
  //         response: null,
  //       );
  //     }
  //     // firebaseCrashlytics.apiRecordError(
  //     //   err.response?.data,
  //     //   err.stackTrace ?? StackTrace.empty,
  //     //   "${err.requestOptions.path} (${err.requestOptions.method})",
  //     // );
  //
  //     return CustomResponse(
  //       success: false,
  //       statusCode: 402,
  //       errType: 1,
  //       message: "server error please try again later",
  //       response: null,
  //     );
  //   }
  // }

  CustomResponse<T> handleServerError<T>(DioException err) {
    if (err.type == DioExceptionType.badResponse) {
      if (err.response!.data.toString().contains("DOCTYPE") ||
          err.response!.data.toString().contains("<script>") ||
          err.response!.data["exception"] != null) {
        if (err.response!.statusCode == 404) {
          return CustomResponse(
            success: false,
            statusCode: err.response!.statusCode ?? 404,
            errType: 0,
            message: err.response!.data["message"] ?? '',
            response: err.response,
          );
        } else {
          return CustomResponse(
            success: false,
            errType: 1,
            statusCode: err.response!.statusCode ?? 500,
            message: kDebugMode
                ? "${err.response!.data}"
                : "server error please try again later",
            response: null,
          );
        }
      }
      if (err.response!.statusCode == 401) {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 401,
          errType: 3,
          message: err.response?.data["message"] ?? 'قم بتسجيل الدخول أولا',
          response: err.response,
        );
      }
      // if (err.response!.statusCode == 404) {
      //   return CustomResponse(
      //     success: false,
      //     statusCode: err.response?.statusCode ?? 404,
      //     errType: 0,
      //     message: err.response?.data["message"] ?? '',
      //     response: err.response,
      //   );
      // }
      try {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 500,
          errType: 2,
          message: (err.response!.data["errors"] as Map).values.first.first,
          response: err.response,
        );
      } catch (e) {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 500,
          errType: 2,
          message: err.response?.data["message"],
          response: err.response,
        );
      }
    } else if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return CustomResponse(
        success: false,
        statusCode: err.response?.statusCode ?? 500,
        errType: 0,
        message: "poor connection check the quality of the internet",
        response: null,
      );
    } else {
      if (err.response == null) {
        return CustomResponse(
          success: false,
          statusCode: 402,
          errType: 0,
          message: "no connection check the quality of the internet",
          response: null,
        );
      } else {
        return CustomResponse(
          success: false,
          statusCode: 402,
          errType: 1,
          message: "server error please try again later",
          response: null,
        );
      }
    }
  }

  final Map<String, String> _cashedImage = {};
  final _imageDio = Dio();
  Future<String?> imageBase64(String url) async {
    if (_cashedImage.length >= 70) {
      _cashedImage.clear();
    }
    if (_cashedImage.containsKey(url.split("/").last)) {
      return _cashedImage[url.split("/").last]!;
    }
    final result = await _imageDio.get(url,
        options: Options(responseType: ResponseType.bytes));
    if (result.statusCode == 200) {
      // final image = decodeImage(result.data);
      // if (image == null) return null;
      // final resizedImage = copyResize(image, height: height?.toInt() ?? 50, width: width?.toInt() ?? 50);
      // final imageEncoder = base64Encode(encodePng(resizedImage));
      final imageEncoder = base64Encode(result.data);
      _cashedImage
          .addAll({result.requestOptions.path.split("/").last: imageEncoder});
      return imageEncoder;
    } else {
      return null;
    }
  }

  Future<String?> _getBeaseUrl() async {
    BASE_URL = AppUrl.BASE_URL;
    // BASE_URL = "http://192.168.8.110/admin_lorim/public/api";

    // return BASE_URL;

    // const String url = "https://firebaseio.com/"
    String? url;
    // "${kDebugMode ? "test_" : ""}"
    "base_url.json";
    try {
      if (BASE_URL != null) return BASE_URL;
      final result = await _dio.get(url!,
          options: Options(
              headers: {"Accept": "application/json"},
              sendTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 5000)));
      if (result.data != null) {
        BASE_URL = result.data;
        log.red("\x1B[37m------Base url -----\x1B[0m");
        log.red("\x1B[31m$BASE_URL\x1B[0m");
        return BASE_URL;
      } else {
        throw DioException(
          requestOptions: result.requestOptions,
          response: Response(
            requestOptions: result.requestOptions,
            data: {"message": "لم نستتطع الاتصال بالسيرفر"},
          ),
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      final requestOptions = RequestOptions(path: url!);
      throw DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          data: {"message": "حدث خطآ عند الاتصال بالسيرفر"},
        ),
        type: DioExceptionType.badResponse,
      );
    }
  }

  Future<Either<CustomResponse<T>, T>> _makeRequest<T>(
      Future<Response> Function() request) async {
    if (await _networkInfo.checkConnectivity() == ConnectivityResult.none) {
      return Left(CustomResponse(
        success: false,
        statusCode: 0,
        errType: 0,
        message: AppString.noInternetConnection,
        response: null,
      ));
    } else {
      try {
        final response = await request();
        return Right(response.data);
      } on DioException catch (e) {
        return Left(handleServerError<T>(e));
      }
    }
  }
}

class CustomApiInterceptor extends Interceptor {
  LoggerDebug log;
  CustomApiInterceptor(this.log);
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.red("\x1B[37m------ Current Error Response -----\x1B[0m");
    log.red("\x1B[31m${err.response?.data}\x1B[0m");
    log.red("\x1B[37m------ Current Error StatusCode -----\x1B[0m");
    log.red("\x1B[31m${err.response?.statusCode}\x1B[0m");

    // push(NamedRoutes.i.sign_in);
    // showErrorDialogue("not find");
    return super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    log.green("------ Current Response ------");
    log.green(jsonEncode(response.data));
    log.green("------ Current StatusCode ------");
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

class CustomResponse<T> {
  bool success;
  int? errType;
  // 0 => network error
  // 1 => error from the server
  // 3 => unAuth
  // 2 => other error

  String message;
  String status;
  int statusCode;
  Response? response;
  T? data;

  CustomResponse({
    this.success = false,
    this.errType = 0,
    this.message = "",
    this.status = "",
    this.statusCode = 0,
    this.response,
    this.data,
  });
}

class CustomError extends CustomResponse {
  // int? type;
  // String? message;
  // dynamic error;

  CustomError({
    super.errType,
    super.message,
    super.statusCode,
  });
}
