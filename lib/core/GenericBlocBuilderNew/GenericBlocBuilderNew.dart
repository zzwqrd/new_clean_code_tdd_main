import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/helpers/empty_widget.dart';
import '../statusApp/statusApp.dart';
import '../utils/helpers/dialog/progress_dialog.dart';
import '../utils/helpers/spinkit_indicator.dart';

class GenericBlocBuilderNew<A extends BlocBase<B>, B> extends StatelessWidget {
  const GenericBlocBuilderNew({
    super.key,
    this.emptyWidget,
    this.successWidget,
    this.progressStatusTitle,
    this.successStatusTitle,
    this.onSuccessPressed,
    required this.onRetryPressed,
    this.buildWhen,
    this.bloc,
    required this.status,
    required this.context, // تمرير context
    required this.state, // تمرير state
  });

  final Widget? emptyWidget;
  final A? bloc;
  final VoidCallback onRetryPressed;
  final VoidCallback? onSuccessPressed;
  final String? successStatusTitle;
  final String? progressStatusTitle;
  final BlocBuilderCondition<B>? buildWhen;
  final Widget Function(BuildContext context, B state)? successWidget;
  final Status status;
  final BuildContext context; // إضافة context كمتغير
  final B state; // إضافة state كمتغير

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

// class GenericBlocBuilderNew<A extends BlocBase<B>, B> extends StatelessWidget {
//   const GenericBlocBuilderNew({
//     super.key,
//     this.emptyWidget,
//     this.successWidget,
//     this.progressStatusTitle,
//     this.successStatusTitle,
//     this.onSuccessPressed,
//     required this.onRetryPressed,
//     this.buildWhen,
//     this.bloc,
//     required this.status,
//     this.itemBuilder,
//   });
//
//   final Widget? emptyWidget;
//   final A? bloc;
//   final VoidCallback onRetryPressed;
//   final VoidCallback? onSuccessPressed;
//   final String? successStatusTitle;
//   final String? progressStatusTitle;
//   final BlocBuilderCondition<B>? buildWhen;
//   final Widget Function(BuildContext context, B state)? successWidget;
//   final Status status;
//   final Widget Function(BuildContext context, int index, B state)? itemBuilder;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<A, B>(
//       bloc: bloc,
//       buildWhen: buildWhen,
//       builder: (BuildContext context, B state) {
//         switch (state) {
//           case Status.empty:
//             return emptyWidget ?? const SizedBox();
//           case Status.loading:
//             return progressStatusTitle == null
//                 ? const SpinKitIndicator(type: SpinKitType.circle)
//                 : ProgressDialog(
//                     title: progressStatusTitle!,
//                     isProgressed: true,
//                   );
//
//           case Status.failure:
//             return const EmptyWidget(message: "Failed to load data!");
//
//           case Status.success:
//             if (successWidget != null && state != null) {
//               return successWidget!(context, state);
//             } else {
//               return emptyWidget ??
//                   const EmptyWidget(message: "No items available!");
//             }
//
//           default:
//             return emptyWidget ?? const EmptyWidget(message: "Unknown state!");
//         }
//       },
//     );
//   }
// }

// class GenericBlocBuilderNew<A extends BlocBase<B>, B> extends StatelessWidget {
//   const GenericBlocBuilderNew({
//     super.key,
//     this.emptyWidget,
//     this.successWidget,
//     this.progressStatusTitle,
//     this.successStatusTitle,
//     this.onSuccessPressed,
//     required this.onRetryPressed,
//     this.buildWhen,
//     this.bloc,
//     required this.status, // الـ Status يُمرر هنا
//   });
//
//   final Widget? emptyWidget;
//   final dynamic bloc;
//   final VoidCallback onRetryPressed;
//   final VoidCallback? onSuccessPressed;
//   final String? successStatusTitle;
//   final String? progressStatusTitle;
//   final BlocBuilderCondition<B>? buildWhen;
//   final Widget Function(B state)? successWidget;
//   final Status status; // القيمة المدخلة للـ Status
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<A, B>(
//       bloc: bloc,
//       buildWhen: buildWhen,
//       builder: (BuildContext context, B state) {
//         switch (state) {
//           case Status.empty:
//             return emptyWidget ?? const SizedBox();
//           case Status.loading:
//             return progressStatusTitle == null
//                 ? const SpinKitIndicator(type: SpinKitType.circle)
//                 : ProgressDialog(
//                     title: progressStatusTitle!,
//                     isProgressed: true,
//                   );
//           case Status.failure:
//             return EmptyWidget(message: "No user!");
//           case Status.success:
//             return successWidget != null
//                 ? successWidget!(state)
//                 : ProgressDialog(
//                     title: successStatusTitle ?? "",
//                     onPressed: onSuccessPressed,
//                     isProgressed: false,
//                   );
//
//           default:
//             return const SizedBox();
//         }
//       },
//     );
//   }
// }
