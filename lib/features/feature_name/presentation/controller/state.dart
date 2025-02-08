import '../../../../core/statusApp/statusApp.dart';
import '../../data/models/model_name.dart';

class DataState<T> {
  final ProductModel? data;
  final String? error;
  final Status status;

  const DataState({this.data, this.error, required this.status});

  factory DataState.empty() =>
      const DataState(status: Status.empty, data: null);

  factory DataState.loading() => const DataState(status: Status.loading);

  factory DataState.failure(String error) =>
      DataState(error: error, status: Status.failure);

  factory DataState.success(ProductModel? data) =>
      DataState(data: data, status: Status.success);
}
