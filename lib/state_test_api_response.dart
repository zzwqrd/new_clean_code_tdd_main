import 'package:freezed_annotation/freezed_annotation.dart';

import 'core/statusApp/statusApp.dart';
import 'features/feature_name/data/models/model_name.dart';

part 'state_test_api_response.freezed.dart';

// enum Status { empty, loading, failure, success }

@freezed
class DataState with _$DataState {
  const factory DataState({
    @Default(Status.empty) Status status,
    List<ProductDatum>? data,
    String? error,
  }) = _DataState;
}
// @freezed
// class DataState with _$DataState {
//   const factory DataState.dataState({
//     @Default(false) bool isLoading,
//     List<ProductDatum>? data,
//     String? error,
//   }) = _dataState;
// }

// @freezed
// class DataState with _$DataState {
//   const factory DataState.initial() = _initial;
//   const factory DataState.start() = _start;
//   const factory DataState.success(dynamic data) = _success;
//   const factory DataState.failed(String? error) = _failed;
// }
