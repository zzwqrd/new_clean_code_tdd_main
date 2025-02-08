import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../gen/fonts.gen.dart';
import '../../../main.dart';
import 'extintions.dart';

class StylesApp {
  static final StylesApp instance = StylesApp._internal();

  StylesApp._internal();
  // final appStoreUtl

  final mainColor = "#691f23".toColor;
  final grayColor = "#535461".toColor;

  final backgroundColor = "#bdcbda".toColor;

  final colorButton = "#21272d".toColor;

  final baseShimmerColor = Colors.grey.shade200;
  final highlightShimmerColor = Colors.white;
  final primaryColorLight = Colors.white;
  final primaryColor = "#29398C".toColor;
  final hintColor = "#8E8EA9".toColor;
  final errorColor = "#FF0000".toColor;
  final primaryContainer = "#F9F9F9".toColor;
  final primaryColorDark = Colors.black;
  final textColor = "#505050".toColor;
  final borderColor = "#EDEDED".toColor;

  TextTheme get englishTheme => TextTheme(
        displayLarge: TextStyle(
            fontWeight: FontWeight.w900,
            color: primaryColorDark), // Black mostly
        displayMedium: TextStyle(
            fontWeight: FontWeight.w800, color: primaryColorDark), // Extra-bold
        displaySmall: TextStyle(
            fontWeight: FontWeight.w700, color: primaryColorDark), // bold
        titleLarge: TextStyle(
            fontWeight: FontWeight.w600, color: primaryColorDark), // semi bold
        titleMedium:
            TextStyle(fontWeight: FontWeight.w500, color: textColor), // medium
        bodyMedium:
            TextStyle(fontWeight: FontWeight.w400, color: textColor), // regular
        bodySmall:
            TextStyle(fontWeight: FontWeight.w300, color: textColor), // Light
      );

  final double hight = 20;

  final TextStyle appStayle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  final TextStyle appStayleTow = TextStyle(
    fontSize: 14,
    color: "#691f23".toColor,
  );
  // TextTheme get arabicTheme => TextTheme(
  //       headlineLarge: TextStyle(fontFamily: FontFamily.montserratSemiBold, fontSize: 36, color: primaryColorDark),
  //       titleLarge: TextStyle(fontSize: 12.0, fontFamily: FontFamily.montserratSemiBold, color: primaryColorDark),
  //       headlineSmall: TextStyle(fontSize: 14.0, fontFamily: FontFamily.montserratSemiBold, color: primaryColorDark),
  //       headlineMedium: TextStyle(fontSize: 16.0, fontFamily: FontFamily.montserratSemiBold, color: primaryColorDark),
  //       displayMedium: TextStyle(fontFamily: FontFamily.montserratSemiBold, fontSize: 20.0, color: primaryColorDark),
  //       displayLarge: TextStyle(fontFamily: FontFamily.montserratBold, fontSize: 16.0, color: primaryColorDark),
  //       titleSmall: TextStyle(fontFamily: FontFamily.montserratMedium, fontSize: 16.0, color: primaryColorDark),
  //       titleMedium: TextStyle(fontFamily: FontFamily.montserratMedium, fontSize: 18.0, color: primaryColorDark),
  //       bodyLarge: TextStyle(fontFamily: FontFamily.montserratRegular, fontSize: 18.0, color: primaryColorDark),
  //       bodyMedium: TextStyle(fontFamily: FontFamily.montserratRegular, fontSize: 14.0, color: primaryColorDark),
  //       bodySmall: TextStyle(fontSize: 14.0, fontFamily: FontFamily.montserratLight, color: primaryColorDark),
  //     );
  // TextTheme get englishThemeDark => TextTheme(
  //       headlineLarge: TextStyle(fontFamily: FontFamily.interSemiBold, fontSize: 36, color: primaryColorLight),
  //       titleLarge: TextStyle(fontSize: 12.0, fontFamily: FontFamily.interSemiBold, color: primaryColorLight),
  //       headlineSmall: TextStyle(fontSize: 14.0, fontFamily: FontFamily.interSemiBold, color: primaryColorLight),
  //       headlineMedium: TextStyle(fontSize: 16.0, fontFamily: FontFamily.interSemiBold, color: primaryColorLight),
  //       displayMedium: TextStyle(fontFamily: FontFamily.interSemiBold, fontSize: 20.0, color: primaryColorLight),
  //       displayLarge: TextStyle(fontFamily: FontFamily.interBold, fontSize: 16.0, color: primaryColorLight),
  //       titleSmall: TextStyle(fontFamily: FontFamily.interMedium, fontSize: 16.0, color: primaryColorLight),
  //       titleMedium: TextStyle(fontFamily: FontFamily.interMedium, fontSize: 18.0, color: primaryColorLight),
  //       bodyLarge: TextStyle(fontFamily: FontFamily.interRegular, fontSize: 18.0, color: primaryColorLight),
  //       bodyMedium: TextStyle(fontFamily: FontFamily.interRegular, fontSize: 14.0, color: primaryColorLight),
  //       bodySmall: TextStyle(fontSize: 14.0, fontFamily: FontFamily.interLight, color: primaryColorLight),
  //     );
  // TextTheme get arabicThemeDark => TextTheme(
  //       headlineLarge: TextStyle(fontFamily: FontFamily.montserratSemiBold, fontSize: 36, color: primaryColorLight),
  //       titleLarge: TextStyle(fontSize: 12.0, fontFamily: FontFamily.montserratSemiBold, color: primaryColorLight),
  //       headlineSmall: TextStyle(fontSize: 14.0, fontFamily: FontFamily.montserratSemiBold, color: primaryColorLight),
  //       headlineMedium: TextStyle(fontSize: 16.0, fontFamily: FontFamily.montserratSemiBold, color: primaryColorLight),
  //       displayMedium: TextStyle(fontFamily: FontFamily.montserratSemiBold, fontSize: 20.0, color: primaryColorLight),
  //       displayLarge: TextStyle(fontFamily: FontFamily.montserratBold, fontSize: 16.0, color: primaryColorLight),
  //       titleSmall: TextStyle(fontFamily: FontFamily.montserratMedium, fontSize: 16.0, color: primaryColorLight),
  //       titleMedium: TextStyle(fontFamily: FontFamily.montserratMedium, fontSize: 18.0, color: primaryColorLight),
  //       bodyLarge: TextStyle(fontFamily: FontFamily.montserratRegular, fontSize: 18.0, color: primaryColorLight),
  //       bodyMedium: TextStyle(fontFamily: FontFamily.montserratRegular, fontSize: 14.0, color: primaryColorLight),
  //       bodySmall: TextStyle(fontSize: 14.0, fontFamily: FontFamily.montserratLight, color: primaryColorLight),
  //     );

  ThemeData getLightTheme(Locale locale) {
    return ThemeData(
      platform: TargetPlatform.iOS,
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      hintColor: hintColor,
      primaryColorDark: primaryColorDark,
      brightness: Brightness.light,
      fontFamily: "ExtraBold",
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: Colors.white,
        error: errorColor,
        primaryContainer: primaryContainer,
        secondary: textColor,
        tertiary: borderColor,
        // tertiaryContainer: tertiaryContainer,
        // secondaryContainer: priceColor,
        // inversePrimary: flashSaleColor,
        inverseSurface: baseShimmerColor,
        onInverseSurface: highlightShimmerColor,
      ),
      iconTheme: IconThemeData(size: 20.h),
      textTheme: englishTheme,
      scaffoldBackgroundColor: StylesApp.instance.backgroundColor,
      appBarTheme: AppBarTheme(
        toolbarHeight: 50,
        iconTheme: IconThemeData(size: 20.h),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.white,
        shadowColor: hintColor,
        elevation: 0.1,
        titleTextStyle: const TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: primaryColor, size: 20.h),
        unselectedIconTheme: IconThemeData(color: hintColor, size: 20.h),
        selectedLabelStyle: TextStyle(fontSize: 12, color: primaryColor),
        unselectedLabelStyle: TextStyle(fontSize: 12, color: hintColor),
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: navigator.currentContext?.textTheme.bodySmall
            ?.copyWith(color: Colors.grey.shade300, fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: TextStyle(
          fontSize: 10,
          height: 1,

          // fontFamily: locale.languageCode == "ar" ? FontFamily.montserratLight : FontFamily.interLight,
          color: errorColor,
          fontStyle: FontStyle.italic,
        ),
        errorMaxLines: 2,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(10.h)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(10.h)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10.h)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(10.h)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorColor),
            borderRadius: BorderRadius.circular(10.h)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(10.h)),
      ),
    );
  }

  ThemeData getDarkTheme(Locale locale) {
    return ThemeData(
      platform: TargetPlatform.iOS,
      primaryColor: Colors.black,
      primaryColorLight: "#303030".toColor,
      hintColor: Colors.black,
      primaryColorDark: primaryColorLight,
      brightness: Brightness.dark,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      colorScheme: ColorScheme.dark(
        primary: Colors.black,
        surface: Colors.black,
        secondary: Colors.black,
        primaryContainer: primaryContainer,
        // tertiary: tertiary,
        // tertiaryContainer: tertiaryContainer,
        // secondaryContainer: priceColor,
        // inversePrimary: flashSaleColor,
        inverseSurface: "#303030".toColor,
        onInverseSurface: "#303030".toColor.withOpacity(.5),
      ),
      iconTheme: IconThemeData(size: 20.h, color: primaryColorLight),
      // textTheme: arabicThemeDark,
      // scaffoldBackgroundColor: scaffoldBackgroundDarkColor,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(size: 20.h),
        color: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: navigator.currentContext?.textTheme.bodyMedium
            ?.copyWith(color: hintColor, fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorStyle: TextStyle(
          fontSize: 10,
          // fontFamily: locale.languageCode == "ar" ? FontFamily.montserratLight : FontFamily.interLight,
          color: errorColor,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
