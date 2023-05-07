import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool obscureText;
  final bool showNumber;

  final Icon? icon;
  CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.obscureText = false,
      // required this.autocorrect,
      // required this.enableSuggestions,
      this.icon,
      this.showNumber = false,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: showNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38)),
        suffixIcon: icon,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
      },
      maxLines: maxLines,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
