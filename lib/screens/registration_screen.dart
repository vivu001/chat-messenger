import 'package:flash_chat/components/input_box.dart';
import 'package:flash_chat/components/my_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';

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
                height: 120.0,
                child: Image.asset('images/virus_logo2.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            InputBox(
                hintText: 'Enter your email',
                onChange: (value) {
                  email = value;
                }),
            SizedBox(
              height: 8.0,
            ),
            InputBox(
                hintText: 'Enter your password',
                onChange: (value) {
                  password = value;
                }),
            SizedBox(
              height: 24.0,
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
