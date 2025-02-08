import 'package:bloc/bloc.dart';

import 'custom_widget/bloc/generic_bloc_state.dart';
import 'features/feature_name/data/models/model_name.dart';
import 'features/feature_name/domain/usecases/usecase_name.dart';
import 'features/feature_name/presentation/bloc/bloc.dart';

class GetDataTestCubit extends Cubit<GenericBlocState<ProductModel>> {
  GetDataTestCubit() : super(GenericBlocState.empty());

  Future<void> getData() async {
    emit(GenericBlocState.loading());
    final res = await ProductUseCaseImp().getData();

    res.fold((l) {
      showErrorDialogue(l.message);
      emit(GenericBlocState.failure(l.message));
    }, (r) {
      if (r.data!.section.isEmpty) {
        showErrorDialogue(r.message);
        emit(GenericBlocState.failure("No Data"));
      } else {
        emit(GenericBlocState.success(r));
      }
    });
  }
}
