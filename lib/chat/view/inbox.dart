import 'package:chat_app_for_class/chat/model/all_users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  InboxScreen({super.key, required this.singleUserData});

  AllUsersModel singleUserData;

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          child: Image.network(widget.singleUserData.profileImage),
        ),
        title: Text(widget.singleUserData.name),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  final isSender = true; // Replace true with your condition
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Align(
                      alignment: isSender
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 43, 79),
                          borderRadius: isSender == false
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "sendCancelIfRunning: isInProgress=falsecallback=ImeCallback=ImeOnBackInvokedCallback@236",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("Message send");
                      sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      size: 35,
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

  Future<void> sendMessage() async {
    String currentDateTime = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      // Check if a conversation document already exists between the two users (sender to receiver)
      final chatQuery1 = await FirebaseFirestore.instance
          .collection("chats")
          .where('initiatorId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('receiverId', isEqualTo: widget.singleUserData.userId)
          .limit(1)
          .get();

      // Check if a conversation document already exists between the two users (receiver to sender)
      final chatQuery2 = await FirebaseFirestore.instance
          .collection("chats")
          .where('initiatorId', isEqualTo: widget.singleUserData.userId)
          .where('receiverId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get();

      // If conversation document exists, use its ID to add the message
      if (chatQuery1.docs.isNotEmpty) {
        final chatDocId = chatQuery1.docs.first.id;

        // Add message to existing conversation document
        FirebaseFirestore.instance
            .collection("chats")
            .doc(chatDocId)
            .collection("messages")
            .doc(currentDateTime)
            .set({
          'deleteByReceiver': false,
          'deleteBySender': false,
          'fromId': FirebaseAuth.instance.currentUser!.uid,
          'message': messageController.text,
          "messageId": currentDateTime,
          "toId": widget.singleUserData.userId,
        });
      } else if (chatQuery2.docs.isNotEmpty) {
        final chatDocId = chatQuery2.docs.first.id;

        // Add message to existing conversation document
        FirebaseFirestore.instance
            .collection("chats")
            .doc(chatDocId)
            .collection("messages")
            .doc(currentDateTime)
            .set({
          'deleteByReceiver': false,
          'deleteBySender': false,
          'fromId': FirebaseAuth.instance.currentUser!.uid,
          'message': messageController.text,
          "messageId": currentDateTime,
          "toId": widget.singleUserData.userId,
        });
      } else {
        // If conversation document doesn't exist, create a new conversation
        FirebaseFirestore.instance.collection("chats").add({
          'initiatorId': FirebaseAuth.instance.currentUser!.uid,
          'receiverId': widget.singleUserData.userId,
          'deleteBySender': false,
          'deleteByReciever': false,
        }).then((chatDocRef) {
          // Add message to newly created conversation document
          chatDocRef.collection("messages").doc(currentDateTime).set({
            'deleteByReceiver': false,
            'deleteBySender': false,
            'fromId': FirebaseAuth.instance.currentUser!.uid,
            'message': messageController.text,
            "messageId": currentDateTime,
            "toId": widget.singleUserData.userId,
          });
        });
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}
