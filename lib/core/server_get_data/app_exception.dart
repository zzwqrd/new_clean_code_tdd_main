class AppException implements Exception {
  final String message;
  final int? code;
  final String? details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() {
    return 'AppException: $message, Code: ${code ?? 'Unknown'}, Details: ${details ?? 'No details provided'}';
  }
}

class NetworkException extends AppException {
  NetworkException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class ServerException extends AppException {
  ServerException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class ValidationException extends AppException {
  ValidationException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class NotFoundException extends AppException {
  NotFoundException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class BadRequestException extends AppException {
  BadRequestException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class TimeoutException extends AppException {
  TimeoutException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class UnknownException extends AppException {
  UnknownException(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}
