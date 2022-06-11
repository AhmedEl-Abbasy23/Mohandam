import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/login_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 65.0),
                child: Text(AppStrings.enterYourEmail.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
              ),
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
              const SizedBox(height: 45.0),
              SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _auth
                          .sendPasswordResetEmail(email: _emailController.text)
                          .then((_) { navigatePush(context, const LoginView());});
                    }
                  },
                  child:  Text(AppStrings.resetPassword.tr().toUpperCase(), style: const TextStyle(fontSize: 16.0),),
                  style: ElevatedButton.styleFrom(primary: const Color(0xff096f77),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
