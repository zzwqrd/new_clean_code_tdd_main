// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// import '../error/exceptions.dart';
// import '../error/failures.dart';
// import '../network/server.dart';
//
// abstract class AppService {
//   final ServerGate serverGate = ServerGate.i;
//
//   Future<Either<CustomResponse, ReturnType>> exceptionHandler<ReturnType>(
//       Future<ReturnType> Function() function) async {
//     try {
//       final result = await function();
//       if (result is CustomResponse && !result.success) {
//         return Left(CustomResponse(
//           message: result.message,
//           statusCode: result.statusCode,
//         ));
//       }
//       return Right(result);
//     } catch (e, trace) {
//       if (kDebugMode) {
//         print(e.toString());
//         print(trace.toString());
//       }
//
//       if (e is DioException) {
//         final customResponse = serverGate.handleServerError(e);
//         if (customResponse.statusCode == 401) {
//           return Right(customResponse as ReturnType);
//         }
//         return Left(CustomResponse(
//           message: customResponse.message,
//           statusCode: customResponse.statusCode,
//         ));
//       } else if (e is ServerFailure) {
//         return Left(
//             CustomResponse(message: e.toString(), statusCode: e.statusCode!));
//       } else if (e is ServerException) {
//         return Left(
//             CustomResponse(message: e.toString(), statusCode: e.statusCode!));
//       } else if (e is FormatException) {
//         return Left(CustomResponse(
//             message: "Data format error: ${e.message}", statusCode: 400));
//       } else {
//         return Left(CustomResponse(
//           message: "Something went wrong, please try again later.",
//           statusCode: 500,
//         ));
//       }
//     }
//   }
//   // Future<Either<Failure, ReturnType>> exceptionHandler<ReturnType>(
//   //     Future<ReturnType> Function() function) async {
//   //   try {
//   //     return Right(await function());
//   //   } catch (e, trace) {
//   //     if (kDebugMode) {
//   //       print(e.toString());
//   //       print(trace.toString());
//   //     }
//   //
//   //     if (e is ServerFailure) {
//   //       return Left(
//   //           ServerFailure(message: e.toString(), statusCode: e.statusCode!));
//   //     } else if (e is ServerException) {
//   //       return Left(
//   //           ServerFailure(message: e.toString(), statusCode: e.statusCode!));
//   //     } else if (e is FormatException) {
//   //       return Left(ServerFailure(
//   //           message: "Data format error: ${e.message}", statusCode: 400));
//   //     } else {
//   //       return Left(
//   //         ServerFailure(
//   //           message: "Something went wrong,please try again later.",
//   //           statusCode: 500,
//   //         ),
//   //       );
//   //     }
//   //   }
//   // }
//
//   // Future<Either<CustomResponse<T>, Response>> exceptionHandler<Response>(
//   //     Future<Response> Function() function) async {
//   //   try {
//   //     return Right(await function());
//   //   } catch (e, trace) {
//   //     if (kDebugMode) {
//   //       print(e.toString());
//   //       print(trace.toString());
//   //     }
//   //
//   //     if (e is CustomResponse) {
//   //       return Left(
//   //           CustomResponse<T>(message: e.toString(), statusCode: e.statusCode));
//   //     } else if (e is ServerException) {
//   //       return Left(
//   //           CustomResponse(message: e.toString(), statusCode: e.statusCode!));
//   //     } else if (e is FormatException) {
//   //       return Left(CustomResponse(
//   //           message: "Data format error: ${e.message}", statusCode: 400));
//   //     } else {
//   //       if (e is DioException) {
//   //         return Left(CustomResponse(
//   //             message: e.response!.data['message'],
//   //             statusCode: e.response!.statusCode!));
//   //       } else {
//   //         return Left(CustomResponse(
//   //             message: "Something went wrong, please try again later.",
//   //             statusCode: 500));
//   //       }
//   //     }
//   //   }
//   // }
//   //
//   // Future<Either<Failure, ReturnType>> getRequest<ReturnType>({
//   //   required String url,
//   //   Map<String, dynamic>? headers,
//   //   Map<String, dynamic>? params,
//   //   required ReturnType Function(dynamic) callback,
//   // }) async {
//   //   return await exceptionHandler(() async {
//   //     final CustomResponse<ReturnType> response =
//   //         await serverDio.getFromServer<ReturnType>(
//   //       url: url,
//   //       headers: headers,
//   //       params: params,
//   //       callback: callback,
//   //     );
//   //
//   //     if (response.success) {
//   //       return response.data!;
//   //     } else {
//   //       throw ServerException(
//   //           exceptionMessage: response.message, statusCode: response.statusCode);
//   //     }
//   //   });
//   // }
//   //
//   // Future<Either<Failure, ReturnType>> postRequest<ReturnType>({
//   //   required String url,
//   //   Map<String, dynamic>? headers,
//   //   Map<String, dynamic>? body,
//   //   Map<String, dynamic>? params,
//   //   required ReturnType Function(dynamic) callback,
//   // }) async {
//   //   return await exceptionHandler(() async {
//   //     // تسجيل تفاصيل الطلب
//   //     if (kDebugMode) {
//   //       print('URL: $url');
//   //       print('Headers: $headers');
//   //       print('Body: $body');
//   //       print('Params: $params');
//   //     }
//   //
//   //     final CustomResponse<ReturnType> response =
//   //         await serverDio.sendToServer<ReturnType>(
//   //       url: url,
//   //       headers: headers,
//   //       body: body,
//   //       params: params,
//   //       callback: callback,
//   //     );
//   //
//   //     // تسجيل تفاصيل الاستجابة
//   //     if (kDebugMode) {
//   //       print('Response Success: ${response.success}');
//   //       print('Response Message: ${response.message}');
//   //       print('Response StatusCode: ${response.statusCode}');
//   //       print('Response Data: ${response.data}');
//   //     }
//   //
//   //     if (response.statusCode == 200) {
//   //       return response.data!;
//   //     } else {
//   //       throw ServerException(
//   //           exceptionMessage: response.message, statusCode: response.statusCode);
//   //     }
//   //   });
//   // }
//   //
//   // Future<Either<Failure, ReturnType>> putRequest<ReturnType>({
//   //   required String url,
//   //   Map<String, dynamic>? headers,
//   //   Map<String, dynamic>? body,
//   //   Map<String, dynamic>? params,
//   //   required ReturnType Function(dynamic) callback,
//   // }) async {
//   //   return await exceptionHandler(() async {
//   //     final CustomResponse<ReturnType> response =
//   //         await serverDio.putToServer<ReturnType>(
//   //       url: url,
//   //       headers: headers,
//   //       body: body,
//   //       callback: callback,
//   //     );
//   //
//   //     if (response.success) {
//   //       return response.data!;
//   //     } else {
//   //       throw ServerException(
//   //           exceptionMessage: response.message, statusCode: response.statusCode);
//   //     }
//   //   });
//   // }
//   //
//   // Future<Either<CustomResponse, ReturnType>> deleteRequest<ReturnType>({
//   //   required String url,
//   //   Map<String, dynamic>? headers,
//   //   Map<String, dynamic>? body,
//   //   Map<String, dynamic>? params,
//   // }) async {
//   //   return await exceptionHandler(() async {
//   //     final CustomResponse<ReturnType> response =
//   //         await serverDio.deleteFromServer<ReturnType>(
//   //       url: url,
//   //       headers: headers,
//   //       body: body,
//   //       params: params,
//   //     );
//   //
//   //     if (response.success) {
//   //       return response.data!;
//   //     } else {
//   //       throw ServerException(
//   //           exceptionMessage: response.message,
//   //           statusCode: response.statusCode);
//   //     }
//   //   });
//   // }
// }
