// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_button.dart';
import 'theme.dart';

Padding customBtn({
  double? width,
  EdgeInsetsGeometry? padding,
  double? height,
  String? title,
  Color? titleColor,
  Color? btnColor,
  Color? borderColor,
  String? fontFamily,
  double? fontSize,
  dynamic onTap,
}) {
  return Padding(
    padding: padding ?? EdgeInsets.symmetric(horizontal: 50.0.w),
    child: InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(height != null ? (height / 2) : 30.h),
          border: Border.all(color: borderColor ?? Colors.white),
          color: btnColor ?? Colors.white,
        ),
        width: width,
        height: height ?? 60.h,
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
              color: titleColor,
              fontFamily: fontFamily,
              fontSize: fontSize ?? 20,
            ),
          ),
        ),
      ),
    ),
  );
}

class CustomElevatedButton extends BaseButton {
  const CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: Container(
          height: height ?? 55.h,
          width: width ?? double.maxFinite,
          margin: margin,
          decoration: decoration,
          child: ElevatedButton(
            style: buttonStyle ??
                ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      StylesApp.instance.colorButton),
                  foregroundColor: WidgetStateProperty.all<Color>(
                      StylesApp.instance.colorButton),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
            onPressed: isDisabled ?? false ? null : onPressed ?? () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leftIcon ?? const SizedBox.shrink(),
                Text(
                  text,
                  style: buttonTextStyle ?? StylesApp.instance.appStayle,
                ),
                rightIcon ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
}
