import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_social/components/button.dart';
import 'package:mini_social/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTapped;
  const LoginPage({super.key, this.onTapped});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  void signIn() async {
    if (_emailTextController.text.trim() == '' ||
        _passwordTextController.text.trim() == '') {
      showMessage('Email and password required');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text.trim(),
          password: _passwordTextController.text.trim());
    } on FirebaseAuthException catch (e) {
      showMessage(e.code);
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: const TextStyle(
              color: Colors.red, fontWeight: FontWeight.w400, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Column(
            children: [
              Lottie.asset('assets/animations/login.json'),
              const Text(
                "Welcome to mini social",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 40),
              MyTextField(
                  controller: _emailTextController,
                  hintText: 'Email',
                  obscureText: false),
              const SizedBox(height: 10),
              MyTextField(
                  controller: _passwordTextController,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 25),
              MyButton(
                text: 'Sign In',
                onTapped: signIn,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: widget.onTapped,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ]),
      ),
    ));
  }
}
