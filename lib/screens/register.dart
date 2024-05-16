// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:blog_app/assets/buttons/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          centerTitle: true,
          title: const Text("Create Account"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Register",
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
                        RoundButton(
                            title: "Register",
                            onPress: () async {
                              if (_fromKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final user = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email.toString().trim(),
                                          password: password.toString().trim());

                                  if (user != null) {
                                    print("Success");
                                    toastMessage("User created successfully");
                                    setState(() {
                                      showSpinner = false;
                                    });
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
