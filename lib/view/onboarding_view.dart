import 'package:flutter/material.dart';
import 'package:handmade_store/shared/cache_helper.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/my_colors.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/login_view.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: IntroductionScreen(
          controlsPadding: const EdgeInsets.symmetric(vertical: 5.0),
          pages: screens,
          onDone: () {
            navigatePushReplacement(context, const LoginView());
            CacheHelper.saveData(key: 'onBoarding', value: true);
          },
          onSkip: () {
            navigatePushReplacement(context, const LoginView());
          },
          showSkipButton: true,
          skip: const Icon(Icons.skip_next, color: Colors.white),
          next: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          done: Text(
            AppStrings.done.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.white,),),
          globalBackgroundColor: const Color(0xff096f77),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(25.0, 10.0),
            activeColor: Colors.white,
            color: Colors.white,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
  var screens = [
    PageViewModel(
      title: AppStrings.onBoardingTitle1.tr(),
      body: AppStrings.onBoardingBody1.tr(),
      image: Center(
        child: Lottie.asset("assets/json/welcome_intro1.json"),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        titlePadding: EdgeInsets.symmetric(vertical: 5.0),
        bodyPadding: EdgeInsets.symmetric(vertical: 5.0),
        titleTextStyle: TextStyle(
          color: MyColors.primary,
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
        bodyTextStyle: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.grey),
      ),
    ),
    PageViewModel(
      title: AppStrings.onBoardingTitle2.tr(),
      body: AppStrings.onBoardingBody2.tr(),
      image: Center(
        child: Lottie.asset("assets/json/onboarding2.json"),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        titlePadding: EdgeInsets.symmetric(vertical: 5.0),
        bodyPadding: EdgeInsets.symmetric(vertical: 5.0),
        titleTextStyle: TextStyle(
          color: Color(0xff096f77),
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
        bodyTextStyle: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.grey),
      ),
    ),
    PageViewModel(
      title: AppStrings.onBoardingTitle3.tr(),
      body: AppStrings.onBoardingBody3.tr(),
      image: Center(
        child: Lottie.asset("assets/json/handmade_screen4.json"),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        titlePadding: EdgeInsets.symmetric(vertical: 5.0),
        bodyPadding: EdgeInsets.symmetric(vertical: 5.0),
        titleTextStyle: TextStyle(
          color: Color(0xff096f77),
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
        bodyTextStyle: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.grey),
      ),
    ),
  ];
}
