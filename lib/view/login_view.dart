import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/forgot_password_view.dart';
import 'package:handmade_store/view/main_view.dart';
import 'package:handmade_store/view/signup_view.dart';
import 'package:handmade_store/view/verification_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // final _currentUser = FirebaseAuth.instance.currentUser;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xff096f77)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.welcome.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            AppStrings.signInToContinue.tr(),
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUpView()));
                        },
                        child:  Text(
                          AppStrings.signUp.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                            color: Color(0xff096f77),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(AppStrings.email.tr()),
                TextFormField(
                  controller: _emailController,
                  cursorColor: const Color(0xff096f77),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return  AppStrings.pleaseEnterEmail.tr();
                    } else if (!value.contains('@') && value.length < 6) {
                      return AppStrings.invalidEmail.tr();
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    // on open form
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff096f77)),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(AppStrings.password.tr()),
                TextFormField(
                  controller: _passwordController,
                  cursorColor: const Color(0xff096f77),
                  obscureText: isObscure,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return AppStrings.pleaseEnterPassword.tr();
                    } else if (value.length < 6) {
                      return AppStrings.invalidPassword.tr();
                    }
                    return null;
                  },
                  style: const TextStyle(letterSpacing: 8),
                  obscuringCharacter: '●',
                  decoration: InputDecoration(
                    // on open form
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff096f77)),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(
                        isObscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xff096f77),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      navigatePush(context, const ForgotPasswordView());
                    },
                    child:  Text(
                      AppStrings.forgotPassword.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                // Sign-in button
                SizedBox(
                  height: 60.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _auth
                            .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        )
                            .then((user) {
                          print(
                              '---------------- email verified is: ---------------');
                          print(user.user!.emailVerified);
                          print('----------------  ---------------');
                          if (user.user!.emailVerified) {
                            navigatePushReplacement(context, const MainView());
                          } else {
                            navigatePushReplacement(context, const VerificationView());
                          }
                        });
                      }
                    },
                    child:  Text(
                      AppStrings.signIn.tr().toUpperCase(),
                      style:const TextStyle(fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff096f77),
                    ),
                  ),
                ),
                 Center(
                    child: Padding(
                  padding:const EdgeInsets.symmetric(vertical: 35.0),
                  child: Text('-${AppStrings.or.tr()}-', style:const TextStyle(fontSize: 20.0)),
                )),
                // facebook sign-in
                GestureDetector(
                  onTap: () async {
                    AwesomeDialog(
                    context: context,
                    dialogType: DialogType.NO_HEADER,
                    headerAnimationLoop: true,
                    animType: AnimType.BOTTOMSLIDE,
                    title: AppStrings.loading.tr(),
                    dismissOnBackKeyPress: false,
                    dismissOnTouchOutside: false,
                    autoDismiss: true,
                  ).show();
                    await signInWithFacebook().then((credential) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(credential.user!.uid)
                          .set({
                        'email': credential.user!.email,
                        "name": credential.user!.displayName,
                        'uid': credential.user!.uid,
                        'signInMethod': 'facebook account',
                        'mobileNumber': credential.user!.phoneNumber ?? '+2',
                        'imgUrl': '',
                        'shippingAddress': '',
                      });

                      navigatePushReplacement(context, const MainView());
                      print('-------------------------------------');
                      print(credential.user!.emailVerified);
                      print('-------------------------------------');
                    }).catchError((error) {
                      print(error.toString());
                    });
                  },
                  child: Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SvgPicture.asset(
                            'assets/icons/facebook_ic.svg',
                            height: 26.0,
                            width: 26.0,
                          ),
                        ),
                         Expanded(
                          flex: 2,
                          child: Text(
                             AppStrings.facebookSignIn.tr(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const SizedBox(width: 30.0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22.0),
                // google sign-in
                GestureDetector(
                  onTap: () async {
                    await signInWithGoogle().then((credential) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(credential.user!.uid)
                          .set({
                        'email': credential.user!.email,
                        "name": credential.user!.displayName,
                        'uid': credential.user!.uid,
                        'signInMethod': 'google account',
                        'mobileNumber': credential.user!.phoneNumber ?? '+2',
                        'imgUrl': '',
                        'shippingAddress': '',
                      });
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        headerAnimationLoop: true,
                        animType: AnimType.BOTTOMSLIDE,
                        title: AppStrings.loading.tr(),
                        dismissOnBackKeyPress: false,
                        dismissOnTouchOutside: false,
                      ).show();
                      navigatePushReplacement(context, const MainView());
                      print(credential.user!.uid);
                    }).catchError((error) {
                      print(error.toString());
                    });
                  },
                  child: Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SvgPicture.asset(
                            'assets/icons/google_ic.svg',
                            height: 26.0,
                            width: 26.0,
                          ),
                        ),
                         Expanded(
                          flex: 2,
                          child: Text(
                            AppStrings.googleSignIn.tr(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
