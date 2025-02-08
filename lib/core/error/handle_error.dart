import '../utils/app_string.dart';

class HandleError {
  static final i = HandleError();
  String handleError(int? statusCode, dynamic error) {
    if (error is Map && error['message'] == AppString.accountSuspended) {
      return AppString.accountSuspended; // Specific error message in Arabic
    }
    switch (statusCode) {
      case 400:
        return AppString.badRequest;
      case 401:
        return AppString.unauthorized;
      case 403:
        return AppString.forbidden;
      case 404:
        return AppString.notFound;
      case 415:
        return AppString.unsupportedMediaType;
      case 422:
        return AppString.duplicateEmail;
      case 500:
        return AppString.internalServerError;
      case 502:
        return AppString.badGateway;
      default:
        return AppString.unknownError;
    }
  }
}
