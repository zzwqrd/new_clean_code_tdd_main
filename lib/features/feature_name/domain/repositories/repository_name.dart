import 'package:clean_code_tdd_main/features/feature_name/data/models/model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/ApiHelper.dart';
import '../../../../core/network/server.dart';
import '../../data/models/model_name.dart';
import '../../data/models/status_model.dart';

abstract class ProductRepository {
  Future<Either<CustomResponse, ProductModel>> getData();
  Future<Either<ApiResponse, ProductModel>> getProductsNew();
  Future<Either<CustomResponse, RegisterModel?>> register();
  Future<Either<CustomResponse, StatusModel?>> delete(int id);
}
