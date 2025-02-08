import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

showErrorDialogue(String error) {
  showDialog(
    context: navigator.currentContext!,
    builder: (context) => ErrorAlertDialogueWidget(
      title: error,
    ),
  );
}

class ErrorAlertDialogueWidget extends StatelessWidget {
  final String title;
  const ErrorAlertDialogueWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF282F37),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        InkWell(
          child: Text("ok"),
          onTap: () => Navigator.pop(context),
        )
      ],
    );
  }
}

class ApiHelper {
  late Dio _dio;
  late LoggerDebug _logger;

  static const String baseUrl = 'http://webappkwidsoft.site/tanzeef/public/api';

  static final ApiHelper _instance = ApiHelper._internal();
  factory ApiHelper() => _instance;

  ApiHelper._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status! < 500;
      },
    ));

    // Allow insecure connections in debug mode
    if (kDebugMode) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }

    _logger = LoggerDebug(
      headColor: "\x1B[35m",
      constTitle: "API",
      enableLogs: kDebugMode,
    );

    _setupInterceptors();
  }

  // ✅ استرجاع التوكن من التخزين
  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token'); // استرجاع التوكن المخزن
    } catch (e) {
      _logger.red('Failed to get auth token: $e');
      return null;
    }
  }

  // ✅ حفظ التوكن عند تسجيل الدخول (يتم استدعاؤها بعد نجاح تسجيل الدخول)
  // Future<void> saveAuthToken(String token) async {
  //   // try {
  //   //   final prefs = await SharedPreferences.getInstance();
  //   //   await prefs.setString('auth_token', token);
  //   //   _logger.green('Auth token saved successfully');
  //   // } catch (e) {
  //   //   _logger.red('Failed to save auth token: $e');
  //   // }
  // }
  Future<void> saveAuthToken(String token, int expiry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setInt('token_expiry', expiry);
  }

  // ✅ حذف التوكن عند تسجيل الخروج
  Future<void> clearAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _logger.green('Auth token cleared');
    } catch (e) {
      _logger.red('Failed to clear auth token: $e');
    }
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add default headers
        options.headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'lang': 'ar',
        });

        _logger.cyan('Request: ${options.method} ${options.path}');
        _logger.cyan('Headers: ${options.headers}');
        _logger.cyan('Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.green('Response: ${response.statusCode}');
        _logger.green('Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _logger.red('Error: ${e.message}');
        _logger.red('Response: ${e.response?.data}');

        // Handle SSL Error specifically
        if (e.type == DioExceptionType.badCertificate) {
          _logger.red(
              'SSL Certificate Error - Consider using HTTPS or proper certificates');
        }

        return handler.next(e);
      },
    ));

    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        // Здесь можно добавить логику для обновления токена
        // if (await _shouldRefreshToken()) {
        //   await _refreshToken();
        // }
        if (await _shouldRefreshToken()) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            final newToken = await _getAuthToken();
            if (newToken != null) {
              options.headers['Authorization'] = 'Bearer $newToken';
            }
          }
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Обработка ошибки авторизации
          // await _handleUnauthorized();
          // return handler.resolve(await _retry(e.requestOptions));
          final refreshed = await _refreshToken();
          if (refreshed) {
            return handler.resolve(await _retry(e.requestOptions));
          } else {
            _handleUnauthorized();
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final newToken = await _getAuthToken();
    if (newToken == null) {
      throw DioException(
        requestOptions: requestOptions,
        error: "Unauthorized: No token available for retry",
      );
    }

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
    );

    return await _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // ✅ استرجاع وقت انتهاء التوكن
  Future<int?> _getTokenExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('token_expiry');
  }

  Future<bool> _shouldRefreshToken() async {
    final expiry = await _getTokenExpiry();
    if (expiry == null) return false;

    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiry - currentTime <
        300; // إذا بقي أقل من 5 دقائق على انتهاء التوكن
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken =
          await _getAuthToken(); // استخدم توكن التحديث إذا كان متاحًا
      if (refreshToken == null) return false;

      final response = await _dio.post(
        "/auth/refresh", // ✅ نقطة تحديث التوكن
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final newToken = response.data["token"];
        final newExpiry = response.data["expiry"]; // وقت الانتهاء الجديد
        await saveAuthToken(newToken, newExpiry);
        return true;
      }
      return false;
    } catch (e) {
      _logger.red('Failed to refresh token: $e');
      return false;
    }
  }

  void _handleUnauthorized() async {
    await clearAuthToken();
    showErrorDialogue("انتهت جلسة تسجيل الدخول، يُرجى تسجيل الدخول مرة أخرى.");
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  void setLanguage(String languageCode) {
    _dio.options.headers['Accept-Language'] = languageCode;
  }

  dynamic _prepareRequestBody(dynamic body) {
    if (body != null &&
        body is Map<String, dynamic> &&
        body.values.any((value) => value is MultipartFile)) {
      return FormData.fromMap(body);
    } else if (body is FormData) {
      return body;
    } else if (body is Map) {
      return jsonEncode(body);
    } else {
      return body;
    }
  }

  Map<String, dynamic> _cleanParams(Map<String, dynamic>? params) {
    if (params == null) return {};
    return Map.from(params)
      ..removeWhere((key, value) => value == null || value == "");
  }

  Future<ApiResponse<T>> request<T>({
    required String method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool requiresAuth = false,
  }) async {
    try {
      final cleanedParams = _cleanParams(queryParameters);
      final preparedBody = _prepareRequestBody(data);

      final options = Options(
        method: method,
        headers: {
          ...?headers,
          'Accept': 'application/json',
          if (preparedBody is! FormData) 'Content-Type': 'application/json',
        },
      );

      // ✅ إضافة التوكن تلقائيًا إذا كان الطلب يتطلب المصادقة
      if (requiresAuth) {
        final token = await _getAuthToken();
        if (token != null) {
          options.headers!['Authorization'] = 'Bearer $token';
        } else {
          showErrorDialogue("يجب عليك تسجيل الدخول للمتابعة.");
          return ApiResponse.fromError(DioException(
            requestOptions: RequestOptions(path: path),
            error: "Unauthorized: No token found",
          ));
        }
      }

      // if (requiresAuth) {
      //   // Добавьте здесь логику для добавления токена авторизации
      //   // options.headers['Authorization'] = 'Bearer ${await _getAuthToken()}';
      // }

      final response = await _dio.request(
        path,
        data: preparedBody,
        queryParameters: cleanedParams,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.fromResponse(response, fromJson);
    } on DioException catch (e) {
      _logger.red('DioException in request: ${e.message}');
      // ✅ التحقق من انقطاع الإنترنت
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.unknown) {
        showErrorDialogue("تحقق من اتصالك بالإنترنت");
      } else if (e.response?.statusCode == 401) {
        showErrorDialogue("جلسة الدخول انتهت، يرجى تسجيل الدخول مرة أخرى.");
      }
      // ✅ خطأ عام
      else {
        showErrorDialogue("حدث خطأ غير متوقع. نحن نعمل على إصلاحه!");
      }
      return ApiResponse.fromError(e);
    } catch (e) {
      _logger.red('Unexpected error in request: $e');
      return ApiResponse.fromError(DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
      ));
    }
  }

  Future<ApiResponse<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      return await request(
        method: 'GET',
        path: "$baseUrl/$path",
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        requiresAuth: requiresAuth,
      );
    } catch (e) {
      _logger.red('Error in GET request: $e');
      return ApiResponse.fromError(DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
      ));
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool requiresAuth = false,
  }) async {
    try {
      return await request(
        method: 'POST',
        path: "$baseUrl/$path",
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        requiresAuth: requiresAuth,
      );
    } catch (e) {
      _logger.red('Error in POST request: $e');
      return ApiResponse.fromError(DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
      ));
    }
  }

  Future<ApiResponse<T>> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      return await request(
        method: 'PUT',
        path: "$baseUrl/$path",
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        requiresAuth: requiresAuth,
      );
    } catch (e) {
      _logger.red('Error in PUT request: $e');
      return ApiResponse.fromError(DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
      ));
    }
  }

  Future<ApiResponse<T>> delete<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      return await request(
        method: 'DELETE',
        path: "$baseUrl/$path",
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        requiresAuth: requiresAuth,
      );
    } catch (e) {
      _logger.red('Error in DELETE request: $e');
      return ApiResponse.fromError(DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
      ));
    }
  }

  Future<ApiResponse<T>> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      return await request(
        method: 'PATCH',
        path: "$baseUrl/$path",
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        fromJson: fromJson,
        requiresAuth: requiresAuth,
      );
    } catch (e) {
      _logger.red('Error in PATCH request: $e');
      return ApiResponse.fromError(DioException(
        requestOptions: RequestOptions(path: path),
        error: e,
      ));
    }
  }
}

class LoggerDebug {
  LoggerDebug({this.headColor = "", this.constTitle, this.enableLogs = true});
  String headColor;
  String? constTitle;
  bool enableLogs;

  void logMessage(String message, String color, [String? title]) {
    if (enableLogs) {
      developer.log(
        "$color$message\x1B[0m",
        name: "$headColor♥ ${title ?? constTitle ?? ""} ♥",
        level: 2000,
      );
    }
  }

  void red(String message, [String? title]) =>
      logMessage(message, "\x1B[31m", title);
  void green(String message, [String? title]) =>
      logMessage(message, "\x1B[32m", title);
  void yellow(String message, [String? title]) =>
      logMessage(message, "\x1B[33m", title);
  void cyan(String message, [String? title]) =>
      logMessage(message, "\x1B[36m", title);
}

class ApiResponse<T> {
  final bool success;
  final int? errType;
  final String msg;
  final int statusCode;
  final T? data;
  final Response? response;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.errType,
    required this.msg,
    required this.statusCode,
    this.data,
    this.response,
    this.error,
  });

  factory ApiResponse.fromResponse(
      Response response, T Function(dynamic)? fromJson) {
    try {
      final isSuccess = response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;

      // Handle empty or null response data
      dynamic responseData = response.data;
      if (responseData is String && responseData.isEmpty) {
        responseData = {};
      }

      return ApiResponse(
        success: isSuccess,
        msg: responseData["message"] ??
            (isSuccess ? "Request successful" : "Request failed"),
        statusCode: response.statusCode ?? 0,
        data: fromJson != null && responseData != null
            ? fromJson(responseData)
            : responseData,
        response: response,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        msg: "Failed to parse response: $e",
        statusCode: response.statusCode ?? 0,
        response: response,
        error: e,
      );
    }
  }

  factory ApiResponse.fromError(DioException error) {
    String errorMessage = error.message ?? "An error occurred";

    // Enhance error messages for common issues
    switch (error.type) {
      case DioExceptionType.badCertificate:
        errorMessage =
            "SSL Certificate Error - Security issue with the connection";
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage =
            "Connection timed out - Please check your internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Server is taking too long to respond";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Request timed out while sending data";
        break;
      default:
        if (error.response?.statusCode == 404) {
          errorMessage = "Resource not found";
        }
    }

    return ApiResponse(
      success: false,
      errType: error.type.index,
      msg: errorMessage,
      statusCode: error.response?.statusCode ?? 0,
      error: error,
    );
  }
}

// import 'package:dio/dio.dart';
// import 'dart:developer' as developer;
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
//
// import '../AppUrl/url.dart';
//
// class ApiHelper {
//   late Dio _dio;
//   late LoggerDebug _logger;
//
//   static final String baseUrl = "${AppUrl.BASE_URL}";
//
//   static final ApiHelper _instance = ApiHelper._internal();
//   factory ApiHelper() => _instance;
//
//   ApiHelper._internal() {
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       sendTimeout: const Duration(seconds: 30),
//     ));
//
//     _logger = LoggerDebug(
//       headColor: "\x1B[35m",
//       constTitle: "API",
//       enableLogs: kDebugMode,
//     );
//
//     _setupInterceptors();
//   }
//
//   void _setupInterceptors() {
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         _logger.cyan('Request: ${options.method} ${options.path}');
//         _logger.cyan('Headers: ${options.headers}');
//         _logger.cyan('Data: ${options.data}');
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         _logger.green('Response: ${response.statusCode}');
//         _logger.green('Data: ${response.data}');
//         return handler.next(response);
//       },
//       onError: (DioException e, handler) {
//         _logger.red('Error: ${e.message}');
//         _logger.red('Response: ${e.response?.data}');
//         return handler.next(e);
//       },
//     ));
//
//     _dio.interceptors.add(QueuedInterceptorsWrapper(
//       onRequest: (options, handler) async {
//         // Здесь можно добавить логику для обновления токена
//         // if (await _shouldRefreshToken()) {
//         //   await _refreshToken();
//         // }
//         return handler.next(options);
//       },
//       onError: (DioException e, handler) async {
//         if (e.response?.statusCode == 401) {
//           // Обработка ошибки авторизации
//           // await _handleUnauthorized();
//           // return handler.resolve(await _retry(e.requestOptions));
//         }
//         return handler.next(e);
//       },
//     ));
//   }
//
//   void setAuthToken(String token) {
//     _dio.options.headers['Authorization'] = 'Bearer $token';
//   }
//
//   void setBaseUrl(String url) {
//     _dio.options.baseUrl = url;
//   }
//
//   void setLanguage(String languageCode) {
//     _dio.options.headers['Accept-Language'] = languageCode;
//   }
//
//   dynamic _prepareRequestBody(dynamic body) {
//     if (body != null &&
//         body is Map<String, dynamic> &&
//         body.values.any((value) => value is MultipartFile)) {
//       return FormData.fromMap(body);
//     } else if (body is FormData) {
//       return body;
//     } else if (body is Map) {
//       return jsonEncode(body);
//     } else {
//       return body;
//     }
//   }
//
//   Map<String, dynamic> _cleanParams(Map<String, dynamic>? params) {
//     if (params == null) return {};
//     return Map.from(params)
//       ..removeWhere((key, value) => value == null || value == "");
//   }
//
//   Future<ApiResponse<T>> request<T>({
//     required String method,
//     required String path,
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     T Function(dynamic)? fromJson,
//     void Function(int, int)? onSendProgress,
//     void Function(int, int)? onReceiveProgress,
//     bool requiresAuth = false,
//   }) async {
//     try {
//       final cleanedParams = _cleanParams(queryParameters);
//       final preparedBody = _prepareRequestBody(data);
//
//       final options = Options(
//         method: method,
//         headers: {
//           ...?headers,
//           'Accept': 'application/json',
//           if (preparedBody is! FormData) 'Content-Type': 'application/json',
//         },
//       );
//
//       if (requiresAuth) {
//         // Добавьте здесь логику для добавления токена авторизации
//         // options.headers['Authorization'] = 'Bearer ${await _getAuthToken()}';
//       }
//
//       final response = await _dio.request(
//         path,
//         data: preparedBody,
//         queryParameters: cleanedParams,
//         options: options,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return ApiResponse.fromResponse(response, fromJson);
//     } on DioException catch (e) {
//       _logger.red('DioException in request: ${e.message}');
//       return ApiResponse.fromError(e);
//     } catch (e) {
//       _logger.red('Unexpected error in request: $e');
//       return ApiResponse.fromError(DioException(
//         requestOptions: RequestOptions(path: path),
//         error: e,
//       ));
//     }
//   }
//
//   Future<ApiResponse> get({
//     required String path,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     dynamic Function(dynamic)? fromJson,
//     bool requiresAuth = false,
//   }) async {
//     try {
//       return await request(
//         method: 'GET',
//         path: "$baseUrl/$path",
//         queryParameters: queryParameters,
//         headers: headers,
//         fromJson: fromJson,
//         requiresAuth: requiresAuth,
//       );
//     } catch (e) {
//       _logger.red('Error in GET request: $e');
//       return ApiResponse.fromError(DioException(
//         requestOptions: RequestOptions(path: path),
//         error: e,
//       ));
//     }
//   }
//
//   Future<ApiResponse> post({
//     required String path,
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     dynamic Function(dynamic)? fromJson,
//     void Function(int, int)? onSendProgress,
//     void Function(int, int)? onReceiveProgress,
//     bool requiresAuth = false,
//   }) async {
//     try {
//       return await request(
//         method: 'POST',
//         path: "$baseUrl/$path",
//         data: data,
//         queryParameters: queryParameters,
//         headers: headers,
//         fromJson: fromJson,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//         requiresAuth: requiresAuth,
//       );
//     } catch (e) {
//       _logger.red('Error in POST request: $e');
//       return ApiResponse.fromError(DioException(
//         requestOptions: RequestOptions(path: path),
//         error: e,
//       ));
//     }
//   }
//
//   Future<ApiResponse<T>> put<T>({
//     required String path,
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     T Function(dynamic)? fromJson,
//     bool requiresAuth = false,
//   }) async {
//     try {
//       return await request(
//         method: 'PUT',
//         path: "$baseUrl/$path",
//         data: data,
//         queryParameters: queryParameters,
//         headers: headers,
//         fromJson: fromJson,
//         requiresAuth: requiresAuth,
//       );
//     } catch (e) {
//       _logger.red('Error in PUT request: $e');
//       return ApiResponse.fromError(DioException(
//         requestOptions: RequestOptions(path: path),
//         error: e,
//       ));
//     }
//   }
//
//   Future<ApiResponse<T>> delete<T>({
//     required String path,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     T Function(dynamic)? fromJson,
//     bool requiresAuth = false,
//   }) async {
//     try {
//       return await request(
//         method: 'DELETE',
//         path: "$baseUrl/$path",
//         queryParameters: queryParameters,
//         headers: headers,
//         fromJson: fromJson,
//         requiresAuth: requiresAuth,
//       );
//     } catch (e) {
//       _logger.red('Error in DELETE request: $e');
//       return ApiResponse.fromError(DioException(
//         requestOptions: RequestOptions(path: path),
//         error: e,
//       ));
//     }
//   }
//
//   Future<ApiResponse<T>> patch<T>({
//     required String path,
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//     T Function(dynamic)? fromJson,
//     bool requiresAuth = false,
//   }) async {
//     try {
//       return await request(
//         method: 'PATCH',
//         path: "$baseUrl/$path",
//         data: data,
//         queryParameters: queryParameters,
//         headers: headers,
//         fromJson: fromJson,
//         requiresAuth: requiresAuth,
//       );
//     } catch (e) {
//       _logger.red('Error in PATCH request: $e');
//       return ApiResponse.fromError(DioException(
//         requestOptions: RequestOptions(path: path),
//         error: e,
//       ));
//     }
//   }
// }
//
// class LoggerDebug {
//   LoggerDebug({this.headColor = "", this.constTitle, this.enableLogs = true});
//   String headColor;
//   String? constTitle;
//   bool enableLogs;
//
//   void logMessage(String message, String color, [String? title]) {
//     if (enableLogs) {
//       developer.log(
//         "$color$message\x1B[0m",
//         name: "$headColor♥ ${title ?? constTitle ?? ""} ♥",
//         level: 2000,
//       );
//     }
//   }
//
//   void red(String message, [String? title]) =>
//       logMessage(message, "\x1B[31m", title);
//   void green(String message, [String? title]) =>
//       logMessage(message, "\x1B[32m", title);
//   void yellow(String message, [String? title]) =>
//       logMessage(message, "\x1B[33m", title);
//   void cyan(String message, [String? title]) =>
//       logMessage(message, "\x1B[36m", title);
// }
//
// class ApiResponse<T> {
//   final bool success;
//   final int? errType;
//   final String msg;
//   final int statusCode;
//   final T? data;
//   final Response? response;
//   final dynamic error;
//
//   ApiResponse({
//     required this.success,
//     this.errType,
//     required this.msg,
//     required this.statusCode,
//     this.data,
//     this.response,
//     this.error,
//   });
//
//   factory ApiResponse.fromResponse(
//       Response response, T Function(dynamic)? fromJson) {
//     final isSuccess = response.statusCode != null &&
//         response.statusCode! >= 200 &&
//         response.statusCode! < 300;
//
//     return ApiResponse(
//       success: isSuccess,
//       msg: response.data["message"] ??
//           (isSuccess ? "Request successful" : "Request failed"),
//       statusCode: response.statusCode ?? 0,
//       data: fromJson != null ? fromJson(response.data) : response.data,
//       response: response,
//     );
//   }
//
//   factory ApiResponse.fromError(DioException error) {
//     return ApiResponse(
//       success: false,
//       errType: error.type.index,
//       msg: error.message ?? "An error occurred",
//       statusCode: error.response?.statusCode ?? 0,
//       error: error,
//     );
//   }
// }
