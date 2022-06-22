import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homepage.dart';

class viewdata extends StatefulWidget {
  const viewdata({Key? key, required this.documment, required this.id})
      : super(key: key);
  final Map<String, dynamic> documment;
  final String id;

  @override
  State<viewdata> createState() => _viewdataState();
}

class _viewdataState extends State<viewdata> {
  var duration = const Duration(seconds: 5);
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _taskcontroller = TextEditingController();
  TextEditingController _descriptioncontroller = TextEditingController();
  String type = "";
  String category = "";
  bool cirecular = false;
  bool edit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskcontroller = TextEditingController(text: widget.documment["title"]);
    _descriptioncontroller =
        TextEditingController(text: widget.documment["description"]);
    category = widget.documment["category"];
    type = widget.documment["task"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff1d1e26), Color(0xff252041)])),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(CupertinoIcons.arrow_left),
                color: Colors.white,
                iconSize: 28,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Todo")
                          .doc(_auth.currentUser!.uid)
                          .collection("todos")
                          .doc(widget.id)
                          .delete()
                          .then((value) => Navigator.pop(context));
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.redAccent,
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        edit = !edit;
                      });
                    },
                    icon: Icon(Icons.edit),
                    color: edit ? Colors.red : Colors.white,
                    iconSize: 28,
                  ),
                ],
              ),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 5),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    edit ? "EDIT" : "VIEW",
                    style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4),
                  ),
                  SizedBox(height: 8),
                  Text("YOUR TODO",
                      style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                  SizedBox(
                    height: 25,
                  ),
                  label("Task title"),
                  SizedBox(
                    height: 12,
                  ),
                  title(),
                  SizedBox(
                    height: 30,
                  ),
                  label("Task Type"),
                  SizedBox(
                    height: 12,
                  ),
                  Row(children: [
                    tasktype("Important", 0xff2664fa),
                    SizedBox(
                      width: 20,
                    ),
                    tasktype("planned", 0xff2bc8d9),
                  ]),
                  SizedBox(
                    height: 25,
                  ),
                  label("Description"),
                  SizedBox(
                    height: 12,
                  ),
                  description(),
                  SizedBox(
                    height: 25,
                  ),
                  label("Category"),
                  SizedBox(
                    height: 12,
                  ),
                  Wrap(children: [
                    categoryselect("Food", 0xff2bc84e2),
                    SizedBox(
                      width: 20,
                    ),
                    categoryselect("Workout", 0xff2de8d9),
                    SizedBox(
                      width: 20,
                    ),
                    categoryselect("Work", 0xff52c8d9),
                    SizedBox(
                      width: 20,
                    ),
                    categoryselect("Run", 0xff27a8d9),
                    SizedBox(
                      width: 20,
                    ),
                    categoryselect("other", 0xff2ba1d9),
                    SizedBox(
                      height: 50,
                    ),
                    edit ? Button() : Container(),
                    SizedBox(
                      height: 30,
                    )
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget Button() {
    return InkWell(
      onTap: () {
        setState(() {
          cirecular = true;
        });
        if (_taskcontroller.text != "" &&
            _descriptioncontroller.text != "" &&
            category != "" &&
            type != "") {
          FirebaseFirestore.instance
              .collection("Todo")
              .doc(_auth.currentUser!.uid)
              .collection("todos")
              .doc(widget.id)
              .update({
            "title": _taskcontroller.text,
            "task": type,
            "description": _descriptioncontroller.text,
            "category": category
          });

          final snackBar = SnackBar(content: Text("Task Updated"));
          Navigator.pop(context);
        } else {
          final snackBar = SnackBar(content: Text("Fill all the details"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        setState(() {
          cirecular = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 56,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Color(0xff8a32f1),
              Color(0xffad32f9),
            ])),
        child: Center(
            child: cirecular
                ? CircularProgressIndicator()
                : Text("Update todo",
                    style: TextStyle(color: Colors.white, fontSize: 15))),
      ),
    );
  }

  Widget tasktype(String text, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = text;
              });
            }
          : null,
      child: Chip(
        backgroundColor: type == text ? Colors.black : Color(color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 3.8, horizontal: 17),
      ),
    );
  }

  Widget categoryselect(String text, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = text;
              });
            }
          : null,
      child: Chip(
        backgroundColor: category == text ? Colors.black : Color(color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 3.8, horizontal: 17),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
          enabled: edit,
          controller: _descriptioncontroller,
          style: TextStyle(color: Colors.grey, fontSize: 17),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Task title",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
              contentPadding: EdgeInsets.only(left: 20, right: 20))),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
          enabled: edit,
          controller: _taskcontroller,
          style: TextStyle(color: Colors.grey, fontSize: 17),
          maxLines: null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Task title",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
              contentPadding: EdgeInsets.only(left: 20, right: 20))),
    );
  }

  Widget label(String label) {
    return Text(label,
        style: TextStyle(
            fontSize: 16.5,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2));
  }
}
