import 'package:flutter/material.dart';
import 'package:portfolio_app/pages/login.dart';
import 'package:portfolio_app/pages/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginOrRegister> {
  //Initially show login page
  bool showLogInpage = true;
  
 // Toggle between login and register page
  void togglePages() {
    setState(() {
      showLogInpage = !showLogInpage;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (showLogInpage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
