import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/helpers/dialog/progress_dialog.dart';
import '../../core/utils/helpers/empty_widget.dart';
import '../../core/utils/helpers/spinkit_indicator.dart';
import 'generic_bloc_state.dart';

class GenericBlocBuilder<A extends BlocBase<GenericBlocState<B>>, B>
    extends StatelessWidget {
  const GenericBlocBuilder({
    super.key,
    this.emptyWidget,
    this.successWidget,
    this.progressStatusTitle,
    this.successStatusTitle,
    this.onSuccessPressed,
    required this.onRetryPressed,
    this.buildWhen,
    this.bloc,
  });

  final Widget? emptyWidget;

  final dynamic bloc;

  final VoidCallback onRetryPressed;
  final VoidCallback? onSuccessPressed;

  final String? successStatusTitle;
  final String? progressStatusTitle;

  final BlocBuilderCondition<GenericBlocState<B>>? buildWhen;

  final Widget Function(GenericBlocState<B> state)? successWidget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<A, GenericBlocState<B>>(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: (BuildContext context, GenericBlocState<B> state) {
        switch (state.status) {
          case Status.empty:
            return emptyWidget ?? const SizedBox();
          case Status.loading:
            return progressStatusTitle == null
                ? const SpinKitIndicator(type: SpinKitType.circle)
                : ProgressDialog(
                    title: progressStatusTitle!,
                    isProgressed: true,
                  );
          case Status.failure:
            return EmptyWidget(message: state.error ?? "No user!");
          // return RetryDialog(
          //   title: state.error ?? "Error",
          //   onRetryPressed: onRetryPressed,
          // );
          case Status.success:
            return successWidget != null
                ? successWidget!(state)
                : ProgressDialog(
                    title: successStatusTitle ?? "",
                    onPressed: onSuccessPressed,
                    isProgressed: false,
                  );
        }
      },
    );
  }
}
