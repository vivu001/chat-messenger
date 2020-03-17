import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/my_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  bool _showSpinner = false;
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100,
                    child: Image.asset('images/virus_logo2.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 36.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputBoxDecoration
                    .copyWith(hintText: 'Enter you email')
                    .copyWith(prefixIcon: Icon(Icons.email)),
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputBoxDecoration.copyWith(hintText: 'Enter you password').copyWith(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    )),
                obscureText: _isHidden,
                keyboardAppearance: Brightness.dark,
              ),
              SizedBox(
                height: 20.0,
              ),
              MyButton(
                  color: Color(0xFFD35B3F),
                  text: 'Submit',
                  onpress: () async {
                    setState(() {
                      _showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, LoginScreen.id);
                        print('Go to: ' + LoginScreen.id);
                        print('Email: ' + email);
                        print('Password: ' + password);
                      }

                      setState(() {
                        _showSpinner = false;
                      });
                    } catch (e) {
                      print('Exeption: \n' + e.toString());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
