import 'dart:io';

import 'package:flutter/foundation.dart';

class SecureConfig {
  static final SecureConfig _instance = SecureConfig._internal();
  factory SecureConfig() => _instance;

  SecureConfig._internal();

  static String? _baseUrl;

  Future<void> loadConfig() async {
    try {
      final file = File('.env');
      if (!await file.exists()) {
        debugPrint('Warning: .env file not found');
        return;
      }

      final lines = await file.readAsLines();
      for (var line in lines) {
        if (line.startsWith('BASE_URL=')) {
          _baseUrl = line.substring('BASE_URL='.length).trim();
          // Add basic validation
          if (!_baseUrl!.startsWith('http://') &&
              !_baseUrl!.startsWith('https://')) {
            throw FormatException(
                'BASE_URL must start with http:// or https://');
          }
          debugPrint('Config loaded successfully');
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading config: $e');
      // In release mode, don't expose the error details
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  static String get baseUrl {
    if (_baseUrl == null) {
      throw StateError('Configuration not loaded. Call loadConfig() first.');
    }
    return _baseUrl!;
  }
}
