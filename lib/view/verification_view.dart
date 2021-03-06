import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/main_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.verifyEmail.tr(),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
            ),
            const SizedBox(height: 10.0),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                children: [
                  TextSpan(
                    text: AppStrings.verificationLink.tr(),
                  ),
                  TextSpan(
                    text: '${_auth.currentUser!.email}',
                    style: const TextStyle(
                      color: Color(0xff096f77),
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text: AppStrings.checkEmail.tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    navigatePush(context, const MainView());
                  },
                  child: Text(
                    AppStrings.continue1.tr().toUpperCase(),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff096f77),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

/*const SizedBox(height: 65.0),
            PinCodeTextField(
              appContext: context,
              length: 6,
              autoFocus: true,
              cursorColor: const Color(0xff096f77),
              keyboardType: TextInputType.number,
              obscureText: false,
              animationType: AnimationType.scale,
              textStyle: const TextStyle(color: Colors.white),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(6),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: const Color(0xff096f77),
                borderWidth: 1,
                activeColor: Colors.white,
                inactiveColor: const Color(0xff096f77),
                inactiveFillColor: Colors.white,
                selectedColor: const Color(0xff096f77),
                selectedFillColor: Colors.white,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.white,
              enableActiveFill: true,
              onCompleted: (submittedCode) {
                // To send OTP code which the user wrote to firebase.
                // otpCode = submittedCode;
                print("Completed");
              },
              onChanged: (value) {
                print(value);
              },
            ),
            const SizedBox(height: 65.0),*/
