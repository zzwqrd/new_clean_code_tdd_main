part of 'cubit.dart';

@freezed
class DataState with _$DataState {
  const factory DataState.initial() = _initial;
  const factory DataState.start() = _start;
  const factory DataState.success(dynamic data) = _success;
  const factory DataState.failed(String? error) = _failed;
}
