import 'dart:io';

import 'package:chat_app_for_class/authentication/view/login.dart';
import 'package:chat_app_for_class/chat/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  var emailController = TextEditingController();
  var newPasswordController = TextEditingController();
  var ConfirmPasswordController = TextEditingController();
  var nameController = TextEditingController();

  XFile? selectedImage = null;

  ImagePicker picker = ImagePicker();

  // varaible for laoading
  var isSignedUp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8ACCB0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sign Up Text
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    /// signup banner
                    "Sign Up",
                    style: GoogleFonts.kronaOne(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please Register with email and sign up to \n                continue using our app.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),

            // Continue with Google container

            SizedBox(
              height: 15,
            ),

            SizedBox(
              height: 15,
            ),

            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  //shape: BoxShape.circle, color: Colors.brown[100]
                  ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: selectedImage != null
                    ? FileImage(File(selectedImage!.path))
                    : AssetImage("assets/images/person.jpg")
                        as ImageProvider<Object>,
              ),
            ),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.brown,
                          title: Center(
                              child: Text(
                            'select image',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )),
                          content: Container(
                            height: 100,
                            width: 100,
                            child: Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      pickimagefromgallery();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'select from gallery',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      pickimagefromcamera();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'select from camera',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Text('select profile pic',
                    style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(fontSize: 10)))),

            // Email
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  label: Text(
                    'Name',
                  ),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20)), // Shape of the border
                  prefixIcon: Icon(Icons.email),
                  fillColor: Color(0xffEDF6EC),
                  filled: true,
                  // Leading icon
                  // suffixIcon: Icon(Icons.)
                ),
              ),
            ),

            // Email
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  label: Text(
                    'Email',
                  ),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20)), // Shape of the border
                  prefixIcon: Icon(Icons.email),
                  fillColor: Color(0xffEDF6EC),
                  filled: true,
                  // Leading icon
                  // suffixIcon: Icon(Icons.)
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //Create Passsword
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  hintText: "Create-Password",
                  label: Text(
                    'Create-Password',
                  ),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20)), // Shape of the border
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Color(0xffEDF6EC),
                  filled: true,
                  // Leading icon
                  // suffixIcon: Icon(Icons.)
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //Confirm Passsword
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: ConfirmPasswordController,
                decoration: InputDecoration(
                  hintText: "Confirm-Password",
                  label: Text(
                    'Confirm-Password',
                  ),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20)), // Shape of the border
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Color(0xffEDF6EC),
                  filled: true,
                  // Leading icon
                  // suffixIcon: Icon(Icons.)
                ),
              ),
            ),

            SizedBox(
              height: 50,
            ),

            //Sign Up Buttom
            Center(
              child: InkWell(
                onTap: () async {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Email is missing")));
                  } else if (newPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("New Password missing")));
                  } else if (newPasswordController.text !=
                      ConfirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "New password and confirm password not matching")));
                  } else {
                    signUpWithEmailandPassword(
                        emailController.text, newPasswordController.text);
                  }
                },
                child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: isSignedUp == true
                        ? CircularProgressIndicator()
                        : Text(
                            /// signup banner
                            "Sign Up",
                            style: GoogleFonts.kronaOne(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            // You already have an account?
            Padding(
              padding: const EdgeInsets.only(left: 70, top: 10),
              child: Row(
                children: [
                  Center(child: Text("You already have an account?")),
                  SizedBox(
                    width: 5,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUpWithEmailandPassword(
      String emailPassed, String passwordPassed) async {
    try {
      setState(() {
        isSignedUp = true;
      });
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: emailPassed, password: passwordPassed);
      // store user progile image in firebase storage

      if (selectedImage != null) {
        // store selected XFile into File varaible to be store in firestore
        File imageFile = File(selectedImage!.path);
        // giving name to the image in the storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // query to store image in firebase storage

        await FirebaseStorage.instance
            .ref('profile_images/$fileName')
            .putFile(imageFile);

        // get imaged url

        String userImageUrl = await FirebaseStorage.instance
            .ref('profile_images/$fileName')
            .getDownloadURL();

        // store all the data in users collection

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "email": emailController.text,
          "name": nameController.text,
          "profile_image": userImageUrl,
          "userId": FirebaseAuth.instance.currentUser!.uid,
        });
      }

      setState(() {
        isSignedUp = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign Up success")));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return login();
      }));
    } catch (e) {
      setState(() {
        isSignedUp = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign Up Failed $e")));
      print("Eorror in Signup: $e");
    }
  }

  void pickimagefromgallery() async {
    final returnedimage = await picker.pickImage(source: ImageSource.gallery);

    //setState(() async {
    if (returnedimage != null) {
      selectedImage = XFile(returnedimage.path);

      setState(() {});
    } else {
      print('your pic is not selected');
    }
    // });
  }

  pickimagefromcamera() async {
    final returnedimage = await picker.pickImage(source: ImageSource.camera);

    //setState(() async {
    if (returnedimage != null) {
      selectedImage = XFile(returnedimage.path);

      setState(() {});
    } else {
      print('pic is not selected');
    }
    ;
    // });
  }
}
