import 'package:flutter/material.dart';

import '../../core/utils/helpers/empty_widget.dart';
import '../statusApp/statusApp.dart';
import '../utils/helpers/dialog/progress_dialog.dart';
import '../utils/helpers/spinkit_indicator.dart';

class GenericProviderBuilder<A extends ChangeNotifier, B>
    extends StatelessWidget {
  const GenericProviderBuilder({
    super.key,
    this.emptyWidget,
    this.successWidget,
    this.progressStatusTitle,
    this.successStatusTitle,
    this.onSuccessPressed,
    required this.onRetryPressed,
    this.buildWhen,
    required this.status,
    required this.context, // تمرير context
    required this.state,
    this.provider, // تمرير state
  });

  final Widget? emptyWidget;
  final A? provider; // بدلاً من bloc نستخدم provider
  final VoidCallback onRetryPressed;
  final VoidCallback? onSuccessPressed;
  final String? successStatusTitle;
  final String? progressStatusTitle;
  final bool Function(B state)?
      buildWhen; // تعديل لتحديد متى يتم إعادة بناء الواجهة
  final Widget Function(BuildContext context, B state)? successWidget;
  final Status status;
  final BuildContext context; // تمرير context كمتغير
  final B state; // تمرير state كمتغير

  @override
  Widget build(BuildContext context) {
    switch (status) {
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
        return EmptyWidget(message: "No Data!");

      case Status.success:
        return successWidget != null
            ? successWidget!(context, state)
            : ProgressDialog(
                title: successStatusTitle ?? "",
                onPressed: onSuccessPressed,
                isProgressed: false,
              );

      default:
        return emptyWidget ?? const EmptyWidget(message: "Unknown state!");
    }
  }
}
