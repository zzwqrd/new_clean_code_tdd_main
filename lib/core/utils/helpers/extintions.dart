import 'package:flutter/material.dart';

extension StringEx on String {
  bool get isEmail => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this);
  bool get isPass =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
          .hasMatch(this);
  // final _emailReg = RegExp(r'[a-z]+\d*@[a-z]+\.[a-z]{3}', caseSensitive: false);
  // final _phoneReg = RegExp(r'^(966)?0?[0-9]{9}');
  // final _passwordReg = RegExp(r"(?=.[a-z])(?=.[A-Z])(?=.*[0-9])");
  // final _arabicPhoneNumbersReg = RegExp(r"[\u0661-\u0669]");
  // final _arabicTextReg = RegExp(r"[\u0600-\u06ff]+");
  // final _cardNumbersReg = RegExp(r"[0-9].{4}");
  String get replaceArabicNumbers => replaceAllMapped(
      RegExp(r"[\u0661-\u0669]"), (m) => '${(m[0]!.codeUnits[0] - 1584) - 48}');

  Color get toColor {
    String colorStr = trim();
    if (colorStr.length == 7) colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException(
            "An error occurred when converting a color");
      }
    }
    return Color(val);
  }

  int get toColorValue {
    String colorStr = this;
    colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException(
            "An error occurred when converting a color");
      }
    }
    return val;
  }

  // setPrefs(String key) => Prefs.setString(key, this);
}

extension NumEx on int {
  Duration get hours => Duration(hours: this);
  Duration get day => Duration(days: this);
  Duration get minutes => Duration(minutes: this);
  Duration get seconds => Duration(seconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
}

extension WidgetEx on Widget {
  Widget paddingAll(
      {double all = 0.0,
      double vertical = 0.0,
      double horizontal = 0.0,
      double top = 0.0,
      double bottom = 0.0,
      double start = 0.0,
      double right = 0.0,
      double left = 0.0,
      double end = 0.0}) {
    return Padding(
      padding: EdgeInsets.all(all),
      child: Padding(
        padding: EdgeInsets.only(right: right, left: left),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
              top: top, bottom: bottom, start: start, end: end),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontal, vertical: vertical),
            child: this,
          ),
        ),
      ),
    );
  }

  Widget get topStart =>
      Align(alignment: AlignmentDirectional.topStart, child: this);
  Widget get topCenter => Align(alignment: Alignment.topCenter, child: this);
  Widget get topLeft => Align(alignment: Alignment.topLeft, child: this);
  Widget get topEnd =>
      Align(alignment: AlignmentDirectional.topEnd, child: this);
  Widget get bottomStart =>
      Align(alignment: AlignmentDirectional.bottomStart, child: this);
  Widget get centerStart =>
      Align(alignment: AlignmentDirectional.centerStart, child: this);
  Widget get centerEnd =>
      Align(alignment: AlignmentDirectional.centerEnd, child: this);
  Widget get bottomEnd =>
      Align(alignment: AlignmentDirectional.bottomEnd, child: this);
  Widget get bottomCenter =>
      Align(alignment: AlignmentDirectional.bottomCenter, child: this);
  Widget get onCenter => Center(child: this);
}

extension ContextEX on BuildContext {
  double get h => MediaQuery.of(this).size.height;
  double get w => MediaQuery.of(this).size.width;
  ColorScheme get color => Theme.of(this).colorScheme;
  Map<dynamic, dynamic> get arg =>
      (ModalRoute.of(this)?.settings.arguments ?? {}) as Map<dynamic, dynamic>;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension DateTimeEx on DateTime {
  // String get fE => DateFormat.E(LocaleKeys.Lang.tr()).format(this);
  // String get fYMD => DateFormat("yyyy-MM-dd", LocaleKeys.Lang.tr()).format(this);

  DateTime get iSO {
    var duration = timeZoneOffset;
    String time;
    if (duration.isNegative) {
      time =
          ("${toIso8601String()}-${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    } else {
      time =
          ("${toIso8601String()}+${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    }
    return DateTime.parse(time);
  }
}

extension DoubleEx on double {
  double max(double max) {
    return max >= this ? this : max;
  }
}
