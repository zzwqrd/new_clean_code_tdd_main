// import 'dart:convert';
// import 'dart:io';
// import 'extintions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart' show SvgPicture;
// import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;
// // import 'package:lottie/lottie.dart';
// import 'package:shimmer/shimmer.dart';
// // import '../gen/assets.gen.dart';
// import '../services/server_gate.dart';

// class CustomImage extends StatelessWidget {
//   final String path;
//   final double? width;
//   final double? height;
//   final BoxFit? fit;
//   final Color? color;
//   final double? opacity;
//   final bool isFile;
//   final BoxBorder? border;
//   final BorderRadius? borderRadius;
//   final bool withoutCash;
//   const CustomImage(
//     this.path, {
//     Key? key,
//     this.width,
//     this.height,
//     this.fit,
//     this.color,
//     this.opacity,
//     this.border,
//     this.borderRadius,
//     this.isFile = false,
//     this.withoutCash = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (path.startsWith("http")) {
//       if (path.split(".").last.toLowerCase().contains("svg")) {
//         return SvgPicture.network(
//           path,
//           height: height,
//           width: width,
//           color: color,
//           cacheColorFilter: false,
//           fit: fit ?? BoxFit.contain,
//         );
//       } else {
//         return _CustomNetworkImage(
//           path,
//           height: height,
//           width: width,
//           opacity: opacity,
//           border: border,
//           fit: fit,
//           borderRadius: borderRadius,
//           withoutCash: withoutCash,
//         );
//       }
//     } else if (path.startsWith("assets") || isFile) {
//       return ClipRRect(
//         borderRadius: borderRadius ?? BorderRadius.zero,
//         child: Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(border: border, borderRadius: borderRadius),
//           child: Builder(builder: (context) {
//             if (isFile) {
//               return Image.file(
//                 File(path),
//                 height: height,
//                 width: width,
//                 color: color,
//                 opacity: AlwaysStoppedAnimation(opacity ?? 1),
//                 fit: fit ?? BoxFit.contain,
//               );
//             } else if (path.split(".").last.toLowerCase().contains("svg")) {
//               return SvgPicture.asset(
//                 path,
//                 height: height,
//                 width: width,
//                 color: color,
//                 cacheColorFilter: false,
//                 fit: fit ?? BoxFit.contain,
//               );
//             } else {
//               return Image.asset(
//                 path,
//                 gaplessPlayback: false,
//                 height: height,
//                 width: width,
//                 color: color,
//                 opacity: AlwaysStoppedAnimation(opacity ?? 1),
//                 fit: fit ?? BoxFit.contain,
//               );
//             }
//           }),
//         ),
//       );
//     } else {
//       return ClipRRect(
//         borderRadius: borderRadius ?? BorderRadius.zero,
//         child: Container(
//           height: height,
//           width: width,
//           padding: EdgeInsets.all(10.h),
//           decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(.5)), borderRadius: borderRadius),
//           child: Center(
//             child: Icon(
//               Icons.image_not_supported,
//               color: Colors.grey.withOpacity(.5),
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }

// ImageProvider providerImage(String path, {double? height, double? width}) {
//   if (path.split(".").last.toLowerCase().contains("svg")) {
//     return provider.Svg(path);
//   } else {
//     return AssetImage(path);
//   }
// }

// class CustomIconImg extends StatelessWidget {
//   final String img;
//   final double? size;
//   final Color? color;

//   const CustomIconImg(this.img, {Key? key, this.size, this.color}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ImageIcon(
//       providerImage(img),
//       color: color,
//       size: size ?? 20.h,
//     );
//   }
// }

// class _CustomNetworkImage extends StatelessWidget {
//   final String? url;
//   final double? height;
//   final double? width;
//   final double? opacity;
//   final BoxBorder? border;
//   final BoxFit? fit;
//   final BorderRadius? borderRadius;
//   final bool withoutCash;
//   const _CustomNetworkImage(
//     this.url, {
//     Key? key,
//     this.height,
//     this.width,
//     this.opacity,
//     this.fit,
//     this.borderRadius,
//     this.border,
//     required this.withoutCash,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: borderRadius ?? BorderRadius.zero,
//       child: CustomProductImage(
//         height: height,
//         width: width,
//         opacity: opacity,
//         fit: fit,
//         border: border,
//         borderRadius: borderRadius,
//         image: url!,
//         withoutCash: withoutCash,
//       ),
//     );
//   }
// }

// class CustomProductImage extends StatefulWidget {
//   final String image;
//   final double? height, opacity, width;
//   final BoxFit? fit;
//   final BorderRadius? borderRadius;
//   final BoxBorder? border;
//   final bool withoutCash;
//   const CustomProductImage(
//       {Key? key, required this.image, this.height, this.width, this.fit, this.borderRadius, this.opacity = 1, this.border, required this.withoutCash})
//       : super(key: key);

//   @override
//   State<CustomProductImage> createState() => _CustomProductImageState();
// }

// class _CustomProductImageState extends State<CustomProductImage> {
//   String? image;
//   Future<String?> downloadImage() async {
//     try {
//       if (widget.image.isNotEmpty) {
//         image = widget.image;
//         return await ServerGate.i.imageBase64(widget.image);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   late Future<String?> future;
//   int? get cacheWidth {
//     if (!widget.withoutCash) {
//       return null;
//     } else if (widget.width?.isInfinite != false) {
//       return 500;
//     } else {
//       return (widget.width! * 1.5).toInt();
//     }
//   }

//   int? get cacheHeight {
//     if (!widget.withoutCash) {
//       return null;
//     } else if (widget.height?.isInfinite != false) {
//       return 500;
//     } else {
//       return (widget.height! * 1.5).toInt();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.image != image) future = downloadImage();
//     return Container(
//       height: widget.height,
//       width: widget.width,
//       decoration: BoxDecoration(borderRadius: widget.borderRadius ?? BorderRadius.zero, border: widget.border),
//       child: ClipRRect(
//         borderRadius: widget.borderRadius ?? BorderRadius.zero,
//         child: FutureBuilder<String?>(
//           future: future,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return loading;
//             } else if (snapshot.hasData) {
//               return Image.memory(
//                 base64Decode(snapshot.data!),
//                 opacity: AlwaysStoppedAnimation<double>(widget.opacity ?? 1),
//                 fit: widget.fit ?? BoxFit.contain,
//                 scale: 1,
//                 gaplessPlayback: true,
//                 excludeFromSemantics: true,
//                 cacheWidth: cacheWidth,
//                 cacheHeight: cacheHeight,
//                 filterQuality: widget.withoutCash ? FilterQuality.low : FilterQuality.high,
//                 // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
//                 //   if (wasSynchronouslyLoaded) return child;
//                 //   return AnimatedOpacity(
//                 //     opacity: frame == null ? 0 : 1,
//                 //     duration: 200.milliseconds,
//                 //     curve: Curves.linear,
//                 //     child: child,
//                 //   );
//                 //   // return child;
//                 // },
//                 errorBuilder: (context, error, stackTrace) {
//                   return errorWidget;
//                 },
//               );
//             } else {
//               return errorWidget;
//             }
//           },
//         ),
//       ),
//     );
//   }
//   Widget get loading => Container(
//         width: widget.width,
//         height: widget.height,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(borderRadius: widget.borderRadius ?? BorderRadius.zero),
//         child: Shimmer.fromColors(
//           highlightColor: context.theme.primaryColorLight,
//           baseColor: context.theme.hoverColor.withOpacity(0.1),
//           child: CustomImage(Assets.svg.logo, height: 20.h).onCenter.paddingAll(horizontal: 10.w),
//         ),
//       );
//   Widget get errorWidget => Center(
//         child: GestureDetector(
//           onTap: () => downloadImage(),
//           child: ClipRRect(
//             borderRadius: widget.borderRadius ?? BorderRadius.zero,
//             child: Container(
//               height: widget.height,
//               width: widget.width,
//               decoration: BoxDecoration(
//                 border: Border.all(color: context.theme.hoverColor),
//                 borderRadius: widget.borderRadius ?? BorderRadius.zero,
//               ),
//               alignment: Alignment.center,
//               child: Icon(
//                 Icons.replay_outlined,
//                 color: context.theme.hoverColor,
//                 size: 30,
//               ),
//             ),
//           ),
//         ),
//       );
// }

// class CustomLottie extends StatefulWidget {
//   final Function onFinished;
//   final double? height;
//   final double? width;
//   final String url;
//   final BoxFit? fit;
//   const CustomLottie({Key? key, required this.onFinished, this.height, this.width, required this.url, this.fit}) : super(key: key);
//   @override
//   State<CustomLottie> createState() => _CustomLottieState();
// }

// class _CustomLottieState extends State<CustomLottie> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation animation;
//   @override
//   void initState() {
//     _controller = AnimationController(duration: 3.seconds, vsync: this);
//     _controller.forward();
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         widget.onFinished();
//       } else if (status == AnimationStatus.dismissed) {
//         _controller.forward();
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Lottie.asset(
//       widget.url,
//       controller: _controller,
//       width: widget.width,
//       height: widget.height,
//       reverse: false,
//       fit: widget.fit,
//     );
//   }
// }
