import 'package:dartz/dartz.dart';

import '../../../../core/server_get_data/app_exception.dart';
import '../../data/models/model_name.dart';
import '../../data/repository_impl/repository_impl.dart';

abstract class ProductUseCase {
  Future<Either<AppException, ProductModel>> getData();
}

class ProductUseCaseImp implements ProductUseCase {
  final productRepositoryImp = ProductRepositoryImp();

  @override
  Future<Either<AppException, ProductModel>> getData() async {
    return await productRepositoryImp.getData();
  }
}
