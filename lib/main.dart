import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/view/login_view.dart';
import 'package:handmade_store/view/main_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

bool userLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) {
    userLoggedIn = true;
  } else {
    userLoggedIn = false;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userLoggedIn ? const MainView() : const LoginView(),
      theme: ThemeData(fontFamily: 'SFP-REGULAR'),
      builder: (context, widget) => ResponsiveWrapper.builder(
        widget,
        maxWidth: 2460,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
      ),
    );
  }
}
