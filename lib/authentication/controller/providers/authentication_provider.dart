import 'package:chat_app_for_class/chat/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

// setter function to set bool value into isloading varabile
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _counter = 0;
  int get counter => _counter;
  set counter(int value) {
    _counter = value;
    notifyListeners();
  }

  void couterAddition() {
    counter = _counter + 1;
  }

// login function
  Future<void> login(
      String passedEmail, String passedPassword, BuildContext context) async {
    try {
      // set loading value to true
      isLoading = true;
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: passedEmail, password: passedPassword);
      //print("UserID: ${FirebaseAuth.instance.currentUser!.uid}");
      // store user id in sharedpreferences

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));

      isLoading = false;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Sucess")));
    } catch (e) {
      // set loading value to false
      isLoading = false;
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failed $e")));
    }
  }
}
