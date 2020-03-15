import 'package:flash_chat/components/my_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 90,
                child: Image.asset('images/virus_logo2.png'),
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputBoxDecoration.copyWith(hintText: 'Enter your email')),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              decoration: kInputBoxDecoration.copyWith(hintText: 'Enter your password'),
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            MyButton(
                color: Color(0xFFD35B3F),
                text: 'Register',
                onpress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                  print('Go to: ' + LoginScreen.id);
                  print('Email: ' + email);
                  print('Password: ' + password);
                }),
          ],
        ),
      ),
    );
  }
}
