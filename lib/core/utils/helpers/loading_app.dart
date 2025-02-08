import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/helpers/extintions.dart';
import '../../../generated/assets.dart';

class LoadingBtn extends StatelessWidget {
  const LoadingBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.iconsLoading);
  }
}

class LoadingApp extends StatelessWidget {
  final double? height;
  const LoadingApp({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 90.h,
      child: Lottie.asset(Assets.iconsLoading,
              width: 90, height: 90, fit: BoxFit.cover)
          .onCenter,
    ).onCenter;
  }
}

class CustomProgress extends StatelessWidget {
  final double size;
  final double? strokeWidth;
  final Color? color;
  const CustomProgress(
      {Key? key, required this.size, this.strokeWidth, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth ?? 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(color ?? context.color.primary),
            ),
          ),
        ],
      ),
    );
  }
}
