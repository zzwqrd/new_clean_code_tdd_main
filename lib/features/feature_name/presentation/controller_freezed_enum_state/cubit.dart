import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/model_name.dart';
import '../../domain/usecases/usecase_name.dart';
import '../bloc/bloc.dart';

part 'cubit.freezed.dart';
part 'state.dart';

class DataCubitFreezedEnum extends Cubit<StateTest<List<ProductDatum>>> {
  DataCubitFreezedEnum() : super(const StateTest(status: Status.initial));

  void getData() async {
    emit(state.copyWith(status: Status.start));

    final res = await ProductUseCaseImp().getData();

    res.fold((l) {
      showErrorDialogue(l.message);
      emit(state.copyWith(status: Status.failed, error: l.message));
    }, (r) {
      emit(state.copyWith(status: Status.success, data: r.data));
    });
  }
}
