import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/usecase_name.dart';
import '../bloc/bloc.dart';
import 'state.dart';

class ProductController extends Cubit<ProductState> {
  ProductController() : super(ProductState());
  Future<void> getData() async {
    emit(ProductStateStart());
    final res = await ProductUseCaseImp().getData();

    res.fold((l) {
      showErrorDialogue(l.message);
      emit(ProductStateFailed(msg: l.message, errType: 0));
    }, (r) {
      emit(ProductStateSuccess(model: r));
    });
  }
}
