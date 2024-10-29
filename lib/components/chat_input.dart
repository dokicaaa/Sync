import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatInput extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Color customColor;
  final FocusNode? focusNode;
  final Function() onMediaUpload;

  const ChatInput({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.customColor,
    required this.focusNode,
    required this.onMediaUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        maxLines: null,
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          filled: true,
          fillColor: customColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintText: hintText,
          hintStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w100, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(26),
          ),
          suffixIcon: Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/image.svg',
                height: 28,
                width: 28,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              onPressed: onMediaUpload,
            ),
          ),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
      ),
    );
  }
}
