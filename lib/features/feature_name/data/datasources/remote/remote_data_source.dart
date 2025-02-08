import 'package:dartz/dartz.dart';

import '../../../../../core/network/ApiHelper.dart';
import '../../../../../core/network/server.dart';
import '../../models/model.dart';
import '../../models/model_name.dart';
import '../../models/status_model.dart';

//NetworkServers
class RemoteDataSource {
  Future<Either<ApiResponse, ProductModel>> getProductsNew() async {
    ApiResponse response = await ApiHelper().get(
      path: 'home/index',
      // callback: (data) {
      //   List<Map<String, dynamic>> itemsJson =
      //       data as List<Map<String, dynamic>>;
      //   return itemsJson
      //       .map((itemJson) => ProductDatum.fromJson(itemJson))
      //       .toList();
      // },
    );

    if (response.success) {
      ProductModel model = ProductModel.fromJson(response.response!.data);
      return Right(model);
    } else {
      return Left(
        // response,
        ApiResponse(
          success: false,
          statusCode: response.statusCode,
          errType: response.errType,
          msg: response.msg,
          response: response.response!,
        ),
      );
    }
  }

  Future<Either<CustomResponse, ProductModel>> getProducts() async {
    CustomResponse response = await ServerGate.i.getFromServer(
      url: 'home/index',
      // callback: (data) {
      //   List<Map<String, dynamic>> itemsJson =
      //       data as List<Map<String, dynamic>>;
      //   return itemsJson
      //       .map((itemJson) => ProductDatum.fromJson(itemJson))
      //       .toList();
      // },
    );

    if (response.success) {
      ProductModel model = ProductModel.fromJson(response.response!.data);
      return Right(model);
    } else {
      return Left(
        response,
        // CustomResponse(
        //   success: false,
        //   statusCode: response.statusCode,
        //   errType: response.errType,
        //   message: 'dddd',
        //   response: response.response!,
        // ),
      );
    }
  }

  Future<Either<CustomResponse, RegisterModel>> register() async {
    CustomResponse response = await ServerGate.i.sendToServer(
      url: 'client_register',
      body: {
        'fullname': "ahmeddddd",
        'password': "aaaaaaaa",
        'password_confirmation': "aaaaaaaa",
        'phone': "0304234",
        'gender': 'female',
        'lat': '250.05152',
        'lng': '290.452',
      },
      callback: (data) {
        return RegisterModel.fromJson(data);
      },
    );
    RegisterModel model = RegisterModel.fromJson(response.response!.data);
    if (response.success) {
      return Right(model);
    } else {
      return Left(response);
    }
  }

  Future<Either<CustomResponse, StatusModel>> delete(int id) async {
    CustomResponse response = await ServerGate.i.deleteFromServer(
      url: 'client/cart/delete_item/${id}',
      callback: (data) {
        return StatusModel.fromJson(data);
      },
    );
    StatusModel model = StatusModel.fromJson(response.response!.data);
    if (response.success) {
      return Right(model);
    } else {
      return Left(response);
    }
  }
}
