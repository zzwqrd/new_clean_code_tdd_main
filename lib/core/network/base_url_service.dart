import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/utils/helpers/loger.dart';

class BaseUrlService {
  Dio? _dio;
  final LoggerDebug log =
      LoggerDebug(headColor: LogColors.red, constTitle: "Server Gate Logger");

  final StreamController<double> onSingleReceive = StreamController.broadcast();
  String BASE_URL;

  BaseUrlService(this.BASE_URL);

  Future<String?> getBaseUrl() async {
    String? url;
    log.red(
        "----============>>>>>>>>>>>>>>>>>>>>>-----\x1B[31m$BASE_URL\x1B[0m");
    try {
      if (BASE_URL != null) return BASE_URL;
      final result = await _dio!.get(
        url!,
        options: Options(
          headers: {"Accept": "application/json"},
          sendTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
        ),
      );
      if (result.data != null) {
        BASE_URL = result.data;
        log.red("------Base url -----\x1B[31m$BASE_URL\x1B[0m");
        return BASE_URL;
      } else {
        throw DioException(
          requestOptions: result.requestOptions,
          response: Response(
            requestOptions: result.requestOptions,
            data: {"message": "لم نستتطع الاتصال بالسيرفر"},
          ),
          type: DioExceptionType.unknown,
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
        type: DioExceptionType.unknown,
      );
    }
  }

  void dispose() {
    onSingleReceive.close();
  }
}
