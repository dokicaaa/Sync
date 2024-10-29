import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portfolio_app/components/login_error_popup.dart';
import 'package:portfolio_app/services/auth/auth_service.dart';
import 'package:portfolio_app/components/email%20_input.dart';
import 'package:portfolio_app/components/main_button.dart';
import 'package:portfolio_app/components/pass_input.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  //login method
  void login(BuildContext context) async {
    //Get auth service
    final authService = AuthService();

    //Try login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passController.text,
      );
    } catch (e) {
      //Snackbar for showing error when loggin in
      ScaffoldMessenger.of(context).showSnackBar(LoginErrorPopup(
        title: "Oh Snap",
        description: "Email or password is incorrect. Please check again.",
      ));
    }
  }

  //Google Login method
  void googleLogin(BuildContext context) async {
    //Get google service
    final authService = AuthService();

    //Try Google login
    try {
      await authService.signInWithGoogle();
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home page
    } catch (e) {
      //Snackbar for showing error when loggin in
      ScaffoldMessenger.of(context).showSnackBar(LoginErrorPopup(
        title: "Oh Snap",
        description: "Something went wront.Try again",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _loginText(),
              const SizedBox(
                height: 20,
              ),
              _loginInputFields(),
              //IMPLEMENT FORGOT PASSWORD FEATURE
              // const SizedBox(
              //   height: 16,
              // ),
              // _forgotPassword(),
              const SizedBox(
                height: 36,
              ),
              MyButton(
                text: 'Log In',
                onTap: () => login(context),
              ),
              const SizedBox(
                height: 28,
              ),
              _altTextLogIn(),
              const SizedBox(
                height: 28,
              ),
              _googleAuthBox(context),
              const SizedBox(
                height: 28,
              ),
              _altTextSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Row _altTextSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Dont have an account?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 14,
            )),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: widget.onTap,
          child: Text('Sign Up',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        )
      ],
    );
  }

  Row _googleAuthBox(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: InkWell(
              onTap: () {
                googleLogin(context);
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/icons/google.svg',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _altTextLogIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Or, login with...",
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 14,
              fontWeight: FontWeight.w100),
        )
      ],
    );
  }

  Padding _forgotPassword() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Forgot password?',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Column _loginInputFields() {
    return Column(
      children: [
        //EMAIL INPUT FIELD
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 28),
          child: TextInput(
            hintText: 'Email',
            obscureText: false,
            controller: _emailController,
            focusNode: null,
            customColor: Colors.white,
          ),
        ),

        //PASSWORD INPUT FIELD
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: PassInput(
            hintText: 'Password',
            controller: _passController,
            customColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Padding _loginText() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      //TEXT COLUMN
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 36,
                color: Theme.of(context).colorScheme.tertiary),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
