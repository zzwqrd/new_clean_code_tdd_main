import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/usecases/usecase_name.dart';
import '../bloc/bloc.dart';

part 'cubit.freezed.dart';
part 'state.dart';

class DataCubitFreezed extends Cubit<DataState> {
  DataCubitFreezed() : super(const DataState.initial());

  void getData() async {
    emit(const DataState.start());
    final res = await ProductUseCaseImp().getData();

    res.fold((l) {
      if (l.statusCode == 405) {
        showErrorDialogue(l.message);
      } else {
        showErrorDialogue(l.message);
      }
      emit(DataState.failed(l.message));
    }, (r) {
      emit(DataState.success(r.data));
    });
  }
  // void getData() async {
  //   emit(state.copyWith(status: Status.start));
  //
  //   final res = await ProductUseCaseImp().getData();
  //
  //   res.fold((l) {
  //     showErrorDialogue(l.message!);
  //     emit(state.copyWith(status: Status.failed, error: l.message));
  //   }, (r) {
  //     if (r.status == 'fail') {
  //       showErrorDialogue(r.message);
  //       emit(state.copyWith(status: Status.failed, error: r.message));
  //     } else {
  //       emit(state.copyWith(status: Status.success, data: r.data));
  //     }
  //   });
  // }
}

// enum Status { initial, start, success, failed }
//
// @freezed
// class MyState with _$MyState {
//   const factory MyState({
//     required Status status,
//     String? error,
//     dynamic data,
//   }) = _MyState;
// }
