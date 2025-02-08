import 'extintions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomProgress extends StatelessWidget {
  final double size;
  final double? strokeWidth;
  final Color? color;
  final double? value;
  final Color? backgroundColor;
  const CustomProgress({Key? key, required this.size, this.strokeWidth, this.color, this.backgroundColor, this.value}) : super(key: key);
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
              value: value,
              strokeWidth: strokeWidth ?? 2,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? context.theme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomProgress(size: 25.h).onCenter;
  }
}
