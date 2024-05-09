import 'package:chat_app_for_class/chat/model/all_users_model.dart';
import 'package:chat_app_for_class/chat/view/inbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return InboxScreen(
                    singleUserData: myUSersList[index],
                  );
                }));
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
}
