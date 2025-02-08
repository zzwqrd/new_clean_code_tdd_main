import 'package:dartz/dartz.dart';

import '../../../../core/server_get_data/app_exception.dart';
import '../../domain/repositories/repository_name.dart';
import '../datasources/remote/remote_data_source.dart';
import '../models/model_name.dart';

class ProductRepositoryImp extends ProductRepository {
  final productEndPoint = RemoteDataSource();

  @override
  Future<Either<AppException, ProductModel>> getData() async {
    return await productEndPoint.getProducts();
  }
}
