import 'package:app1/custom/todocard.dart';
import 'package:app1/pages/addtodo.dart';
import 'package:app1/pages/sign_up.dart';

import 'package:app1/pages/viewdata.dart';
import 'package:app1/service/auth_methods.dart';
import 'package:app1/service/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  AuthMethods authMethods = AuthMethods();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  String id2 = "";

  List<select> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Today's schedule",
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.png"),
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(DateTime.now()),
                      style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        var instance = FirebaseFirestore.instance
                            .collection("Todo")
                            .doc(_auth.currentUser!.uid)
                            .collection("todos");

                        for (int i = 0; i < selected.length; i++) {
                          if (selected[i].checkvalue == true) {
                            instance.doc(selected[i].id).delete();
                          }
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => homepage()));
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.redAccent,
                      iconSize: 28,
                    ),
                  ],
                ),
              ),
            )),
      ),
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.black87, items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 32,
            color: Colors.white,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => todopage()),
                  (route) => false);
            },
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Colors.indigoAccent,
                    Colors.purple,
                  ])),
              child: Icon(
                Icons.add,
                size: 33,
                color: Colors.white,
              ),
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: (() => authMethods.signOut(context)),
            child: Icon(
              Icons.logout_outlined,
              size: 32,
              color: Colors.white,
            ),
          ),
          label: "",
        ),
      ]),
      body: StreamBuilder<Object>(
          stream: FirestoreMethods().meetingsHistory,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            // var docs;
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String id1 = snapshot.data.docs[index].id;
                  id2 = id1;
                  IconData iconData;
                  Color color;
                  iconData = Icons.run_circle_outlined;
                  color = Colors.white;
                  Map<String, dynamic> document =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  //snapshot.data.docs[index].data() as Map<String, dynamic>;
                  switch (document["category"]) {
                    case "Work":
                      iconData = Icons.run_circle_outlined;
                      color = Colors.red;
                      break;

                    case "Workout":
                      iconData = Icons.alarm_add_sharp;
                      color = Colors.teal;
                      break;

                    case "Food":
                      iconData = Icons.local_grocery_store;
                      color = Colors.deepOrange;
                      break;
                    default:
                      iconData = Icons.rule_sharp;
                      color = Colors.deepPurple;
                      break;
                  }
                  selected.add(select(
                      id: snapshot.data.docs[index].id, checkvalue: false));

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => viewdata(
                                    documment: document,
                                    id: snapshot.data.docs[index].id,
                                  )));
                    },
                    child: todocard(
                        title: document["title"],
                        iconData: iconData,
                        iconcolor: color,
                        time: "10 PM",
                        check: selected[index].checkvalue,
                        index: index,
                        onchanged: onchanged,
                        iconbgcolor: Colors.black),
                  );
                });
          }),
    );
  }

  void onchanged(int index) {
    setState(() {
      selected[index].checkvalue = !selected[index].checkvalue;
    });
  }
}

class select {
  String id = "";
  bool checkvalue = false;
  select({
    required this.id,
    required this.checkvalue,
  });
}
