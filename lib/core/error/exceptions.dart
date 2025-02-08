class ServerException implements Exception {
  String? exceptionMessage;
  int? statusCode;
  ServerException({
    this.exceptionMessage,
    this.statusCode,
  });
  @override
  String toString() {
    Object? message = exceptionMessage;
    if (message == null) return "Exception";
    return "$message";
  }
}

class CacheException implements Exception {}
