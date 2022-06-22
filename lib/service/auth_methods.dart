import 'package:app1/pages/homepage.dart';
import 'package:app1/pages/sign_in.dart';
import 'package:app1/pages/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  bool isusercreate = false;
  bool res = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;


  Future<void> googlesignin(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => homepage()),
              (route) => false);
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(content: Text("not signin"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> signInWithoogle(BuildContext context,
      TextEditingController email, TextEditingController password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
          });
        }
      }
      return res = true;
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return res = false;
    }
  }

  Future<bool> createuser(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) => signin()), (route) => false);
      return isusercreate = true;
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return isusercreate = false;
    }
  }

  void signOut(BuildContext context) async {
    try {
      _auth.signOut();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) => signin()), (route) => false);
    } catch (e) {
      print(e);
    }
  }
}
