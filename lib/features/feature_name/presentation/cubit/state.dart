import '../../data/models/model_name.dart';

class ProductState {}

class ProductStateStart extends ProductState {}

class ProductStateSuccess extends ProductState {
  final ProductModel model;
  ProductStateSuccess({
    required this.model,
  });
}

class ProductStateFailed extends ProductState {
  String msg;
  int errType;
  ProductStateFailed({
    required this.msg,
    required this.errType,
  });
}
