// import 'package:flutter/material.dart';
// import 'package:flutter_chat_bubble/bubble_type.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
// import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
// import 'package:speed4ever/helper/gallery_preview.dart';
// import 'package:speed4ever/helper/rout.dart';
// import '../gen/fonts.gen.dart';
// import 'asset_image.dart';
// import 'extintions.dart';

// getReceiverView(BuildContext context, String text, String type, String createdAt) => Column(
//       children: [
//         ChatBubble(
//             elevation: 1,
//             clipper: ChatBubbleClipper1(
//               type: BubbleType.receiverBubble,
//             ),
//             backGroundColor: "#F7F5EF".toColor,
//             margin: EdgeInsets.only(top: 12.w, right: 12.w, left: 12.w),
//             child: Container(
//               margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 14.w),
//               child: Builder(builder: (context) {
//                 if (type == "image") {
//                   return InkWell(
//                     onTap: () {
//                       push(GalleryPreviewPage([text]));
//                     },
//                     child: CustomNetworkImage(
//                       text,
//                       height: 190.h,
//                       fit: BoxFit.contain,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   );
//                 }
//                 return Text(
//                   text,
//                   style: TextStyle(color: "#14203F".toColor, fontFamily: FontFamily.somarRegular, fontSize: ScreenScale.convertFontSize(14)),
//                 );
//               }),
//             )),
//         Padding(
//           padding: EdgeInsets.only(top: 5.w, right: 12.w, left: 12.w),
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               createdAt,
//               style: context.textTheme.bodySmall!.copyWith(fontSize: 10),
//             ),
//           ),
//         )
//       ],
//     );
// getSenderView(BuildContext context, String text, String type, String createdAt) => Column(
//       children: [
//         ChatBubble(
//           elevation: 1,
//           clipper: ChatBubbleClipper9(
//             type: BubbleType.sendBubble,
//           ),
//           alignment: Alignment.topRight,
//           backGroundColor: "#6C98A2".toColor,
//           margin: EdgeInsets.only(top: 12.w, right: 12.w, left: 12.w),
//           child: Container(
//             margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 14.w),
//             // constraints: BoxConstraints(
//             //   maxWidth: MediaQuery.of(context).size.width * 0.7,
//             // ),
//             child: Builder(builder: (context) {
//               if (type == "image") {
//                 return CustomNetworkImage(
//                   text,
//                   height: 190.h,
//                   fit: BoxFit.contain,
//                   width: 190.h,
//                   borderRadius: BorderRadius.circular(12),
//                 );
//               }
//               return Text(
//                 text,
//                 style: TextStyle(color: Colors.white, fontFamily: FontFamily.somarRegular, fontSize: ScreenScale.convertFontSize(14)),
//               );
//             }),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.only(top: 5.w, right: 12.w, left: 12.w),
//           child: Align(
//             alignment: Alignment.topRight,
//             child: Text(
//               createdAt,
//               style: context.textTheme.bodySmall!.copyWith(fontSize: 10),
//             ),
//           ),
//         )
//       ],
//     );
