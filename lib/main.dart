import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/cache_helper.dart';
import 'package:handmade_store/shared/localization.dart';
import 'package:handmade_store/shared/responsive.dart';
import 'package:handmade_store/view/onboarding_view.dart';
import 'package:handmade_store/view/splash_view.dart';
import 'package:handmade_store/view/verification_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MyLocalization.localizationSetup();
  await CacheHelper.init();
  runApp(LocalizedApp(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: translator.delegates,
      // Android + iOS Delegates
      locale: translator.activeLocale,
      // Device preview
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // Active locale
      supportedLocales: translator.locals(),
      // Locals list
      // home: OnBoardingScreen(),
      home: const SplashView(),
      theme: ThemeData(fontFamily: translator.activeLanguageCode == 'en'?'SFP-REGULAR':"CairoSemiBold"),
      builder: (context, widget) => MyResponsive.responsiveSetup(widget),
    );
  }
}
