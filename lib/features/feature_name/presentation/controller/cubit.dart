import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/model_name.dart';
import '../../domain/usecases/usecase_name.dart';
import '../bloc/bloc.dart';
import 'state.dart';

class DataCubit extends Cubit<DataState<ProductModel>> {
  DataCubit() : super(DataState.empty());

  void getData() async {
    emit(DataState.loading());
    final res = await ProductUseCaseImp().getProductsNew();

    res.fold((l) {
      showErrorDialogue(l.msg);
      emit(DataState.failure(l.msg));
    }, (r) {
      if (r.data!.section.isEmpty) {
        emit(DataState.failure(r.message));
      } else {
        emit(DataState.success(r));
      }
    });
  }
}
