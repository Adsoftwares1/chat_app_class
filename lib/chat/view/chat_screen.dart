import 'package:chat_app_for_class/chat/model/conversation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: getChatsStream(),
        // FirebaseFirestore.instance
        //     .collection("chats")
        //     .where(Filter.or(
        //         Filter('initiatorId',
        //             isEqualTo: FirebaseAuth.instance.currentUser!.uid),
        //         Filter("receiverId",
        //             isEqualTo: FirebaseAuth.instance.currentUser!.uid)))
        //     .snapshots(),
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

              // Convert microsecond timestamp to milliseconds
              final int millisecondTimestamp =
                  int.parse(conversational.lastMessageTime) ~/ 1000;

              // Create a DateTime object from the millisecond timestamp
              final DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(millisecondTimestamp);

              // Format the DateTime object to 24-hour time format
              final DateFormat formatter = DateFormat('HH:mm');
              final String myFormattedTime = formatter.format(dateTime);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(conversational.receiverImageUrl),
                ),
                title: Text('Receiver ID: ${conversational.chatReciverName}'),
                subtitle: Text('Sender ID: ${conversational.lastMessage}'),
                trailing: Text(myFormattedTime),
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

  Future<Map<String, dynamic>> getLastMessageInfo(
      DocumentReference chatDocRef) async {
    // Get the last message in the messages sub-collection
    QuerySnapshot messageSnapshot = await chatDocRef
        .collection('messages')
        .orderBy('messageId', descending: true)
        .limit(1)
        .get();

    if (messageSnapshot.docs.isNotEmpty) {
      var lastMessageDoc = messageSnapshot.docs.first;
      return {
        'lastMessage': lastMessageDoc.data(),
        'timestamp': lastMessageDoc['message_id']
      };
    } else {
      return {'lastMessage': null, 'timestamp': null};
    }
  }

  Stream<List<Map<String, dynamic>>> getChatsStream1() async* {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var chatSnapshots = FirebaseFirestore.instance
        .collection('chats')
        .where(Filter.or(
          Filter('initiatorId', isEqualTo: userId),
          Filter('receiverId', isEqualTo: userId),
        ))
        .snapshots();

    await for (var snapshot in chatSnapshots) {
      List<Map<String, dynamic>> chatDataList = [];
      for (var chatDoc in snapshot.docs) {
        var chatDocRef = chatDoc.reference;
        var lastMessageInfo = await getLastMessageInfo(chatDocRef);
        chatDataList.add({
          'chatId': chatDoc.id,
          'chatData': chatDoc.data(),
          'lastMessage': lastMessageInfo['lastMessage'],
          'timestamp': lastMessageInfo['timestamp']
        });
      }
      yield chatDataList;
    }
  }
}
