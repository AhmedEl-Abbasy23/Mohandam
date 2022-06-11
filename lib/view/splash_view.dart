import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handmade_store/shared/cache_helper.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/view/login_view.dart';
import 'package:handmade_store/view/main_view.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(
      const Duration(milliseconds: 2500),
      _goNext,
    );
  }

  _goNext() async {
    bool onBoarding = await CacheHelper.getData(key: 'onBoarding') ?? false;
    FirebaseAuth.instance.currentUser != null
        ? navigatePushReplacement(context, const MainView())
        : navigatePushReplacement(
            context,
            onBoarding ? const LoginView() : OnBoardingScreen(),
          );
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/mohandam_logo.png'),
                height: 300.0,
                width: 300.0,
              ),
              const Spacer(),
              Lottie.asset(
                'assets/json/loading3.json',
                height: 150.0,
                width: 150.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
