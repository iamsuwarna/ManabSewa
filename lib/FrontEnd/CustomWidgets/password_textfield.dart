import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final int maxLines;
  late bool obText;

  PasswordTextField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.hintText,
      required this.obText,
      this.maxLines = 1})
      : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obText,
      decoration: InputDecoration(
        label: Text(widget.label),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            widget.obText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              widget.obText = !widget.obText;
            });
          },
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Enter Your ${widget.hintText}!!";
        }
        return null;
      },
    );
  }
}