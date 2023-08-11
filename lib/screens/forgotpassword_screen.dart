// ignore_for_file: camel_case_types, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../assets/buttons/round_button.dart';

class forgotPasswordScreen extends StatefulWidget {
  const forgotPasswordScreen({super.key});

  @override
  State<forgotPasswordScreen> createState() => _forgotPasswordScreenState();
}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  //----------------------------------------------
  String? email;
  final _fromKey = GlobalKey<FormState>();
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  //----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 55),
            child: Text("Forgot Password"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: RoundButton(
                              title: "Recover Password",
                              onPress: () async {
                                if (_fromKey.currentState!.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    _auth
                                        .sendPasswordResetEmail(
                                            email:
                                                emailController.text.toString())
                                        .then((value) {
                                      toastMessage(
                                          "Please Check your Email, a reset link has sent to you via email");
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    }).onError((error, stackTrace) {
                                      toastMessage(error.toString());
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    });
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
                        ),
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
