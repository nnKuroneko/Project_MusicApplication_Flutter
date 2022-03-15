import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playmusic/login.dart';
import 'package:playmusic/music.dart';
import 'package:playmusic/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:playmusic/register.dart';
import 'package:playmusic/testcode.dart';
import 'package:playmusic/widget/router.dart';


String initialRoute = "/auth";

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null){
        initialRoute = "/home";
      }
    runApp(MyApp());
    });
  });

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    routes: routes,
      initialRoute: initialRoute,
    debugShowCheckedModeBanner: false,
    );
  }
}

