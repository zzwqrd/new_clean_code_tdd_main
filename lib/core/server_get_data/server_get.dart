import 'package:dio/dio.dart';

import '../AppUrl/url.dart';
import 'app_exception.dart';
import 'custom_response.dart';
import 'loger.dart';

class NetworkServers {
  final _dio = Dio();
  final LoggerDebug log =
      LoggerDebug(headColor: LogColors.red, constTitle: "Server Gate Logger");
  static final i = NetworkServers._();
  String? BASE_URL;

  NetworkServers._() {
    _addInterceptors();
    _addLoggingInterceptor();
  }

  void _addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Authorization'] = 'Bearer YOUR_TOKEN';
        log.red(
            "Request: ${options.method} ${options.path}, Data: ${options.data}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log.red('Response: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        log.red('Error occurred: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  void _addLoggingInterceptor() {
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<String?> _getBaseUrl() async {
    BASE_URL = AppUrl.BASE_URL;
    String? url = "base_url.json";

    try {
      if (BASE_URL != null) return BASE_URL;
      final result = await _dio.get(
        url!,
        options: Options(
          headers: {"Accept": "application/json"},
          sendTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
        ),
      );
      if (result.data != null) {
        BASE_URL = result.data;
        log.red("\x1B[37m------Base url -----\x1B[0m");
        log.red("\x1B[31m$BASE_URL\x1B[0m");
        return BASE_URL;
      } else {
        log.red('Error: Failed to fetch base URL');
        throw DioException(
          requestOptions: result.requestOptions,
          response: Response(
            requestOptions: result.requestOptions,
            data: {"message": "لم نستطع الاتصال بالسيرفر"},
          ),
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      final requestOptions = RequestOptions(path: url!);
      log.red('Error: Failed to connect to server');
      throw DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          data: {"message": "حدث خطأ عند الاتصال بالسيرفر"},
        ),
        type: DioExceptionType.badResponse,
      );
    }
  }

  // GET Request
  Future<CustomResponse> getRequest(String endpoint) async {
    _getBaseUrl();
    try {
      final response = await _dio.get(
        endpoint.startsWith("http") ? endpoint : "$BASE_URL/$endpoint",
      );
      log.red("GET Request Successful: $endpoint, Response: ${response.data}");
      return CustomResponse.fromJson(response.data);
    } on DioException catch (e) {
      log.red("GET Request Failed: $endpoint, Error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // POST Request
  Future<CustomResponse> postRequest(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      log.red("POST Request Successful: $endpoint, Data: ${response.data}");
      return CustomResponse.fromJson(response.data);
    } on DioException catch (e) {
      log.red("POST Request Failed: $endpoint, Error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // PUT Request
  Future<CustomResponse> putRequest(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      log.red("PUT Request Successful: $endpoint, Data: ${response.data}");
      return CustomResponse.fromJson(response.data);
    } on DioException catch (e) {
      log.red("PUT Request Failed: $endpoint, Error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // DELETE Request
  Future<CustomResponse> deleteRequest(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      log.red("DELETE Request Successful: $endpoint, Data: ${response.data}");
      return CustomResponse.fromJson(response.data);
    } on DioException catch (e) {
      log.red("DELETE Request Failed: $endpoint, Error: ${e.message}");
      throw _handleDioError(e);
    }
  }

  // إدارة أخطاء DioException
  AppException _handleDioError(DioException e) {
    log.red("Error occurred in request: ${e.message}");
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return TimeoutException(
          'Connection Timeout: The server took too long to respond. Please try again.',
          code: 408,
        );
      case DioExceptionType.sendTimeout:
        return TimeoutException(
          'Send Timeout: Unable to send request in time. Please try again.',
          code: 408,
        );
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Receive Timeout: The server took too long to respond. Please try again.',
          code: 408,
        );
      case DioExceptionType.badResponse:
        if (e.response != null) {
          final statusCode = e.response!.statusCode!;
          return _handleStatusCode(statusCode, e.response!.data);
        }
        return ServerException(
          'Unknown Server Error: No response received from server.',
          code: 500,
        );
      case DioExceptionType.cancel:
        return AppException(
          'Request Cancelled: The request was cancelled by the user or server.',
          code: 499,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          'Network Error: Unable to connect to the server. Please check your internet connection.',
          code: 503,
        );
      case DioExceptionType.unknown:
        return UnknownException(
          'Unknown Error: An unexpected error occurred. Please try again.',
          code: 500,
        );
      default:
        return UnknownException(
          'Unexpected Error: An unexpected error occurred. Please contact support.',
          code: 500,
        );
    }
  }

  // استخدام handleStatusCode لإدارة الاستجابات الخاطئة من السيرفر
  AppException _handleStatusCode(int statusCode, dynamic data) {
    log.red("Handling status code: $statusCode");
    switch (statusCode) {
      case 400:
        return BadRequestException(
          'Bad Request: The server could not understand the request. Please check your input.',
          code: 400,
          details: _extractDetails(data),
        );
      case 401:
        return UnauthorizedException(
          'Unauthorized: Please check your credentials.',
          code: 401,
          details: _extractDetails(data),
        );
      case 403:
        return UnauthorizedException(
          'Forbidden: You do not have permission to access this resource.',
          code: 403,
          details: _extractDetails(data),
        );
      case 404:
        return NotFoundException(
          'Not Found: The requested resource could not be found.',
          code: 404,
          details: _extractDetails(data),
        );
      case 422:
        return ValidationException(
          'Validation Error: The data provided failed validation. Please check and try again.',
          code: 422,
          details: _extractDetails(data),
        );
      case 500:
        return ServerException(
          'Internal Server Error: Something went wrong on the server.',
          code: 500,
          details: _extractDetails(data),
        );
      case 502:
        return ServerException(
          'Bad Gateway: The server received an invalid response from the upstream server.',
          code: 502,
          details: _extractDetails(data),
        );
      case 503:
        return ServerException(
          'Service Unavailable: The server is temporarily unavailable. Please try again later.',
          code: 503,
          details: _extractDetails(data),
        );
      default:
        return ServerException(
          'Unexpected Server Error: An unexpected error occurred on the server.',
          code: statusCode,
          details: _extractDetails(data),
        );
    }
  }

  String? _extractDetails(dynamic data) {
    if (data != null &&
        data is Map<String, dynamic> &&
        data.containsKey('message')) {
      return data['message'];
    }
    return 'No additional details provided';
  }
}
