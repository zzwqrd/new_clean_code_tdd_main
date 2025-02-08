import 'package:clean_code_tdd_main/ApiResponse_getdata.dart';
import 'package:clean_code_tdd_main/d_no_children.dart';
import 'package:clean_code_tdd_main/test_cubit.dart';
import 'package:kiwi/kiwi.dart';

import 'features/feature_name/domain/usecases/usecase_name.dart';
import 'features/feature_name/presentation/bloc/bloc.dart';
import 'features/feature_name/presentation/controller/cubit.dart';
import 'features/feature_name/presentation/controller_freezed_enum_state/cubit.dart';
import 'features/feature_name/presentation/cubit/cubit.dart';
import 'features/feature_name/presentation/delete_controller/controller.dart';
import 'features/feature_name/presentation/provider_controller/controller.dart';

void initKiwi() {
  KiwiContainer container = KiwiContainer();

  container.registerFactory<RegisterBloc>(
    (container) => RegisterBloc(
      productUseCaseImp: container.resolve<ProductUseCaseImp>(),
    ),
  );

  container.registerFactory((c) => ProductController());
  container.registerFactory((c) => DeleteController());
  container.registerFactory((c) => DataCubitFreezedEnum());
  container.registerFactory((c) => GetDataTestCubit());
  container.registerFactory((c) => DropdownCubit());

  /// this test provider not bloc
  container.registerFactory((c) => DataNotifier());
  container.registerFactory((c) => DataCubit());

  container.registerFactory((c) => DataBloc());
}
