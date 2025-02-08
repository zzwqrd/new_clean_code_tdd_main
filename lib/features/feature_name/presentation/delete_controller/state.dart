import 'package:equatable/equatable.dart';

enum StatusDelete { initial, start, success, failed }

class StateDelete<T> extends Equatable {
  final StatusDelete status;
  final String? error;
  final T? data;

  const StateDelete({
    required this.status,
    this.error,
    this.data,
  });

  StateDelete<T> copyWith({
    StatusDelete? status,
    String? error,
    dynamic data,
  }) {
    return StateDelete<T>(
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, error, data];
}
