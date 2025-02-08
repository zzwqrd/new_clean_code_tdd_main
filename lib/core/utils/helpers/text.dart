import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import 'extintions.dart';

Widget lengthTetx({
  BuildContext? contaxt,
  dynamic txt,
  int? nu,
}) {
  return Text(
    txt.length > nu ? txt.substring(0, nu) + "...." : txt,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  );
}

Widget myBoledText({
  BuildContext? contaxt,
  dynamic txt,
  double? size,
  FontWeight? fontWeight,
  String? fontFamily,
}) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: size ?? 12,
      fontWeight: fontWeight ?? FontWeight.w900,
      color: "#535461".toColor,
      fontFamily: fontFamily ?? Assets.fontsCairoRegular,
    ),
  );
}
