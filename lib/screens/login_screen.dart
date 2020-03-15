import 'package:flash_chat/components/input_box.dart';
import 'package:flash_chat/components/my_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            InputBox(hintText: 'Enter your email', onChange: (value) => null),
            SizedBox(
              height: 8.0,
            ),
            InputBox(hintText: 'Enter your password', onChange: (value) => null),
            SizedBox(
              height: 24.0,
            ),
            MyButton(
                color: Color(0xFF544E6E),
                text: 'Log In',
                onpress: () {
                  Navigator.pushNamed(context, ChatScreen.id);
                  print('Go to: ' + ChatScreen.id);
                  print('Email: ' + email);
                  print('Password: ' + password);
                }),
          ],
        ),
      ),
    );
  }
}
