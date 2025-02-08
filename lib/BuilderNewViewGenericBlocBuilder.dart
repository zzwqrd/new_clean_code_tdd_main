import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'core/GenericBlocBuilderNew/GenericBlocBuilderNew.dart';
import 'core/utils/helpers/empty_widget.dart';
import 'features/feature_name/data/models/model_name.dart';
import 'features/feature_name/presentation/controller/cubit.dart';
import 'features/feature_name/presentation/controller/state.dart';

class BuilderNewGenericBlocBuilder extends StatelessWidget {
  const BuilderNewGenericBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final data = KiwiContainer().resolve<DataCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder(
          bloc: data,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                data.getData();
              },
              icon: const Icon(Icons.refresh),
            );
          },
        ),
        title: const Text("BuilderNewGenericBlocBuilder"),
      ),
      body: BlocBuilder<DataCubit, DataState<ProductModel>>(
        bloc: data..getData(),
        builder: (context, state) {
          return GenericBlocBuilderNew<DataCubit, DataState<ProductModel>>(
            bloc: KiwiContainer().resolve<DataCubit>()..getData(),
            status: state.status, // تمرير الحالة هنا
            context: context, // تمرير context هنا
            state: state, // تمرير state هنا
            emptyWidget: const EmptyWidget(message: "No products available!"),
            onRetryPressed: () {
              context.read<DataCubit>().getData();
            },
            successWidget: (context, state) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.data!.data!.section.length,
                itemBuilder: (_, index) {
                  ProductDatum item = state.data!.data!.section[index];
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
