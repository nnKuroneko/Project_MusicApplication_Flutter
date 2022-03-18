


import 'package:flutter/cupertino.dart';
import 'package:playmusic/home_screen.dart';
import 'package:playmusic/login.dart';
import 'package:playmusic/register.dart';
import 'package:playmusic/testcode/example_playlist.dart';

final Map<String, WidgetBuilder> routes = {

  "/auth": (BuildContext context) => LoginScreen(title: ''),
  "/reg": (BuildContext context) => RegisterScreen(title: ''),
  "/home": (BuildContext context) => HomeScreen(),



};