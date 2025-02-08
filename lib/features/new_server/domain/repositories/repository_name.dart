import 'package:dartz/dartz.dart';

import '../../../../core/server_get_data/app_exception.dart';
import '../../data/models/model_name.dart';

abstract class ProductRepository {
  Future<Either<AppException, ProductModel>> getData();
}
