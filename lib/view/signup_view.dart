import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/verification_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xff096f77)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.signUp.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 32.0),
                ),
                const SizedBox(height: 65.0),
                Text(AppStrings.name.tr()),
                TextFormField(
                  controller: _userNameController,
                  cursorColor: const Color(0xff096f77),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return AppStrings.pleaseEnterName.tr();
                    } else if (value.length < 6) {
                      return AppStrings.invalidName.tr();
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff096f77)),
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                Text(AppStrings.email.tr()),
                TextFormField(
                  controller: _emailController,
                  cursorColor: const Color(0xff096f77),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff096f77)),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return AppStrings.pleaseEnterEmail.tr();
                    } else if (!value.contains('@') && value.length < 6) {
                      return AppStrings.invalidEmail.tr();
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 35.0),
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
                const SizedBox(height: 60.0),
                SizedBox(
                  height: 60.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _auth
                            .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text)
                            .then((user) {
                          _auth.currentUser!.sendEmailVerification();
                          _fireStore
                              .collection('users')
                              .doc(user.user!.uid)
                              .set({
                            "name": _userNameController.text,
                            "email": _emailController.text,
                            "uid": user.user!.uid,
                            'signInMethod': 'email & password',
                            'mobileNumber': '',
                            'imgUrl': '',
                            'shippingAddress': '',
                          });
                          print(user.user!.email);
                          navigatePushReplacement(
                            context,
                            const VerificationView(),
                          );
                        });
                      }
                    },
                    child: Text(
                      AppStrings.signUp.tr().toUpperCase(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff096f77),
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
