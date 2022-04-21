import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/view/login_view.dart';

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
              const Padding(
                padding:  EdgeInsets.symmetric(vertical: 65.0),
                child: Text(
                  'Enter your email address to reset \npassword',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
              ),
              const Text('Email'),
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
                    return 'Please enter your email address';
                  } else if (!value.contains('@') && value.length < 6) {
                    return 'Invalid email address';
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
                          .then((_) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginView()));
                      });
                    }
                  },
                  child: const Text(
                    'RESET PASSWORD',
                    style: TextStyle(fontSize: 16.0),
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
    );
  }
}
