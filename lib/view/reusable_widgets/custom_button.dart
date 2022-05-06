
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/my_colors.dart';
import 'package:handmade_store/view/reusable_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressedFn;

  CustomButton(this.text, this.onPressedFn);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: MyColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
      onPressed: onPressedFn,
      child: CustomText(
        text: text,
        fontSize: 16.0,
        color: Colors.white,
      ),
    );
  }
}
