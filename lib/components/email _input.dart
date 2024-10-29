import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Color customColor;
  final FocusNode? focusNode;

  const TextInput(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      required this.customColor,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
            filled: true,
            fillColor: customColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            hintText: hintText,
            hintStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w100, color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            )
            ),
            style: const TextStyle(
               color: Colors.black
            ),
      ),
    );
  }
}
