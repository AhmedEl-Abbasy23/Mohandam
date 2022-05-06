
import 'package:flutter/material.dart';
import 'package:handmade_store/view/reusable_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressedFn;

  CustomButton(this.text, this.onPressedFn);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff096f77),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressedFn,
      child: CustomText(
        text: text,
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}
