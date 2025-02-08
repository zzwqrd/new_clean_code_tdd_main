import 'package:clean_code_tdd_main/core/network/ApiHelper.dart';
import 'package:clean_code_tdd_main/features/feature_name/data/models/model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/server.dart';
import '../../domain/repositories/repository_name.dart';
import '../datasources/remote/remote_data_source.dart';
import '../models/model_name.dart';
import '../models/status_model.dart';

class ProductRepositoryImp extends ProductRepository {
  final productEndPoint = RemoteDataSource();

  @override
  Future<Either<CustomResponse, ProductModel>> getData() async {
    return await productEndPoint.getProducts();
  }

  @override
  Future<Either<CustomResponse, RegisterModel?>> register() async {
    return await productEndPoint.register();
  }

  @override
  Future<Either<CustomResponse, StatusModel?>> delete(int id) async {
    return await productEndPoint.delete(id);
  }

  @override
  Future<Either<ApiResponse, ProductModel>> getProductsNew() async {
    return await productEndPoint.getProductsNew();
  }
}
