import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/usecase_name.dart';
import 'event.dart';
import 'state.dart';

class DeleteController extends Bloc<DeleteEvents, StateDelete> {
  DeleteController() : super(const StateDelete(status: StatusDelete.initial)) {
    on<DeleteStartEvens>(delete);
  }

  void delete(
    DeleteStartEvens event,
    Emitter<StateDelete> emit,
  ) async {
    emit(state.copyWith(status: StatusDelete.start));
    final res = await ProductUseCaseImp().delete(event.index);
    res.fold((l) {
      // showErrorDialogue(l.response!.data);
      emit(state.copyWith(status: StatusDelete.failed, error: l.message));
    }, (r) {
      emit(state.copyWith(status: StatusDelete.success));
    });
  }
}
