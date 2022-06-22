import 'package:app1/pages/addtodo.dart';
import 'package:app1/pages/homepage.dart';
import 'package:app1/pages/sign_in.dart';
import 'package:app1/pages/sign_up.dart';
import 'package:app1/service/auth_methods.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Widget currentPage = signup();
  AuthMethods auth = new AuthMethods();

  @override
  State<MyApp> createState() => _MyAppState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        backgroundColor: Color.fromARGB(1, 6, 45, 197),
        splashTransition: SplashTransition.sizeTransition,
        splash: Image.asset(
          "assets/logo.png",
        ),
        splashIconSize: double.maxFinite,
        nextScreen: StreamBuilder(
          stream: AuthMethods().authChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return homepage();
            }

            return signin();
          },
        ),
      ),
    );
  }
}
