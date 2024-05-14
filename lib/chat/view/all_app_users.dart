import 'package:chat_app_for_class/chat/model/all_users_model.dart';
import 'package:chat_app_for_class/chat/model/messages_model.dart';
import 'package:chat_app_for_class/chat/view/inbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllUsersList extends StatefulWidget {
  const AllUsersList({super.key});

  @override
  State<AllUsersList> createState() => _AllUsersListState();
}

class _AllUsersListState extends State<AllUsersList> {
  List<AllUsersModel> myUSersList = [];

  var messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getAllUSerData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All users"),
      ),
      body: ListView.builder(
          itemCount: myUSersList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Send Message"),
                              TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: "Say hi",
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    sendMessage(myUSersList[index]);

                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: Colors.green,
                                    width: 100,
                                    height: 30,
                                    child: Center(
                                        child: Text(
                                      "Send",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ))
                            ],
                          ),
                        ),
                      );
                    });
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return InboxScreen(
                //     singleUserData: myUSersList[index],
                //   );
                // }));
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.network(myUSersList[index].profileImage),
                ),
                title: Text(myUSersList[index].name),
              ),
            );
          }),
    );
  }

  Future<void> getAllUSerData() async {
    try {
      var allUsersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      allUsersSnapshot.docs.forEach((doc) {
        if (doc.exists) {
          myUSersList.add(AllUsersModel.fromJson(doc.data()));
        }
      });

      setState(() {});

      print("All user data: ${myUSersList}");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> sendMessage(AllUsersModel singleUSerData) async {
    String currentDateTime = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      // Check if a conversation document already exists between the two users (sender to receiver)
      final chatQuery1 = await FirebaseFirestore.instance
          .collection("chats")
          .where('initiatorId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('receiverId', isEqualTo: singleUSerData.userId)
          .limit(1)
          .get();

      // Check if a conversation document already exists between the two users (receiver to sender)
      final chatQuery2 = await FirebaseFirestore.instance
          .collection("chats")
          .where('initiatorId', isEqualTo: singleUSerData.userId)
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
            toId: singleUSerData.userId);

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
          "toId": singleUSerData.userId,
        });
      } else {
        // get my profile image url
        var snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        Map<String, dynamic> currentUSerData =
            snapshot.data() as Map<String, dynamic>;

        String profileImage = currentUSerData['profile_image'];
        String chatInitiatorName = currentUSerData['name'];
        // If conversation document doesn't exist, create a new conversation
        FirebaseFirestore.instance.collection("chats").add({
          'initiatorId': FirebaseAuth.instance.currentUser!.uid,
          'receiverId': singleUSerData.userId,
          'deleteBySender': false,
          'deleteByReciever': false,
          'senderImageUrl': profileImage,
          'reciverImageUrl': singleUSerData.profileImage,
          'chatReciverName': singleUSerData.name,
          'chatInitiatorName': chatInitiatorName,
          'lastMessage': messageController.text,
          'lastMessageTime': currentDateTime,
        }).then((chatDocRef) {
          // Add message to newly created conversation document
          chatDocRef.collection("messages").doc(currentDateTime).set({
            'deleteByReceiver': false,
            'deleteBySender': false,
            'fromId': FirebaseAuth.instance.currentUser!.uid,
            'message': messageController.text,
            "messageId": currentDateTime,
            "toId": singleUSerData.userId,
          });
        });
      }
    } catch (e) {
      print("Error sending message: $e");
      messageController.clear();
    }

    messageController.clear();
  }
}
