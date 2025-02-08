import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'core/utils/helpers/empty_widget.dart';
import 'custom_widget/bloc/generic_bloc_builder.dart';
import 'features/feature_name/data/models/model_name.dart';
import 'test_cubit.dart';

class Testviewgetdata extends StatelessWidget {
  const Testviewgetdata({super.key});

  @override
  Widget build(BuildContext context) {
    final data = KiwiContainer().resolve<GetDataTestCubit>();
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
        title: const Text("Testviewgetdata"),
      ),
      body: BlocBuilder(
        bloc: data,
        builder: (context, state) {
          return GenericBlocBuilder<GetDataTestCubit, ProductModel>(
            bloc: KiwiContainer().resolve<GetDataTestCubit>()..getData(),
            emptyWidget: const EmptyWidget(message: "No user!"),
            onRetryPressed: () {
              KiwiContainer().resolve<GetDataTestCubit>().getData();
            },
            successWidget: (state) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.data!.data!.section.length ?? 0,
                itemBuilder: (_, index) {
                  ProductDatum item = state.data!.data!.section[index];
                  return ListItem(item);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget ListItem(ProductDatum data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Image.network(data.image, height: 75),
      ),
    );
  }
}
