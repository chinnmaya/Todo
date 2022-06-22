import 'package:app1/pages/sign_in.dart';
import 'package:app1/pages/sign_up.dart';
import 'package:app1/service/auth_methods.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import './homepage.dart';

class signin extends StatefulWidget {
  const signin({Key? key}) : super(key: key);

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  AuthMethods auth = new AuthMethods();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  bool cirecular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SIGN IN",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              button_item("assets/google.svg", "continue with google", 30,
                  () async {
                auth.googlesignin(context);
              }),
              SizedBox(
                height: 18,
              ),
              Text(
                "OR",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 18,
              ),
              take_item(_email),
              SizedBox(
                height: 15,
              ),
              pass(_pass),
              SizedBox(
                height: 40,
              ),
              colorbtn(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont have an account?",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => signup()),
                          (route) => false);
                    },
                    child: Text(
                      "SIGN UP?",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button_item(
      String imagepath, String btn_name, double size, Function ontab) {
    return InkWell(
      onTap: () {
        ontab();
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 60,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(width: 1, color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                btn_name,
                style: TextStyle(fontSize: 17, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget take_item(TextEditingController controller) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width - 70,
      child: TextFormField(
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        controller: controller,
        decoration: InputDecoration(
          labelText: "Email...",
          labelStyle: TextStyle(fontSize: 17, color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1.5, color: Colors.amber),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }

  Widget colorbtn() {
    return InkWell(
      onTap: () async {
        setState(() {
          cirecular = true;
        });
        try {
          bool result = await auth.signInWithoogle(context, _email, _pass);
          if (result == true) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => homepage()),
                (route) => false);
          }
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            cirecular = false;
          });
        }
      },
      child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xfffd746c),
              Color(0xffff9068),
              Color(0xfffd746c)
            ]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: cirecular
                ? CircularProgressIndicator()
                : Text(
                    "SIGN UP",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
          )),
    );
  }

  Widget pass(TextEditingController controller) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width - 70,
      child: TextFormField(
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "password...",
          labelStyle: TextStyle(fontSize: 17, color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1.5, color: Colors.amber),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
