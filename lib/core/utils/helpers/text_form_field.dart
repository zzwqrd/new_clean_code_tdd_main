import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'theme.dart';

Widget txtField(
    {BuildContext? context,
    dynamic validator,
    dynamic onSaved,
    String? hintText,
    bool? enabled,
    dynamic maxLines,
    TextInputType? textInputType,
    // String? prefix,
    bool? obscureText,
    Color? color,
    TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.only(
      right: 15,
      left: 15,
    ),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      enabled: enabled,
      maxLines: maxLines,
      // textAlignVertical: TextAlignVertical.bottom,
      // textAlign: TextAlign.end,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,

      style: const TextStyle(
        //
        color: Color(0xFFC1C1C1),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Color(0xFFF6F6F6),
          ),
        ),
        errorStyle: const TextStyle(
          //
          color: Color(0xFFC1C1C1),
          fontSize: 13,
        ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Image.asset(
        //     prefix ?? "",
        //     width: 20,
        //     height: 20,
        //   ),
        // ),
        contentPadding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        filled: true,
        fillColor: color ?? const Color(0xFFF6F6F6),
        enabled: true,
        labelText: hintText == null ? "" : hintText.tr(),
        labelStyle: TextStyle(
          color: StylesApp.instance.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget textareaForm(
    {BuildContext? context,
    // dynamic validator,
    // dynamic onSaved,
    String? hintText,
    bool? enabled,
    dynamic maxLines,
    TextInputType? textInputType,
    // String? prefix,
    bool? obscureText,
    Color? color,
    TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.only(
      right: 15,
      left: 15,
    ),
    child: TextField(
      // validator: validator,
      controller: controller,
      // onSaved: onSaved,
      enabled: enabled,
      maxLines: maxLines,
      // textAlignVertical: TextAlignVertical.bottom,
      // textAlign: TextAlign.end,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,

      style: const TextStyle(
        //
        color: Color(0xFFC1C1C1),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Color(0xFFF6F6F6),
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFC1C1C1),
          fontSize: 13,
        ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Image.asset(
        //     prefix ?? "",
        //     width: 20,
        //     height: 20,
        //   ),
        // ),
        contentPadding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        filled: true,
        fillColor: color ?? const Color(0xFFF6F6F6),
        enabled: true,
        labelText: hintText == null ? "" : hintText.tr(),
        labelStyle: TextStyle(
          color: StylesApp.instance.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget txtField2(
    {BuildContext? context,
    dynamic validator,
    dynamic onSaved,
    String? hintText,
    bool? enabled,
    TextInputType? textInputType,
    // String? prefix,
    bool? obscureText,
    TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.only(
      right: 10,
      left: 10,
    ),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      enabled: enabled,
      //   textAlign: TextAlign.center,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,

      style: const TextStyle(
        color: Color(0xFFC1C1C1),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFC1C1C1),
          fontSize: 13,
        ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Image.asset(
        //     prefix ?? "",
        //     width: 20,
        //     height: 20,
        //   ),
        // ),
        contentPadding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),

        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        enabled: true,
        labelText: hintText == null ? "" : hintText.tr(),
        labelStyle: TextStyle(
          color: StylesApp.instance.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget txtFieldPass(
    {BuildContext? context,
    dynamic validator,
    dynamic onSaved,
    String? hintText,
    bool? enabled,
    Widget? suffix,
    TextInputType? textInputType,
    // String? prefix,
    bool? obscureText,
    TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.only(
      right: 15,
      left: 15,
    ),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      enabled: enabled,
      //   textAlign: TextAlign.center,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,

      style: const TextStyle(
        color: Color(0xFFC1C1C1),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Color(0xFFF6F6F6),
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFC1C1C1),
          fontSize: 13,
        ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Image.asset(
        //     prefix ?? "",
        //     width: 20,
        //     height: 20,
        //   ),
        // ),
        contentPadding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        enabled: true,
        labelText: hintText == null ? "" : hintText.tr(),
        labelStyle: TextStyle(
          color: StylesApp.instance.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        suffix: suffix,
      ),
    ),
  );
}

Widget txtFieldPass2(
    {BuildContext? context,
    dynamic validator,
    dynamic onSaved,
    String? hintText,
    bool? enabled,
    Widget? suffix,
    TextInputType? textInputType,
    // String? prefix,
    bool? obscureText,
    TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.only(
      right: 15,
      left: 15,
    ),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onSaved: onSaved,
      enabled: enabled,
      //   textAlign: TextAlign.center,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,

      style: const TextStyle(
        color: Color(0xFFC1C1C1),
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFC1C1C1),
          fontSize: 13,
        ),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Image.asset(
        //     prefix ?? "",
        //     width: 20,
        //     height: 20,
        //   ),
        // ),
        contentPadding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: StylesApp.instance.primaryColor,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        enabled: true,
        labelText: hintText == null ? "" : hintText.tr(),
        labelStyle: TextStyle(
          color: StylesApp.instance.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        suffix: suffix,
      ),
    ),
  );
}

Widget searsh({
  context,
  dynamic validator,
  dynamic onSaved,
  String? hintText,
  bool? enabled,
  TextInputType? textInputType,
  bool? obscureText,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      right: 5,
      left: 5,
    ),
    child: TextFormField(
      validator: validator,
      controller: controller,
      enabled: enabled,
      onSaved: onSaved,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        fillColor: const Color(0xFFF6F6F6),
        filled: true,
        isDense: true, // Added this
        contentPadding: const EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFF6F6F6), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFFF6F6F6), width: 0.5),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFA9A9A9),
          fontSize: 16,
          // fontFamily: FontFamily.neoSansArabicLight,
        ),
        hintText: hintText,
      ),
    ),
  );
}

TextFormField textFormField({
  BuildContext? context,
  String? hintText,
  TextInputType? textInputType,
  bool obscureText = false,
  TextEditingController? controller,
  dynamic onValidate,
  dynamic onSave,
  Function(String)? onFieldSubmitted,
  bool enabled = true,
  int maxLines = 1,
  bool label = true,
  bool error = false,
}) {
  return TextFormField(
    onFieldSubmitted: onFieldSubmitted,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    maxLines: maxLines,
    controller: controller,
    enabled: enabled,
    validator: onValidate,
    onSaved: onSave,
    obscureText: obscureText,
    keyboardType: textInputType,
    cursorHeight: 20,
    // cursorColor: hintTextColor,
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 17,
    ),
    decoration: InputDecoration(
      errorStyle: const TextStyle(fontSize: 0, height: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      filled: false,

      // fillColor: Color(0xFFF6F6F6),
      // focusColor: secondTextColor,
      // hoverColor: secondTextColor,
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      labelText: label ? hintText : null,
      labelStyle: label
          ? const TextStyle(
              height: 0,
              fontSize: 20,
              color: Colors.black,
              // fontFamily: FontFamily.cairoRegular,
            )
          : null,
      //  errorText: snapshot.error,
      hintText: label ? null : hintText,
      hintStyle: label
          ? null
          : TextStyle(
              height: 0,
              fontSize: 17,
              color: error ? Colors.red : Colors.grey,
              // fontFamily: FontFamily.cairoRegular,x
            ),
    ),
  );
}
