import 'package:chat_app_for_class/chat/model/conversation_model.dart';
import 'package:chat_app_for_class/chat/view/inbox.dart';
import 'package:chat_app_for_class/chat/view/messages_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: getChatsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final conversational = Conversational.fromJson(
                  docs[index].data() as Map<String, dynamic>);

              print("My image url : ${conversational.receiverImageUrl}");

              // Add logging to see the value of lastMessageTime
              print("lastMessageTime: ${conversational.lastMessageTime}");

              // Validate the lastMessageTime before parsing
              final String lastMessageTimeString =
                  conversational.lastMessageTime;
              int millisecondTimestamp;
              try {
                millisecondTimestamp = int.parse(lastMessageTimeString) ~/ 1000;
              } catch (e) {
                print("Error parsing lastMessageTime: $e");
                millisecondTimestamp =
                    0; // Default to 0 or handle the error appropriately
              }

              // Create a DateTime object from the millisecond timestamp
              final DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(millisecondTimestamp);

              // Format the DateTime object to 24-hour time format
              final DateFormat formatter = DateFormat('HH:mm');
              final String myFormattedTime = formatter.format(dateTime);

              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return InboxScreen(
                      singleConversationData: conversational,
                    );
                  }));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(conversational.receiverImageUrl),
                  ),
                  title: Text('${conversational.chatReciverName}'),
                  subtitle: Text('${conversational.lastMessage}'),
                  trailing: Text(myFormattedTime),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> getChatsStream() {
    return FirebaseFirestore.instance
        .collection("chats")
        .where(Filter.or(
          Filter('initiatorId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid),
          Filter("receiverId",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid),
        ))
        .snapshots();
  }
}
