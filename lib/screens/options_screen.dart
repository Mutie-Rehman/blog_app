import 'package:blog_app/assets/buttons/round_button.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage("lib/assets/images/img1.jpg"),
                ),
                const SizedBox(
                  height: 100,
                ),
                RoundButton(
                    title: "Login",
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const loginScreen()));
                    },
                    buttonColor: Colors.blue,
                    textColor: Colors.white),
                const SizedBox(
                  height: 0,
                ),
                RoundButton(
                    title: "Register",
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
                    },
                    buttonColor: Colors.blue,
                    textColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
