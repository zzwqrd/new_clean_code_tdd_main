// // ignore_for_file: deprecated_member_use

// import 'dart:io';

// import 'package:base_flutter/general/constants/MyColors.dart';
// import 'package:tf_custom_widgets/widgets/MyText.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

// class AdaptivePicker {
//   static datePicker(
//       {required BuildContext context,
//       required Function(DateTime? date) onConfirm,
//       required String title,
//       DateTime? initial,
//       DateTime? minDate}) async {
//     if (Platform.isIOS) {
//       _iosDatePicker(context, onConfirm, title,
//           initial: initial, minDate: minDate);
//     } else {
//       _androidDatePicker(context, onConfirm,
//           initial: initial, minDate: minDate);
//     }
//   }

//   static _androidDatePicker(
//       BuildContext context, Function(DateTime? date) onConfirm,
//       {DateTime? initial, DateTime? minDate}) {
//     showRoundedDatePicker(
//         context: context,
//         initialDate: initial ?? DateTime.now(),
//         firstDate: minDate ?? DateTime.now().add(Duration(days: -1)),
//         lastDate: DateTime(2050),
//         borderRadius: 16,
//         height: 300,
//         theme: ThemeData.light().copyWith(
//           primaryColor: MyColors.primary,
//           hintColor: MyColors.black,
//           backgroundColor: MyColors.white,
//           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
//         )).then(onConfirm);
//   }

//   static _iosDatePicker(
//       BuildContext context, Function(DateTime? date) onConfirm, String title,
//       {DateTime? initial, DateTime? minDate}) {
//     _bottomSheet(
//       context: context,
//       child: cupertinoDatePicker(context, onConfirm, title,
//           initial: initial, minDate: minDate),
//     );
//   }

//   static Widget cupertinoDatePicker(
//       BuildContext context, Function(DateTime? date) onConfirm, String title,
//       {DateTime? initial, DateTime? minDate}) {
//     DateTime _date = DateTime.now();
//     return Container(
//       height: 260,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 MyText(
//                   title: title,
//                   color: MyColors.blackOpacity,
//                   size: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     onConfirm(_date);
//                     Navigator.of(context).pop();
//                   },
//                   child: MyText(
//                     title: "Done",
//                     size: 14,
//                     color: MyColors.primary,
//                   ),
//                   style: ElevatedButton.styleFrom(
//                       elevation: 0, primary: MyColors.white),
//                 ),
//               ],
//             ),
//           ),
//           Flexible(
//             child: CupertinoDatePicker(
//               initialDateTime: initial ?? DateTime.now(),
//               onDateTimeChanged: (date) {
//                 _date = date;
//               },
//               minimumDate: minDate ?? DateTime.now().add(Duration(days: -1)),
//               mode: CupertinoDatePickerMode.date,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static timePicker(
//       {required BuildContext context,
//       required String title,
//       required Function(DateTime? date) onConfirm}) async {
//     if (Platform.isIOS) {
//       _iosTimePicker(context, title, onConfirm);
//     } else {
//       _androidTimePicker(context, onConfirm);
//     }
//   }

//   static _androidTimePicker(
//       BuildContext context, Function(DateTime date) onConfirm) {
//     var now = DateTime.now();
//     showRoundedTimePicker(
//       context: context,
//       theme: ThemeData(
//         primaryColor: MyColors.primary,
//         hintColor: MyColors.black,
//         backgroundColor: MyColors.white,
//         buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
//       ),
//       initialTime: TimeOfDay.now(),
//     ).then((time) => onConfirm(
//         DateTime(now.year, now.month, now.day, time!.hour, time.minute)));
//   }

//   static _iosTimePicker(
//       BuildContext context, String title, Function(DateTime? date) onConfirm) {
//     _bottomSheet(
//       context: context,
//       child: cupertinoTimePicker(context, title, onConfirm),
//     );
//   }

//   static Widget cupertinoTimePicker(
//       BuildContext context, String title, Function(DateTime? date) onConfirm) {
//     DateTime _date = DateTime.now();
//     return Container(
//       height: 260,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 MyText(
//                   title: title,
//                   color: MyColors.blackOpacity,
//                   size: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 SizedBox(
//                   height: 20,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       onConfirm(_date);
//                       Navigator.of(context).pop();
//                     },
//                     child: MyText(
//                       title: "Done",
//                       size: 14,
//                       color: MyColors.primary,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         elevation: 0, primary: MyColors.white),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Flexible(
//               child: CupertinoDatePicker(
//             onDateTimeChanged: (date) {
//               _date = date;
//             },
//             mode: CupertinoDatePickerMode.time,
//           )),
//         ],
//       ),
//     );
//   }

//   static _bottomSheet({required BuildContext context, required Widget child}) {
//     return showModalBottomSheet(
//       isScrollControlled: false,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(13),
//           topRight: Radius.circular(13),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       context: context,
//       builder: (context) => Container(
//         height: 320,
//         child: child,
//       ),
//     );
//   }
// }
