import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/my_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);

    animation = ColorTween(begin: Colors.white, end: Colors.orangeAccent).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/virus_logo2.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Corona Chat'],
                  speed: Duration(milliseconds: 200),
                  textStyle: TextStyle(
                      fontSize: 40.0,
                      fontFamily: "Pacifico",
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            MyButton(
                color: Color(0xFF344955),
                text: 'Log In',
                onPress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                  print('Go to: ' + LoginScreen.id);
                }),
            MyButton(
                color: Color(0xFF718C6A),
                text: 'Register',
                onPress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                  print('Go to: ' + RegistrationScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
