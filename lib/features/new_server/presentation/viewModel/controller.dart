import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/server_get_data/app_exception.dart';
import '../../data/models/model_name.dart';
import '../../domain/usecases/usecase_name.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> getProducts() async {
    emit(ProductLoading());
    final Either<AppException, ProductModel> result =
        await ProductUseCaseImp().getData();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final ProductModel products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
