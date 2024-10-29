import 'package:flutter/material.dart';
import 'package:portfolio_app/services/auth/auth_service.dart';
import 'package:portfolio_app/components/email%20_input.dart';
import 'package:portfolio_app/components/main_button.dart';
import 'package:portfolio_app/components/pass_input.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  void register(BuildContext context) {
    //Get auth service
    final auth = AuthService();

    //if passwords match -> create user
    if (_confirmPassController.text == _passController.text) {
      try {
        auth.signUpWithEmailPassword(
          _emailController.text,
          _passController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //if passwords dont match -> show error to user
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
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
              SizedBox(
                height: 28,
              ),
              _loginInputFields(),
              SizedBox(
                height: 36,
              ),
              MyButton(
                text: 'Sign Up',
                onTap: () => register(context),
              ),
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
        Text('Already have an account?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 14,
            )),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: widget.onTap,
          child: Text('Log In',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        )
      ],
    );
  }

  Row _altTextLogIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Or, sign up with...",
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 14,
              fontWeight: FontWeight.w100),
        )
      ],
    );
  }

  Column _loginInputFields() {
    return Column(
      children: [
        //EMAIL INPUT FIELD
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 28),
          child: TextInput(
            hintText: 'Email',
            obscureText: false,
            controller: _emailController,
            customColor: Colors.white,
            focusNode: null,
          ),
        ),

        //PASSWORD INPUT FIELD
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 28),
          child: PassInput(
            hintText: 'Password',
            controller: _passController,
            customColor: Colors.white,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PassInput(
              hintText: 'Confirm password',
              controller: _confirmPassController,
              customColor: Colors.white),
        )
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
            "Sign up",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 36,
                color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
    );
  }
}
