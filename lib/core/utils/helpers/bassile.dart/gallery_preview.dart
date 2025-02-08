// import 'package:flutter/material.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:speed4ever/helper/theme.dart';

// class GalleryPreviewPage extends StatefulWidget {
//   final List<String> images;

//   const GalleryPreviewPage(
//     this.images, {
//     Key? key,
//   }) : super(key: key);

//   @override
//   _GalleryPreviewPageState createState() => _GalleryPreviewPageState();
// }

// class _GalleryPreviewPageState extends State<GalleryPreviewPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         // onTapDown: ( x) => _getBack(),
//         child: Stack(
//           children: <Widget>[
//             Swiper(
//               itemBuilder: (context, int index) {
//                 return
//                   PhotoView(
//                   imageProvider:
//                   // widget.images != null
//                   //     ?

//                   NetworkImage(
//                           widget.images[index],
//                         ),
//                   //     :,
//                   // AssetImage(
//                   //         "assets/icons/logo.png",
//                   //       ),
//                   minScale: PhotoViewComputedScale.contained,
//                   filterQuality: FilterQuality.high,
// //                    onTapDown: (context, details, controllerValue) =>
// //                        _getBack(),
// //                     enableRotation: true,
//                 );
//               },
//               itemCount: widget.images.length,
//               outer: false,
//               // autoplay: widget.images.length == 1 ? false : true,
//               pagination:
//                   widget.images.length != 1 ? SwiperPagination() : null,
//               // control: new SwiperControl(
//               //   color: AppTheme.secondaryColor,
//               // ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: GestureDetector(
// //              onTapDown: (details) => _getBack(),
//                 onTap: () {
//                   _getBack();
//                 },
// //              onDoubleTapCancel: () {
// //                _getBack();
// //              },
// //              onPanCancel: () {
// //                _getBack();
// //              },
//                 child: const Center(
//                   child: Icon(
//                     Icons.close,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _getBack() {
//     Navigator.of(context).pop();
//   }
// }
