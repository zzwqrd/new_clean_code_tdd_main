// import 'package:dio_http_cache/dio_http_cache.dart';
//
// import 'custom_response.dart';
//
// void _setupDioWithCache() {
//   _dio.interceptors.add(DioCacheManager(
//     CacheConfig(baseUrl: _dio.options.baseUrl),
//   ).interceptor);
// }
//
// Future<CustomResponse> getRequestWithCache(String endpoint) async {
//   try {
//     final response = await _dio.get(
//       endpoint,
//       options: buildCacheOptions(Duration(days: 7)), // Cache لمدة 7 أيام
//     );
//     return CustomResponse.fromJson(response.data);
//   } on DioError catch (e) {
//     throw _handleDioError(e);
//   }
// }
