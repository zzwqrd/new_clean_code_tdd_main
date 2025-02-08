import 'package:flutter/material.dart';

import '../../../../core/error/failure_handler.dart';
import '../../../../core/statusApp/statusApp.dart';
import '../../data/models/model_name.dart';
import '../../domain/usecases/usecase_name.dart';
import 'state.dart';

class DataNotifier extends ChangeNotifier {
  StateTest<ProductModel> _state = const StateTest(status: Status.empty);

  // Getter للوصول إلى حالة البيانات
  StateTest<ProductModel> get state => _state;

  // وظيفة لجلب البيانات
  void getData() async {
    // تحديث الحالة إلى `loading` وإعلام المستمعين
    _state = _state.copyWith(status: Status.loading);
    notifyListeners();

    // محاولة جلب البيانات من usecase
    final res = await ProductUseCaseImp().getData();

    res.fold((l) {
      // في حال الفشل، تحديث الحالة إلى `failure` وإعلام المستمعين
      showErrorDialogue(l.message);
      _state = _state.copyWith(status: Status.failure, error: l.message);
    }, (r) {
      // التحقق إذا كانت البيانات `fail` وتحديث الحالة إلى `failure`
      if (r.status == 'fail') {
        showErrorDialogue(r.message);
        _state = _state.copyWith(status: Status.failure, error: r.message);
      } else {
        // في حال النجاح، تحديث الحالة إلى `success` مع البيانات
        _state = _state.copyWith(status: Status.success, data: r);
      }
    });

    // إعلام المستمعين بأن الحالة قد تم تحديثها
    notifyListeners();
  }
}
