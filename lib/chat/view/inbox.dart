import 'package:chat_app_for_class/chat/model/all_users_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  InboxScreen({super.key, required this.singleUserData});

  AllUsersModel singleUserData;

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          child: Image.network(widget.singleUserData.profileImage),
        ),
        title: Text(widget.singleUserData.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
