// ignore_for_file: camel_case_types, avoid_print, unnecessary_null_comparison, use_build_context_synchronously

import 'package:blog_app/screens/forgotpassword_screen.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/options_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../assets/buttons/round_button.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  //----------------------------------------------
  String? email, password;
  final _fromKey = GlobalKey<FormState>();
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OptionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 55),
            child: Text("Login"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Login",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                    key: _fromKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                            labelText: "Email",
                          ),
                          onChanged: (String value) {
                            email = value;
                          },
                          validator: (value) {
                            return value!.isEmpty ? "Enter Email" : null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.key_outlined),
                              border: OutlineInputBorder(),
                              labelText: "Password",
                            ),
                            onChanged: (String value) {
                              password = value;
                            },
                            validator: (value) {
                              return value!.isEmpty ? "Enter Password" : null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const forgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text("Forgot Password?")),
                          ),
                        ),
                        RoundButton(
                            title: "Login",
                            onPress: () async {
                              if (_fromKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email.toString().trim(),
                                          password: password.toString().trim());

                                  if (user != null) {
                                    print("Success");
                                    toastMessage("User login successfully");
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print(e.toString());
                                  toastMessage(e.toString());
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              }
                            },
                            buttonColor: Colors.blue,
                            textColor: Colors.white),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
