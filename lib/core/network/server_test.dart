// import 'dart:convert';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
//
// import '../error/dio_error_handler.dart';
// import '../utils/app_string.dart';
// import '../utils/loger.dart';
// import 'api_interceptor.dart';
// import 'custom_response.dart';
// import 'handle_error.dart';
// import 'network_info.dart';
//
// class NetworkService {
//   String? _baseUrl;
//   final Dio _dio;
//   final LoggerDebug log;
//   final NetworkInfo networkInfo;
//   static const Duration _timeoutDuration = Duration(milliseconds: 5000);
//
//   static final instance = NetworkService._(
//     log: LoggerDebug(
//       headColor: LogColors.red,
//       constTitle: "Server Gate Logger",
//     ),
//     networkInfo: NetworkInfo(Connectivity()),
//   );
//
//   NetworkService._({
//     required this.log,
//     required this.networkInfo,
//   }) : _dio = Dio() {
//     addInterceptors();
//     _getBaseUrl();
//   }
//
//   void addInterceptors() {
//     _dio.interceptors.add(CustomApiInterceptor(log));
//   }
//
//   Future<String?> _getBaseUrl() async {
//     _baseUrl = "https://makeup-api.herokuapp.com/api";
//     String? url;
//     try {
//       if (_baseUrl != null) return _baseUrl;
//       final result = await _dio.get(
//         url!,
//         options: Options(
//           headers: {"Accept": "application/json"},
//           sendTimeout: const Duration(milliseconds: 5000),
//           receiveTimeout: const Duration(milliseconds: 5000),
//         ),
//       );
//       if (result.data != null) {
//         _baseUrl = result.data;
//         log.red("------Base url -----\x1B[31m$_baseUrl\x1B[0m");
//         return _baseUrl;
//       } else {
//         throw DioException(
//           requestOptions: result.requestOptions,
//           response: Response(
//             requestOptions: result.requestOptions,
//             data: {"message": "لم نستتطع الاتصال بالسيرفر"},
//           ),
//           type: DioExceptionType.badResponse,
//         );
//       }
//     } catch (e) {
//       final requestOptions = RequestOptions(path: url!);
//       throw DioException(
//         requestOptions: requestOptions,
//         response: Response(
//           requestOptions: requestOptions,
//           data: {"message": "حدث خطآ عند الاتصال بالسيرفر"},
//         ),
//         type: DioExceptionType.badResponse,
//       );
//     }
//   }
//
//   Future<CustomResponse<T>> sendToServer<T>({
//     required String url,
//     required String method,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? body,
//     Map<String, dynamic>? params,
//     T Function(dynamic)? callback,
//     bool withoutHeader = false,
//     String attribute = "data",
//   }) async {
//     final baseUrl = await _getBaseUrl();
//     if (baseUrl == null) {
//       return CustomResponse<T>(
//         success: false,
//         errType: 0,
//         msg: "Base URL is not set",
//       );
//     }
//     // await _getBaseUrl();
//
//     if (!await networkInfo.isConnected) {
//       return CustomResponse<T>(
//         success: false,
//         errType: 0,
//         msg: AppString.noInternetConnection,
//       );
//     }
//
//     body?.removeWhere((key, value) => value == null || value == "");
//     params?.removeWhere((key, value) => value == null || value == "");
//
//     headers = _prepareHeaders(headers, withoutHeader);
//
//     log.white("Request body: ${jsonEncode(body)}");
//     log.white("Request params: ${jsonEncode(params)}");
//
//     dynamic requestBody = _prepareRequestBody(body);
//
//     try {
//       final options = Options(
//         headers: withoutHeader ? null : headers,
//         contentType: _determineContentType(body),
//         responseType: ResponseType.json,
//       );
//       Options _prepareOptions(Map<String, dynamic>? headers,
//           Map<String, dynamic>? body, bool withoutHeader) {
//         return Options(
//           headers: withoutHeader ? null : headers,
//           contentType: _determineContentType(body),
//           responseType: ResponseType.json,
//           sendTimeout: _timeoutDuration,
//           receiveTimeout: _timeoutDuration,
//         );
//       }
//
//       // Response response;
//       // switch (method.toUpperCase()) {
//       //   case 'POST':
//       //     response =
//       //         await _postRequest(baseUrl, url, requestBody, params, options);
//       //     break;
//       //   case 'GET':
//       //     response = await _getRequest(baseUrl, url, params, options);
//       //     break;
//       //   case 'PUT':
//       //     response =
//       //         await _putRequest(baseUrl, url, requestBody, params, options);
//       //     break;
//       //   case 'DELETE':
//       //     response = await _deleteRequest(baseUrl, url, params, options);
//       //     break;
//       //   default:
//       //     throw UnsupportedError('Unsupported method: $method');
//       // }
//
//       final response = await _executeRequest(
//         baseUrl: baseUrl,
//         url: url,
//         requestBody: requestBody,
//         params: params,
//         options: options,
//         method: method,
//       );
//
//       log.green(
//           "Response: ${jsonEncode(response.data)} (Status code: ${response.statusCode})");
//
//       if (response.statusCode! >= 200 && response.statusCode! < 300) {
//         return CustomResponse<T>(
//           success: true,
//           statusCode: response.statusCode!,
//           data: callback != null ? callback(response.data) : response.data,
//         );
//       } else {
//         return CustomResponse<T>(
//           success: false,
//           statusCode: response.statusCode!,
//           msg: HandleError.handleError(response.statusCode, response.data),
//         );
//       }
//     } on DioException catch (e) {
//       return DioErrorHandler.handleDioError<T>(e);
//     }
//   }
//
//   Map<String, dynamic>? _prepareHeaders(
//       Map<String, dynamic>? headers, bool withoutHeader) {
//     if (headers == null) {
//       headers = {
//         "Accept": "application/json",
//         "Content-Type": Headers.jsonContentType,
//       };
//     } else {
//       if (!withoutHeader) {
//         headers.addAll({
//           "Accept": "application/json",
//           "Content-Type": Headers.jsonContentType,
//         });
//       }
//       headers.removeWhere((key, value) => value == null || value == "");
//     }
//     return headers;
//   }
//
//   String _determineContentType(Map<String, dynamic>? body) {
//     return body != null && body.values.any((value) => value is MultipartFile)
//         ? Headers.formUrlEncodedContentType
//         : Headers.jsonContentType;
//   }
//
//   dynamic _prepareRequestBody(Map<String, dynamic>? body) {
//     if (body != null && body.values.any((value) => value is MultipartFile)) {
//       return FormData.fromMap(body);
//     } else {
//       return jsonEncode(body ?? {});
//     }
//   }
//
//   Future<Response> _executeRequest({
//     required String baseUrl,
//     required String url,
//     required dynamic requestBody,
//     required Map<String, dynamic>? params,
//     required Options options,
//     required String method,
//   }) async {
//     final requestUrl = url.startsWith("http") ? url : "$_baseUrl/$url";
//     switch (method.toUpperCase()) {
//       case 'POST':
//         return await _dio.post(requestUrl,
//             data: requestBody, queryParameters: params, options: options);
//       case 'GET':
//         return await _dio.get(requestUrl,
//             queryParameters: params, options: options);
//       case 'PUT':
//         return await _dio.put(requestUrl,
//             data: requestBody, queryParameters: params, options: options);
//       case 'DELETE':
//         return await _dio.delete(requestUrl,
//             queryParameters: params, options: options);
//       default:
//         throw UnsupportedError('Unsupported method: $method');
//     }
//   }
//
//   Future<Response> _postRequest(String baseUrl, String url, dynamic requestBody,
//       Map<String, dynamic>? params, Options options) async {
//     final requestUrl = url.startsWith("http") ? url : "$baseUrl/$url";
//     return await _dio.post(requestUrl,
//         data: requestBody, queryParameters: params, options: options);
//   }
//
//   Future<Response> _getRequest(String baseUrl, String url,
//       Map<String, dynamic>? params, Options options) async {
//     final requestUrl = url.startsWith("http") ? url : "$baseUrl/$url";
//     return await _dio.get(requestUrl,
//         queryParameters: params, options: options);
//   }
//
//   Future<Response> _putRequest(String baseUrl, String url, dynamic requestBody,
//       Map<String, dynamic>? params, Options options) async {
//     final requestUrl = url.startsWith("http") ? url : "$baseUrl/$url";
//     return await _dio.put(requestUrl,
//         data: requestBody, queryParameters: params, options: options);
//   }
//
//   Future<Response> _deleteRequest(String baseUrl, String url,
//       Map<String, dynamic>? params, Options options) async {
//     final requestUrl = url.startsWith("http") ? url : "$baseUrl/$url";
//     return await _dio.delete(requestUrl,
//         queryParameters: params, options: options);
//   }
// }
