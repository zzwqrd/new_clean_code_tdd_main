import 'package:dartz/dartz.dart';

import '../../../../../core/server_get_data/app_exception.dart';
import '../../../../../core/server_get_data/custom_response.dart';
import '../../../../../core/server_get_data/server_get.dart';
import '../../models/model_name.dart';

class RemoteDataSource {
  Future<Either<AppException, ProductModel>> getProducts() async {
    final CustomResponse response =
        await NetworkServers.i.getRequest('home/index');

    if (response.statusCode == 200) {
      // تحليل البيانات إلى ProductModel
      ProductModel model = ProductModel.fromJson(response.data);

      return Right(model);
    } else {
      return Left(AppException(response.message, code: response.statusCode));
    }
  }
}
