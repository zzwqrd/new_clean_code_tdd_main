// ignore_for_file: sort_child_properties_last

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../loading_app.dart';
import '../widget_utils.dart';
import 'CustomButtonAnimation.dart';

class LoadingButton extends StatelessWidget {
  final GlobalKey<CustomButtonState> btnKey;
  final String title;
  final Function() onTap;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;

  const LoadingButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.textColor,
    this.borderRadius,
    this.margin,
    this.borderColor,
    this.fontFamily,
    this.fontSize,
    this.width,
    this.height,
    this.fontWeight,
    required this.btnKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      // margin:
      //     margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          CustomButtonAnimation(
            key: btnKey,
            onTap: onTap,
            width: width ?? MediaQuery.of(context).size.width,
            minWidth: 55,
            height: height ?? 60,
            color: color ?? WidgetUtils.primaryColor,
            borderRadius: borderRadius ?? 20,
            borderSide: BorderSide(
                color: borderColor ??
                    const Color.fromARGB(0, 255, 255, 255).withOpacity(0.0),
                width: 1),
            child: MyText(
              title: title,
              size: fontSize ?? 11,
              color: textColor ?? Colors.white,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
            ),
            loader: const LoadingBtn(),
            // loader: Container(
            //   height: 190,
            //   padding: const EdgeInsets.all(10),
            //   child: const LoadingBtn(),
            //   // child: const SpinKitRotatingCircle(
            //   //   color: Colors.white,
            //   //   size: 20,
            //   // ),
            // ),
          ),
        ],
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String title;
  final Color? color;
  final double? size;
  final double? letterSpace;
  final double? wordSpace;
  final String? fontFamily;
  final TextAlign? alien;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  const MyText(
      {super.key,
      required this.title,
      required this.color,
      required this.size,
      this.alien,
      this.fontFamily,
      this.decoration,
      this.letterSpace,
      this.wordSpace,
      this.overflow,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: alien ?? TextAlign.start,
      textScaleFactor: WidgetUtils.textScaleFactor ?? 1.2,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: size ?? 16,
        letterSpacing: letterSpace,
        wordSpacing: wordSpace,
        decoration: decoration ?? TextDecoration.none,
        fontWeight: fontWeight ??
            (context.locale.languageCode == "ar"
                ? FontWeight.w500
                : FontWeight.w200),
        fontFamily: fontFamily ?? WidgetUtils.fontFamily,
      ),
      overflow: overflow,
    );
  }
}

class SpinKitRotatingCircle extends StatefulWidget {
  const SpinKitRotatingCircle({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitRotatingCircleState createState() => _SpinKitRotatingCircleState();
}

class _SpinKitRotatingCircleState extends State<SpinKitRotatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation1 = Tween(begin: 0.0, end: 180.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
    _animation2 = Tween(begin: 0.0, end: 180.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut)));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX((0 - _animation1.value) * 0.0174533)
          ..rotateY((0 - _animation2.value) * 0.0174533),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
            size: Size.square(widget.size), child: _itemBuilder(0)),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle));
}
