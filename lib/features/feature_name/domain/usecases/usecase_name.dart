import 'package:clean_code_tdd_main/features/feature_name/data/models/model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/ApiHelper.dart';
import '../../../../core/network/server.dart';
import '../../data/models/model_name.dart';
import '../../data/models/status_model.dart';
import '../../data/repository_impl/repository_impl.dart';

abstract class ProductUseCase {
  Future<Either<CustomResponse, ProductModel>> getData();
  Future<Either<ApiResponse, ProductModel>> getProductsNew();
  Future<Either<CustomResponse, RegisterModel?>> register();
  Future<Either<CustomResponse, StatusModel?>> delete(int id);
}

class ProductUseCaseImp implements ProductUseCase {
  final productRepositoryImp = ProductRepositoryImp();

  @override
  Future<Either<CustomResponse, ProductModel>> getData() async {
    return await productRepositoryImp.getData();
  }

  @override
  Future<Either<CustomResponse, RegisterModel?>> register() async {
    return await productRepositoryImp.register();
  }

  @override
  Future<Either<CustomResponse, StatusModel?>> delete(int id) async {
    return await productRepositoryImp.delete(id);
  }

  @override
  Future<Either<ApiResponse, ProductModel>> getProductsNew() async {
    return await productRepositoryImp.getProductsNew();
  }
}
