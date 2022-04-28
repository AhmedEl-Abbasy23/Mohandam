import 'package:localize_and_translate/localize_and_translate.dart';

class MyLocalization {
  static localizationSetup() async{
    await translator.init(
      localeType: LocalizationDefaultType.device,
      languagesList: <String>['ar', 'en'],
      assetsDirectory: 'assets/locale/',
    );
    // To check app language.
    // translator.activeLanguageCode != 'ar' ?
  }

  static changeLanguage(context) {
    translator.setNewLanguage(
      context,
      newLanguage: translator.activeLanguageCode == 'ar' ? 'en' : 'ar',
      remember: true,
      restart: true,
    );
  }
}