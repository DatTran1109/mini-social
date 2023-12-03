import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_social/components/button.dart';
import 'package:mini_social/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTapped;
  const RegisterPage({super.key, this.onTapped});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordConfirmTextController = TextEditingController();

  void signUp() async {
    if (_emailTextController.text.trim() == '' ||
        _passwordTextController.text.trim() == '' ||
        _passwordConfirmTextController.text.trim() == '') {
      showMessage('All fields are required');
      return;
    }

    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(_emailTextController.text.trim()) ==
        false) {
      showMessage('Email is not valid');
      return;
    }

    if (_passwordTextController.text.trim() !=
        _passwordConfirmTextController.text.trim()) {
      showMessage('Password confirmation does not match');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text.trim(),
              password: _passwordTextController.text.trim());

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username': _emailTextController.text.trim().split('@')[0],
        'bio': 'Empty bio..'
      });
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
        child: ListView(children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Lottie.asset('assets/animations/register.json'),
              const SizedBox(height: 20),
              const Text(
                "Lets create an account",
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
              const SizedBox(height: 10),
              MyTextField(
                  controller: _passwordConfirmTextController,
                  hintText: 'Password Confirm',
                  obscureText: true),
              const SizedBox(height: 25),
              MyButton(
                text: 'Register',
                onTapped: signUp,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: widget.onTapped,
                      child: const Text(
                        'Sign in',
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
