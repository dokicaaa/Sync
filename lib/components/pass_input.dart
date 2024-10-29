import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PassInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color customColor;
  final bool isPassWrong;

  const PassInput(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.customColor,
      this.isPassWrong = false});

  @override
  State<PassInput> createState() => _PassInputState();
}

class _PassInputState extends State<PassInput> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.customColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w100, color: Colors.grey),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: SvgPicture.asset(
                _isPasswordVisible
                    ? 'assets/icons/show.svg'
                    : 'assets/icons/hide.svg',
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
