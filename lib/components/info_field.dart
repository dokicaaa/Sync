import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final IconData icon; // Icon data for the icon to display
  final String text; // Text to display next to the icon
  final TextStyle? textStyle; // Optional text style
  final EdgeInsetsGeometry padding; // Padding for the container

  const InfoField({
    super.key,
    required this.icon,
    required this.text,
    this.textStyle,
    this.padding = const EdgeInsets.all(14), // Default padding
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: Theme.of(context)
                  .colorScheme
                  .tertiary), // Using the passed icon data
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 2,
            height: 24,
            color: Theme.of(context).colorScheme.surface,
          ),
          Text(
            text,
            style: textStyle ??
                TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                ), // Using passed textStyle or default
          ),
        ],
      ),
    );
  }
}
