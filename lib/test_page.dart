import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

import 'core/utils/helpers/dialog/delete_dialog.dart';
import 'core/utils/helpers/dialog/progress_dialog.dart';
import 'core/utils/helpers/dialog/retry_dialog.dart';
import 'features/feature_name/data/models/model_name.dart';
import 'features/feature_name/presentation/controller_freezed_enum_state/cubit.dart';
import 'features/feature_name/presentation/delete_controller/controller.dart';
import 'features/feature_name/presentation/delete_controller/event.dart';
import 'features/feature_name/presentation/delete_controller/state.dart';
import 'main.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final deleteBloc = KiwiContainer().resolve<DeleteController>();
  final bloc = KiwiContainer().resolve<DataCubitFreezedEnum>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TestPage"),
      ),
      floatingActionButton: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              showMessage(context);
            },
          );
        },
      ),
      body: Column(
        children: [
          CarouselSlider(
            items: List.generate(10, (int index) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: Image.network(
                    'https://picsum.photos/400?random=$index',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 140.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
              scrollPhysics: const BouncingScrollPhysics(),
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => bloc..getData(),
              child: BlocBuilder<DataCubitFreezedEnum,
                  StateTest<List<ProductDatum>>>(
                builder: (context, state) {
                  switch (state.status) {
                    case Status.initial:
                      return const SizedBox();
                    case Status.start:
                      return const Center(child: CircularProgressIndicator());
                    case Status.success:
                      return ListView.builder(
                          itemCount: state.data!.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: Row(
                                children: [
                                  Text(state.data![i].titleAr),
                                ],
                              ),
                            );
                          });
                    case Status.failed:
                      return Center(child: Text(state.error!));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

// this delete bloc with Kiwi
  void showMessage(BuildContext context) async {
    bool isAccepted = await deleteDialog(context, "هل تود الحذف", "");

    if (isAccepted) {
      if (!mounted) return;
      deleteBloc.add(DeleteStartEvens(
        id: 1,
        index: 1,
      ));
      showDialog(
        context: navigator.currentContext!,
        builder: (_) {
          return BlocBuilder(
            bloc: deleteBloc,
            builder: (context, StateDelete state) {
              switch (state.status) {
                case StatusDelete.initial:
                  return const SizedBox();
                case StatusDelete.start:
                  return const ProgressDialog(
                    title: "Deleting",
                    isProgressed: true,
                  );
                case StatusDelete.failed:
                  return RetryDialog(
                    title: state.error ?? "Error",
                    onRetryPressed: () {
                      deleteBloc.add(DeleteStartEvens(
                        id: 1,
                        index: 1,
                      ));
                    },
                  );
                case StatusDelete.success:
                  return ProgressDialog(
                    title: "Successfully deleted",
                    onPressed: () {
                      bloc.getData();
                      Navigator.pop(context);
                    },
                    isProgressed: false,
                  );
              }
            },
          );
        },
      );
    }
  }
}
