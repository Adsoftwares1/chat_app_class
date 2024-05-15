import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MessagesSCreen extends StatefulWidget {
  MessagesSCreen();

  @override
  State<MessagesSCreen> createState() => _MessagesSCreenState();
}

class _MessagesSCreenState extends State<MessagesSCreen> {
  @override
  Widget build(BuildContext context) {
    // Define two separate streams for initiatorId and receiverId

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where(Filter.or(
                Filter('initiatorId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid),
                Filter("receiverId",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)))
            // .where('initiatorId',
            //     isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            // .where('receiverId',
            //     isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              // You can access data here
              return ListTile(
                title: Text(data['initiatorId']),
                subtitle: Text(data['receiverId']),
                // Display other information as needed
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
