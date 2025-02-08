import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';

import '../AppUrl/url.dart';

class LoggerDebug {
  LoggerDebug({this.headColor = "", this.constTitle, this.enableLogs = true});
  String headColor;
  String? constTitle;
  bool enableLogs;

  void logMessage(String message, String color, [String? title]) {
    if (enableLogs) {
      log(
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
      Response response, T Function(dynamic)? callback) {
    return ApiResponse(
      success: response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300,
      msg: response.data["message"] ?? "Request successful",
      statusCode: response.statusCode ?? 0,
      data: callback != null ? callback(response.data) : null,
      response: response,
    );
  }

  factory ApiResponse.fromError(DioException error) {
    return DioErrorHandler.handleDioError<T>(error);
  }
}

class UrlEncrypter {
  final Key key;
  final IV iv;

  UrlEncrypter(String encryptionKey, String initializationVector)
      : key = Key.fromUtf8(encryptionKey),
        iv = IV.fromUtf8(initializationVector);

  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.from64(encryptedText), iv: iv);
  }
}

class ApiService {
  static final i = ApiService._();

  final Dio _dio;
  final LoggerDebug log;
  final UrlEncrypter urlEncrypter;
  final String baseUrl;

  ApiService._()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 5000),
          receiveTimeout: const Duration(seconds: 5000),
        )),
        log = LoggerDebug(),
        urlEncrypter = UrlEncrypter("defaultKey1234567", "defaultIV12345678"),
        baseUrl = AppUrl.BASE_URL;

  void logRequest(RequestOptions options) {
    log.cyan("Method: ${options.method}");
    log.cyan("Path: ${options.path}");
    log.yellow("Headers: ${options.headers}");
    log.green("Query Parameters: ${options.queryParameters}");
    log.green("Data: ${options.data}");
  }

  Future<ApiResponse<T>> _makeRequest<T>(Future<Response> Function() request,
      {T Function(dynamic)? callback}) async {
    try {
      final response = await request();
      logRequest(response.requestOptions);
      log.green("Response Data: ${response.data}");
      return ApiResponse.fromResponse(response, callback);
    } on DioException catch (e) {
      log.red("Error occurred: ${e.message}");
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> getFromServer({
    required String? url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (params != null) {
        print(params);
        params.removeWhere(
          (key, value) => params[key] == null || params[key] == "",
        );
      }
      return _makeRequest(
        () => _dio.get(
          "$baseUrl/$url",
          queryParameters: params,
          options: Options(
            headers: {
              ...?headers,
              'Accept': 'application/json',
              "lang": "ar",
            },
          ),
        ),
      );
    } on DioException catch (err) {
      return DioErrorHandler.handleDioError(err);
    }
  }

  Future<ApiResponse> sendToServer({
    required String? url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (body != null) {
        body.removeWhere(
          (key, value) => body[key] == null || body[key] == "",
        );
      }
      final preparedBody = _prepareRequestBody(body);
      return _makeRequest(
        () => _dio.post(
          "$baseUrl/$url",
          data: preparedBody,
          onSendProgress: (received, total) {
            log.cyan(
                "Upload progress: ${(received / total * 100).toStringAsFixed(2)}%");
          },
          queryParameters: params,
          options: Options(
            headers: headers,
            contentType: body != null &&
                    body.values.any((value) => value is MultipartFile)
                ? Headers.formUrlEncodedContentType
                : Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        ),
      );
    } on DioException catch (err) {
      return DioErrorHandler.handleDioError(err);
    }
  }

  Future<ApiResponse<T>> postRequest<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    Map<String, dynamic>? params,
    T Function(dynamic)? callback,
    bool useCache = false,
    Duration cacheDuration = const Duration(minutes: 10),
  }) async {
    final encryptedUrl = urlEncrypter.encrypt("$baseUrl/$endpoint");
    final preparedBody = _prepareRequestBody(body);

    if (useCache) {
      final cachedData = _getFromCache(encryptedUrl);
      if (cachedData != null) {
        log.green("Using cached data for $endpoint");
        return ApiResponse(
          success: true,
          msg: "Cached data",
          statusCode: 200,
          data: callback != null ? callback(cachedData) : cachedData,
        );
      }
    }

    return _makeRequest<T>(
      () => _dio.post(
        encryptedUrl,
        data: preparedBody,
        onSendProgress: (received, total) {
          log.cyan(
              "Upload progress: ${(received / total * 100).toStringAsFixed(2)}%");
        },
        queryParameters: params,
        options: Options(
          headers: headers,
          contentType:
              body != null && body.values.any((value) => value is MultipartFile)
                  ? Headers.formUrlEncodedContentType
                  : Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      ),
      callback: (data) {
        if (useCache) {
          _saveToCache(encryptedUrl, data, cacheDuration);
        }
        return callback != null ? callback(data) : data;
      },
    );
  }

  Future<ApiResponse<T>> putRequest<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    T Function(dynamic)? callback,
    bool useCache = false,
    Duration cacheDuration = const Duration(minutes: 10),
  }) async {
    final encryptedUrl = urlEncrypter.encrypt("$baseUrl/$endpoint");
    final preparedBody = _prepareRequestBody(body);

    if (useCache) {
      final cachedData = _getFromCache(encryptedUrl);
      if (cachedData != null) {
        log.green("Using cached data for $endpoint");
        return ApiResponse(
          success: true,
          msg: "Cached data",
          statusCode: 200,
          data: callback != null ? callback(cachedData) : cachedData,
        );
      }
    }

    return _makeRequest<T>(
      () => _dio.put(
        encryptedUrl,
        data: preparedBody,
        options: Options(headers: headers),
      ),
      callback: (data) {
        if (useCache) {
          _saveToCache(encryptedUrl, data, cacheDuration);
        }
        return callback != null ? callback(data) : data;
      },
    );
  }

  Future<ApiResponse<T>> deleteRequest<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    T Function(dynamic)? callback,
    bool useCache = false,
    Duration cacheDuration = const Duration(minutes: 10),
  }) async {
    final encryptedUrl = urlEncrypter.encrypt("$baseUrl/$endpoint");
    final preparedBody = _prepareRequestBody(body);

    if (useCache) {
      final cachedData = _getFromCache(encryptedUrl);
      if (cachedData != null) {
        log.green("Using cached data for $endpoint");
        return ApiResponse(
          success: true,
          msg: "Cached data",
          statusCode: 200,
          data: callback != null ? callback(cachedData) : cachedData,
        );
      }
    }

    return _makeRequest<T>(
      () => _dio.delete(
        encryptedUrl,
        data: preparedBody,
        options: Options(headers: headers),
      ),
      callback: (data) {
        if (useCache) {
          _saveToCache(encryptedUrl, data, cacheDuration);
        }
        return callback != null ? callback(data) : data;
      },
    );
  }

  dynamic _getFromCache(String key) {
    // Implement caching logic (e.g., using a local database or in-memory storage)
    return null;
  }

  void _saveToCache(String key, dynamic data, Duration duration) {
    // Implement caching logic to store data with an expiration time
    log.green("Data cached for $key");
  }

  dynamic _prepareRequestBody(dynamic body) {
    if (body != null &&
        body is Map<String, dynamic> &&
        body.values.any((value) => value is MultipartFile)) {
      return FormData.fromMap(body);
    } else {
      return jsonEncode(body ?? {});
    }
  }
}

class DioErrorHandler {
  static ApiResponse<T> handleDioError<T>(DioException e) {
    String errorMessage;
    int errorType;

    if (e.response?.data is Map &&
        e.response?.data['message'] == "Account Suspended") {
      errorMessage = "Account Suspended";
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
            errorMessage = "Connection timeout. Check your network.";
            errorType = 0;
            break;
          case DioExceptionType.badResponse:
            errorMessage = "Invalid response from server.";
            errorType = 1;
            break;
          case DioExceptionType.cancel:
            errorMessage = "Request was cancelled.";
            errorType = 2;
            break;
          case DioExceptionType.connectionError:
            errorMessage = "No internet connection.";
            errorType = 0;
            break;
          default:
            errorMessage = "Unknown error occurred.";
            errorType = 2;
        }
      }
    }

    return ApiResponse<T>(
      success: false,
      errType: errorType,
      msg: errorMessage,
      statusCode: e.response?.statusCode ?? 0,
      response: e.response,
    );
  }
}

// /// and this is testing the response status code and the error message
// /// and this is testing the response status code and the error message
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'api_service.dart';
// import 'api_response.dart';
//
// enum DataEvent { fetch, add, update, delete }
//
// class DataState<T> {
//   final bool isLoading;
//   final List<T>? data;
//   final String? error;
//
//   DataState({this.isLoading = false, this.data, this.error});
// }
//
// class DataBloc<T> extends Bloc<DataEvent, DataState<T>> {
//   final ApiService apiService;
//
//   DataBloc(this.apiService) : super(DataState<T>()) {
//     on<DataEvent>((event, emit) async {
//       switch (event) {
//         case DataEvent.fetch:
//           await _fetchData(emit);
//           break;
//         case DataEvent.add:
//           await _addData(emit);
//           break;
//         case DataEvent.update:
//           await _updateData(emit);
//           break;
//         case DataEvent.delete:
//           await _deleteData(emit);
//           break;
//       }
//     });
//   }
//
//   Future<void> _fetchData(Emitter<DataState<T>> emit) async {
//     emit(DataState(isLoading: true));
//     final response = await apiService.getRequest<List<T>>(
//       'endpoint/fetch',
//       callback: (json) => (json as List).map((item) => item as T).toList(),
//     );
//     if (response.success) {
//       emit(DataState(data: response.data));
//     } else {
//       emit(DataState(error: response.msg));
//     }
//   }
//
//   Future<void> _addData(Emitter<DataState<T>> emit) async {
//     emit(DataState(isLoading: true));
//     final response = await apiService.postRequest<T>(
//       'endpoint/add',
//       body: {'key': 'value'}, // Replace with your actual data
//       callback: (json) => json as T,
//     );
//     if (response.success) {
//       await _fetchData(emit);
//     } else {
//       emit(DataState(error: response.msg));
//     }
//   }
//
//   Future<void> _updateData(Emitter<DataState<T>> emit) async {
//     emit(DataState(isLoading: true));
//     final response = await apiService.putRequest<T>(
//       'endpoint/update/1', // Replace with your actual ID
//       body: {'key': 'updatedValue'},
//       callback: (json) => json as T,
//     );
//     if (response.success) {
//       await _fetchData(emit);
//     } else {
//       emit(DataState(error: response.msg));
//     }
//   }
//
//   Future<void> _deleteData(Emitter<DataState<T>> emit) async {
//     emit(DataState(isLoading: true));
//     final response = await apiService.deleteRequest<T>(
//       'endpoint/delete/1', // Replace with your actual ID
//     );
//     if (response.success) {
//       await _fetchData(emit);
//     } else {
//       emit(DataState(error: response.msg));
//     }
//   }
// }
//
//
//
// ////////////////////////////////////////////////////////////////
// ///import 'package:get_it/get_it.dart';
//
// import 'package:get_it/get_it.dart';
// import 'api_service.dart';
// import 'data_bloc.dart';
//
// final getIt = GetIt.instance;
//
// void setupDependencies() {
//   getIt.registerLazySingleton(() => ApiService.i);
//   getIt.registerFactory(() => DataBloc(getIt<ApiService>()));
// }
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'data_bloc.dart';
// import 'setup_dependencies.dart';
//
// void main() {
//   setupDependencies();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DataScreen<String>(),
//     );
//   }
// }
//
// class DataScreen<T> extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<DataBloc<T>>()..add(DataEvent.fetch),
//       child: Scaffold(
//         appBar: AppBar(title: Text('Data Management')),
//         body: BlocBuilder<DataBloc<T>, DataState<T>>(
//           builder: (context, state) {
//             if (state.isLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state.error != null) {
//               return Center(child: Text('Error: ${state.error}'));
//             } else if (state.data != null) {
//               return ListView.builder(
//                 itemCount: state.data!.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(state.data![index].toString()),
//                   );
//                 },
//               );
//             } else {
//               return Center(child: Text('No Data Found'));
//             }
//           },
//         ),
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               onPressed: () => context.read<DataBloc<T>>().add(DataEvent.add),
//               child: Icon(Icons.add),
//             ),
//             SizedBox(height: 10),
//             FloatingActionButton(
//               onPressed: () => context.read<DataBloc<T>>().add(DataEvent.update),
//               child: Icon(Icons.edit),
//             ),
//             SizedBox(height: 10),
//             FloatingActionButton(
//               onPressed: () => context.read<DataBloc<T>>().add(DataEvent.delete),
//               child: Icon(Icons.delete),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
