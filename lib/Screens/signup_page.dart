import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebseauthentication/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final contactController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  final CollectionReference _items =
      FirebaseFirestore.instance.collection('UsersData');

  var taskSnapshot;

  File? _image;

  Future getImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  Future getImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_image != null) {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference = _storage.ref().child('images/$imageName.jpg');
        UploadTask uploadTask = reference.putFile(_image!);
        taskSnapshot =
            await uploadTask.whenComplete(() => print('Image uploaded.'));

        // Get the download URL
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        final String email = emailController.text;
        final String password = passwordController.text;
        final String contact = contactController.text;

        await _items.add({
          'url': downloadURL,
          "email": email,
          "password": password,
          "contact": contact
        });

        emailController.text = '';
        passwordController.text = '';
        contactController.text = '';

        // Show a toast message
        Fluttertoast.showToast(
          msg: "Data successfully registered in Firebase",
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 5,
        );
        Navigator.of(context).pop();
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              InkWell(
                onTap: () {
                  getImageGallery();
                },
                onDoubleTap: getImageCamera,
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Center(child: Icon(Icons.image)),
                ),
              ),

              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: 'example@gmail.com',
                        prefixIcon: Icon(Icons.email),
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15)),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      } else if (!value.contains("@")) {
                        return "Please enter valid email";
                      } else if (!value.contains(".com")) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child:TextFormField(
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Phone number",
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  controller: contactController,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    maxLength: 8,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: Icon(Icons.visibility),
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15)),
                    controller: passwordController,
                    validator: (value) {
                      RegExp regexSmall = RegExp(r'^(?=.*?[a-z])');
                      RegExp regexCapital = RegExp(r'^(?=.*?[A-Z])');
                      RegExp regexNumber = RegExp(r'^(?=.*?[0-9])');
                      RegExp regexSpecial =
                          RegExp(r'^(?=.*?[!@#$%^&*(),.?":{}|<>])');
                      RegExp regexDigit = RegExp(r'^.{8}$');
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (!regexSmall.hasMatch(value)) {
                        return 'Text must contain at least one lowercase letter !';
                      } else if (!regexCapital.hasMatch(value)) {
                        return 'Text must contain at least one capital letter !';
                      } else if (!regexNumber.hasMatch(value)) {
                        return 'Text must contain at least one number!';
                      } else if (!regexSpecial.hasMatch(value)) {
                        return 'Text must contain at least one special character!';
                      } else if (!regexDigit.hasMatch(value)) {
                        return 'password must contain 8 digits!';
                      }
                      return null;
                    },
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await Firebase.initializeApp();
                        try {
                          UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString(),
                          );
                          _uploadImage();
                          print("Sign up successfully");
                          Navigator.pushNamed(context, 'emailLogin');
                        } catch (e) {
                          print("Sign up unsuccessfully: $e");
                        }
                      }
                    },
                    child:
                        const Text("Signup", style: TextStyle(fontSize: 18.0))),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmailLogin()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blueAccent),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
