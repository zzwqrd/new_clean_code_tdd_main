import 'package:equatable/equatable.dart';

import '../../../../core/statusApp/statusApp.dart';

// إدارة الحالة العامة لأي نوع من البيانات T
class StateTest<T> extends Equatable {
  final Status status; // حالة البيانات (success, failure, loading, etc.)
  final String? error; // رسائل الخطأ إن وجدت
  final T? data; // البيانات التي تم جلبها

  const StateTest({
    required this.status,
    this.error,
    this.data,
  });

  // دالة لتحديث الحالة باستخدام `copyWith`
  StateTest<T> copyWith({
    Status? status,
    String? error,
    T? data,
  }) {
    return StateTest<T>(
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, error, data];
}
