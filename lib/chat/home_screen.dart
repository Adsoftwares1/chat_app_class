import 'package:chat_app_for_class/authentication/view/login.dart';
import 'package:chat_app_for_class/chat/view/calls_screen.dart';
import 'package:chat_app_for_class/chat/view/chat_screen.dart';
import 'package:chat_app_for_class/chat/view/status_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // my screens list
  final List<Widget> widgetOptions = <Widget>[
    ChatScreen(),
    StatusScreen(),
    CallScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Whatsapp"),
        actions: [
          InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return login();
                }));
              },
              child: Icon(Icons.camera)),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.search),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.more),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        //currentIndex: _selectedIndex,
        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.chat,
            ),
          ),
          BottomNavigationBarItem(
            label: "Updates",
            icon: Icon(
              Icons.update,
            ),
          ),
          BottomNavigationBarItem(
            label: "Calls",
            icon: Icon(
              Icons.group,
            ),
          ),
        ],
      ),
    );
  }
}
