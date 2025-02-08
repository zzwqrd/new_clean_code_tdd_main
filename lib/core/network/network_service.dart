// import 'dart:async';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// class NetworkService {
//   // Singleton instance
//   static final NetworkService instance = NetworkService._();
//
//   factory NetworkService._() {
//     return instance;
//   }
//
//   NetworkService._internal() {
//     _initializeDio();
//   }
//
//   // Dio instance for handling HTTP requests
//   final Dio _dio = Dio();
//   final Connectivity _connectivity = Connectivity();
//   String? _baseUrl;
//   String? _authToken;
//
//   // Initialize Dio with default settings
//   void _initializeDio() {
//     _dio.interceptors.add(
//       LogInterceptor(
//         requestBody: true,
//         responseBody: true,
//         logPrint: (object) => debugPrint(object.toString()),
//       ),
//     );
//   }
//
//   /// Set the base URL for all requests
//   void setBaseUrl(String baseUrl) {
//     _baseUrl_baseUrl = baseUrl;
//   }
//
//   /// Set the authorization token
//   void setAuthToken(String token) {
//     _authToken = token;
//   }
//
//   /// Build the headers for the request, optionally including the auth token
//   Map<String, dynamic> _buildHeaders({bool includeAuth = true}) {
//     final headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//     };
//
//     if (includeAuth && _authToken != null) {
//       headers['Authorization'] = 'Bearer $_authToken';
//     }
//
//     return headers;
//   }
//
//   /// Handle the request and return a [CustomResponseService]
//   Future<CustomResponseService<T>> _handleRequest<T>({
//     required String url,
//     required String method,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? params,
//     dynamic data,
//     bool includeAuth = true,
//     required T Function(dynamic) responseParser,
//   }) async {
//     // Check for internet connection
//     if (await _connectivity.checkConnectivity() == ConnectivityResult.none) {
//       return CustomResponseService.error(
//         statusCode: 0,
//         message: "No internet connection",
//       );
//     }
//
//     try {
//       // Construct the full URL
//       final fullUrl =
//           _baseUrl != null && !url.startsWith('http') ? '$_baseUrl$url' : url;
//
//       // Make the request
//       final response = await _dio.request(
//         fullUrl,
//         data: data,
//         queryParameters: params,
//         options: Options(
//           method: method,
//           headers: headers ?? _buildHeaders(includeAuth: includeAuth),
//         ),
//       );
//
//       // Return a successful response
//       return CustomResponseService.success(
//         statusCode: response.statusCode ?? 200,
//         data: responseParser(response.data),
//       );
//     } on DioException catch (e) {
//       // Handle Dio errors
//       return _handleDioError<T>(e);
//     }
//   }
//
//   /// Handle Dio errors and return a [CustomResponseService]
//   CustomResponseService<T> _handleDioError<T>(DioException e) {
//     String errorMessage = "An error occurred";
//     int statusCode = e.response?.statusCode ?? 500;
//
//     if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.receiveTimeout) {
//       errorMessage = "Connection timeout";
//     } else if (e.type == DioExceptionType.badResponse) {
//       if (statusCode == 401) {
//         errorMessage = "Unauthorized request. Please check your credentials.";
//       } else if (statusCode >= 500) {
//         errorMessage = "Server error. Please try again later.";
//       } else {
//         errorMessage = e.response?.data['message'] ?? errorMessage;
//       }
//     } else {
//       errorMessage = e.message ?? errorMessage;
//     }
//
//     return CustomResponseService.error(
//       statusCode: statusCode,
//       message: errorMessage,
//     );
//   }
//
//   /// Public method to make GET requests
//   Future<CustomResponseService<T>> get<T>({
//     required String url,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? params,
//     required T Function(dynamic) responseParser,
//   }) async {
//     return _handleRequest(
//       url: url,
//       method: 'GET',
//       headers: headers,
//       params: params,
//       responseParser: responseParser,
//     );
//   }
//
//   /// Public method to make POST requests
//   Future<CustomResponseService<T>> post<T>({
//     required String url,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? body,
//     required T Function(dynamic) responseParser,
//   }) async {
//     return _handleRequest(
//       url: url,
//       method: 'POST',
//       headers: headers,
//       data: body,
//       responseParser: responseParser,
//     );
//   }
//
//   /// Public method to make PUT requests
//   Future<CustomResponseService<T>> put<T>({
//     required String url,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? body,
//     required T Function(dynamic) responseParser,
//   }) async {
//     return _handleRequest(
//       url: url,
//       method: 'PUT',
//       headers: headers,
//       data: body,
//       responseParser: responseParser,
//     );
//   }
//
//   /// Public method to make DELETE requests
//   Future<CustomResponseService<T>> delete<T>({
//     required String url,
//     Map<String, dynamic>? headers,
//     Map<String, dynamic>? body,
//     required T Function(dynamic) responseParser,
//   }) async {
//     return _handleRequest(
//       url: url,
//       method: 'DELETE',
//       headers: headers,
//       data: body,
//       responseParser: responseParser,
//     );
//   }
// }
//
// /// CustomResponseService class to handle the response and errors
// class CustomResponseService<T> {
//   final bool success;
//   final int statusCode;
//   final T? data;
//   final String message;
//
//   CustomResponseService.success({required this.statusCode, required this.data})
//       : success = true,
//         message = '';
//
//   CustomResponseService.error({required this.statusCode, required this.message})
//       : success = false,
//         data = null;
// }
