import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginErrorPopup extends SnackBar {
  LoginErrorPopup({
    Key? key,
    required String title,
    required String description,
  }) : super(
          key: key,
          content: Container(
            padding: EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
}
