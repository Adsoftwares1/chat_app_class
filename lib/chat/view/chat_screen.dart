import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> userList = [
    {
      'name': 'User 1',
      'message': 'Hello there!',
      'time': '10:00 AM',
    },
    {
      'name': 'User 2',
      'message': 'Hi, how are you?',
      'time': '10:30 AM',
    },
    {
      'name': 'User 3',
      'message': 'Good morning!',
      'time': '11:00 AM',
    },
    {
      'name': 'User 4',
      'message': 'Hey!',
      'time': '11:30 AM',
    },
    {
      'name': 'User 5',
      'message': 'What\'s up?',
      'time': '12:00 PM',
    },
    {
      'name': 'User 6',
      'message': 'Nice to meet you!',
      'time': '1:00 PM',
    },
    {
      'name': 'User 7',
      'message': 'Long time no see!',
      'time': '2:00 PM',
    },
    {
      'name': 'User 8',
      'message': 'How\'s your day going?',
      'time': '3:00 PM',
    },
    {
      'name': 'User 9',
      'message': 'See you later!',
      'time': '4:00 PM',
    },
    {
      'name': 'User 10',
      'message': 'Take care!',
      'time': '5:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 25,
                      ),
                    ),
                    // Align(
                    //     alignment: Alignment.bottomLeft,
                    //     child: Icon(Icons.lock_clock)),
                  ],
                ),
                title: Text("${userList[index]['name']}"),
                subtitle: Row(
                  children: [
                    Icon(Icons.send),
                    Text("${userList[index]['message']}"),
                  ],
                ),
                trailing: Text("${userList[index]['time']}"),
              );
            }));
  }
}
