import 'package:chat_app_for_class/authentication/sinup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8ACCB0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //login Screen
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
                    "Login Now",
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
                    "Please Login to continue using our app.",
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
              height: 30,
            ),

            // Email
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
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

            // password
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  label: Text(
                    'Password',
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

            // forget password
            Padding(
              padding: const EdgeInsets.only(left: 150, top: 10),
              child: Row(
                children: [
                  Center(
                      child: InkWell(
                    child: Text("Forgot Password?"),
                  )),
                ],
              ),
            ),

            SizedBox(
              height: 70,
            ),

            //login Button

            Center(
              child: Container(
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    /// signup banner
                    "Login",
                    style: GoogleFonts.kronaOne(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            //You already have an account? signup
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
                          MaterialPageRoute(builder: (context) => sign_up()),
                        );
                      },
                      child: Text(
                        "Sign Up",
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

  Future<void> login(String passedEmail, String passedPassword) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: passedEmail, password: passedPassword);
    } catch (e) {}
  }
}
