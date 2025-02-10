import '../../generated/assets.dart';

class AppConstants {
  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Assets.iconsArabicFlag,
        languageName: 'العربية',
        countryCode: 'SA',
        languageCode: 'ar'),
    // LanguageModel(
    //     imageUrl: Images.englandFlag,
    //     languageName: 'English',
    //     countryCode: 'US',
    //     languageCode: 'en'),
  ];
}

class LanguageModel {
  String? imageUrl;
  String? languageName;
  String? languageCode;
  String? countryCode;

  LanguageModel(
      {this.imageUrl, this.languageName, this.countryCode, this.languageCode});
}
