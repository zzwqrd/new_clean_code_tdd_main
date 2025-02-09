import 'package:clean_code_tdd_main/core/network/ApiHelper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

// import 'core/network/ApiService.dart';
import 'core/GenericBlocBuilderNew/GenericBlocBuilderNew.dart';
import 'core/statusApp/statusApp.dart';
import 'features/feature_name/data/models/model_name.dart';
import 'state_test_api_response.dart';
import 'user_data.dart';

class RemoteDataSource {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Either<ApiResponse, List<ProductDatum>>> getProducts() async {
    ApiResponse response = await _apiHelper.get(
      path: 'home/index',
      // fromJson: (json) => json as Map<String, dynamic>,
    );
    try {
      if (response.success) {
        ProductModel model = ProductModel.fromJson(response.data!);
        return Right(model.data?.section ?? []);
      } else {
        return Left(response);
      }
    } catch (e) {
      return Left(ApiResponse(
        success: response.success,
        msg: 'An unexpected error occurred: $e${response.msg}',
        statusCode: response.statusCode,
        error: response.msg,
      ));
    }
  }

  Future<Either<ApiResponse, UserDetailsRm>> login() async {
    //user/login
    ApiResponse response = await _apiHelper.post(
      path: 'user/login',
      data: {"phone": "01002020202", "password": "12345678"},
    );
    try {
      if (response.success) {
        UserDetailsRm model = UserDetailsRm.fromJson(response.data!);
        return Right(model);
      } else {
        return Left(response);
      }
    } catch (e) {
      return Left(ApiResponse(
        success: response.success,
        msg: 'An unexpected error occurred: $e${response.msg}',
        statusCode: response.statusCode,
        error: response.msg,
      ));
    }
  }
}

class DataBloc extends Cubit<DataState> {
  final RemoteDataSource _dataSource = RemoteDataSource();

  DataBloc() : super(const DataState(status: Status.empty));

  Future<void> login() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.login();

    result.fold(
      (error) {
        showErrorDialogue(error.msg);
        emit(state.copyWith(status: Status.failure, error: error.msg));
      },
      (data) {
        showErrorDialogue(data.message);
        emit(state.copyWith(status: Status.success, data: data, error: null));
      },
    );
  }

  Future<void> loginI() async {
    emit(state.copyWith(status: Status.loading));
    ApiResponse response = await getLogin();
    if (response.success) {
      UserDetailsRm model = UserDetailsRm.fromJson(response.data!);
      showErrorDialogue(response.msg);
      emit(state.copyWith(status: Status.success, data: model, error: null));
    } else {
      showErrorDialogue(response.msg);

      emit(state.copyWith(status: Status.failure, error: response.msg));
    }
  }

  Future<void> getData() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.getProducts();

    result.fold(
      (error) {
        showErrorDialogue(error.msg);
        emit(state.copyWith(status: Status.failure, error: error.msg));
      },
      (data) {
        emit(state.copyWith(status: Status.success, data: data, error: null));
      },
    );
  }

  Future<void> grtDataI() async {
    emit(state.copyWith(status: Status.loading));
    ApiResponse response = await getSections();
    if (response.success) {
      ProductModel model = ProductModel.fromJson(response.data!);
      emit(state.copyWith(
          status: Status.success, data: model.data!.section, error: null));
    } else {
      showErrorDialogue(response.msg);

      emit(state.copyWith(status: Status.failure, error: response.msg));
    }
  }

  Future<ApiResponse> getSections() async {
    final ApiHelper _apiHelper = ApiHelper();

    ApiResponse response = await _apiHelper.get(
      path: 'home/index',
      // fromJson: (json) => json as Map<String, dynamic>,
    );
    return response;
  }

  Future<ApiResponse> getLogin() async {
    final ApiHelper _apiHelper = ApiHelper();

    ApiResponse response = await _apiHelper.post(
      path: 'user/login',
      data: {"phone": "01002020202", "password": "12345678"},
    );
    return response;
  }
}

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Management')),
      floatingActionButton: BlocBuilder<DataBloc, DataState>(
        bloc: KiwiContainer().resolve<DataBloc>(),
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              KiwiContainer().resolve<DataBloc>().loginI();
            },
          );
        },
      ),
      body: BlocBuilder<DataBloc, DataState>(
        bloc: KiwiContainer().resolve<DataBloc>()..getData(),
        builder: (context, state) {
          return GenericBlocBuilderNew<DataBloc, DataState>(
            bloc: KiwiContainer().resolve<DataBloc>(),
            status: state.status, // تمرير الحالة هنا
            context: context, // تمرير context هنا
            state: state, // تمرير state هنا
            // emptyWidget: const EmptyWidget(message: "No products available!"),
            onRetryPressed: () {
              KiwiContainer().resolve<DataBloc>().grtDataI();
            },
            successWidget: (context, state) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.data!.length,
                itemBuilder: (_, index) {
                  ProductDatum item = state.data![index];
                  return _listItem(item);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _listItem(ProductDatum data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Image.network(data.image, height: 75),
      ),
    );
  }
}
