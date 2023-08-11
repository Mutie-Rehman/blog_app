import 'dart:io';

import 'package:blog_app/assets/buttons/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  File? _image;
  final picker = ImagePicker();
  final postRef = FirebaseDatabase.instance.ref().child("Posts");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        "No image selected";
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        "No image selected";
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.camera),
                      title: Text("Camera"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text("Gallery"),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Blogs"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => {
                    dialog(context),
                  },
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _image != null
                          ? ClipRRect(
                              child: Image.file(
                                _image!.absolute,
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 100,
                              width: 100,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        hintText: "Enter post title",
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Enter post description",
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                        title: "Upload",
                        onPress: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            int date = DateTime.now().microsecondsSinceEpoch;
                            firebase_storage.Reference ref = firebase_storage
                                .FirebaseStorage.instance
                                .ref("/blogapp$date");

                            UploadTask uploadTask =
                                ref.putFile(_image!.absolute);
                            await Future.value(uploadTask);
                            var newUrl = await ref.getDownloadURL();
                            final User? user = _auth.currentUser;
                            postRef
                                .child("Post List")
                                .child(date.toString())
                                .set({
                              "pId": date.toString(),
                              "pImage": newUrl.toString(),
                              "pTime": date.toString(),
                              "pTitle": titleController.text.toString(),
                              "pDescription":
                                  descriptionController.text.toString(),
                              "uEmail": user!.email.toString(),
                              "uId": user.uid.toString(),
                            }).then((value) {
                              toastMessage("Post Published");
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
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage(e.toString());
                          }
                        },
                        buttonColor: Colors.blue,
                        textColor: Colors.white),
                  ],
                ))
              ],
            ),
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
