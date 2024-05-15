import 'package:chat_app_for_class/chat/model/all_users_model.dart';
import 'package:chat_app_for_class/chat/model/conversation_model.dart';
import 'package:chat_app_for_class/chat/model/messages_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  InboxScreen({super.key, required this.singleConversationData});

  Conversational singleConversationData;

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
          backgroundImage:
              NetworkImage(widget.singleConversationData.receiverImageUrl),
        ),
        title: Text(widget.singleConversationData.chatReciverName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('initiatorId',
                isEqualTo: widget.singleConversationData.initiatorId)
            .where('receiverId',
                isEqualTo: widget.singleConversationData.receiverId)
            .snapshots(),
        builder: (context, chatSnapshot) {
          if (!chatSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Widget> messageWidgets = [];

          for (var chatDoc in chatSnapshot.data!.docs) {
            messageWidgets.add(
              StreamBuilder<QuerySnapshot>(
                stream: chatDoc.reference.collection('messages').snapshots(),
                builder: (context, messageSnapshot) {
                  if (!messageSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<Widget> individualMessages = [];
                  for (var messageDoc in messageSnapshot.data!.docs) {
                    var messageData = messageDoc.data() as Map<String, dynamic>;
                    Message message = Message.fromJson(messageData);
                    individualMessages.add(
                      ListTile(
                        title: Padding(
                          padding: FirebaseAuth.instance.currentUser!.uid ==
                                  message.fromId
                              ? EdgeInsets.only(left: 100)
                              : EdgeInsets.only(right: 100),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: FirebaseAuth.instance.currentUser!.uid ==
                                      message.fromId
                                  ? Color.fromARGB(255, 0, 43, 79)
                                  : Color.fromARGB(255, 119, 183, 236),
                              borderRadius:
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          message.fromId
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
                                message.message,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // subtitle: Text(
                        //     'From: ${message.fromId}, To: ${message.toId}'),
                      ),
                    );
                  }

                  return Column(
                    children: individualMessages,
                  );
                },
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: messageWidgets,
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
          );
        },
      ),

      // StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('chats')
      //       .where(Filter.and(
      //           Filter('initiatorId',
      //               isEqualTo: widget.singleConversationData.initiatorId),
      //           Filter("receiverId",
      //               isEqualTo: widget.singleConversationData.initiatorId)))
      //       .snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     }
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     }

      //     List<Widget> messageWidgets = [];

      //     for (var chatDoc in snapshot.data!.docs) {
      //       messageWidgets.add(
      //         StreamBuilder<QuerySnapshot>(
      //           stream: chatDoc.reference.collection('messages').snapshots(),
      //           builder: (context, messageSnapshot) {
      //             if (!messageSnapshot.hasData) {
      //               return Center(child: CircularProgressIndicator());
      //             }

      //             List<Widget> individualMessages = [];
      //             for (var messageDoc in messageSnapshot.data!.docs) {
      //               var messageData = messageDoc.data() as Map<String, dynamic>;
      //               Message message = Message.fromJson(messageData);
      //               individualMessages.add(
      //                 ListTile(
      //                   title: Text(message.message),
      //                   //subtitle: Text(messageData['sender'] ?? ''),
      //                 ),
      //               );
      //             }

      //             return Column(
      //               children: individualMessages,
      //             );
      //           },
      //         ),
      //       );
      //     }
      //     return ListView(
      //       children: messageWidgets,
      //     );

      //     // return ListView(
      //     //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //     //     Map<String, dynamic> data =
      //     //         document.data() as Map<String, dynamic>;
      //     //     // You can access data here
      //     //     return ListTile(
      //     //       title: Text(data['initiatorId']),
      //     //       subtitle: Text(data['receiverId']),
      //     //       // Display other information as needed
      //     //     );
      //     //   }).toList(),
      //     // );
      //   },
      // ),
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
          .where('receiverId',
              isEqualTo: widget.singleConversationData.receiverId)
          .limit(1)
          .get();

      // Check if a conversation document already exists between the two users (receiver to sender)
      final chatQuery2 = await FirebaseFirestore.instance
          .collection("chats")
          .where('initiatorId',
              isEqualTo: widget.singleConversationData.receiverId)
          .where('receiverId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get();

      // If conversation document exists, use its ID to add the message
      if (chatQuery1.docs.isNotEmpty) {
        final chatDocId = chatQuery1.docs.first.id;

        Message messageData = Message(
            deleteByReceiver: false,
            deleteBySender: false,
            fromId: FirebaseAuth.instance.currentUser!.uid,
            message: messageController.text,
            messageId: currentDateTime,
            toId: widget.singleConversationData.receiverId);

        // update every last message time and message text

        FirebaseFirestore.instance.collection("chats").doc(chatDocId).update({
          'lastMessage': messageController.text,
          'lastMessageTime': currentDateTime,
        });

        // Add message to existing conversation document
        FirebaseFirestore.instance
            .collection("chats")
            .doc(chatDocId)
            .collection("messages")
            .doc(currentDateTime)
            .set(messageData.toJson());
      } else if (chatQuery2.docs.isNotEmpty) {
        final chatDocId = chatQuery2.docs.first.id;

        // update every last message time and message text

        FirebaseFirestore.instance.collection("chats").doc(chatDocId).update({
          'lastMessage': messageController.text,
          'lastMessageTime': currentDateTime,
        });

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
          "toId": widget.singleConversationData.receiverId,
        });
      }

      // else {
      //   // get my profile image url
      //   var snapshot = await FirebaseFirestore.instance
      //       .collection("users")
      //       .doc(FirebaseAuth.instance.currentUser!.uid)
      //       .get();
      //   Map<String, dynamic> currentUSerData =
      //       snapshot.data() as Map<String, dynamic>;

      //   String profileImage = currentUSerData['profile_image'];
      //   // If conversation document doesn't exist, create a new conversation
      //   FirebaseFirestore.instance.collection("chats").add({
      //     'initiatorId': FirebaseAuth.instance.currentUser!.uid,
      //     'receiverId': widget.singleConversationData.receiverId,
      //     'deleteBySender': false,
      //     'deleteByReciever': false,
      //     'senderImageUrl': profileImage,
      //     'reciverImageUrl': widget.singleConversationData.receiverImageUrl,
      //   }).then((chatDocRef) {
      //     // Add message to newly created conversation document
      //     chatDocRef.collection("messages").doc(currentDateTime).set({
      //       'deleteByReceiver': false,
      //       'deleteBySender': false,
      //       'fromId': FirebaseAuth.instance.currentUser!.uid,
      //       'message': messageController.text,
      //       "messageId": currentDateTime,
      //       "toId": widget.singleConversationData.receiverId,
      //     });
      //   });
      // }
    } catch (e) {
      print("Error sending message: $e");
    }
    messageController.clear();
  }
}

//  Expanded(
//               child: ListView.builder(
//                 itemCount: 20,
//                 itemBuilder: (context, index) {
//                   final isSender = true; // Replace true with your condition
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 10),
//                     child: Align(
//                       alignment: isSender
//                           ? Alignment.centerLeft
//                           : Alignment.centerRight,
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * 0.7,
//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(255, 0, 43, 79),
//                           borderRadius: isSender == false
//                               ? BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   bottomLeft: Radius.circular(20),
//                                   bottomRight: Radius.circular(20),
//                                 )
//                               : BorderRadius.only(
//                                   topRight: Radius.circular(20),
//                                   bottomLeft: Radius.circular(20),
//                                   bottomRight: Radius.circular(20),
//                                 ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Text(
//                             "sendCancelIfRunning: isInProgress=falsecallback=ImeCallback=ImeOnBackInvokedCallback@236",
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Row(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.85,
//                     child: TextField(
//                       controller: messageController,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       )),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       print("Message send");
//                       sendMessage();
//                     },
//                     child: Icon(
//                       Icons.send,
//                       size: 35,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
