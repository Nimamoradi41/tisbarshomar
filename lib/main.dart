// @dart=2.9
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppShip/LoginScreen.dart';
import 'AppShip/MainPage.dart';
import 'MyWidget.dart';
void main() {
  runApp( MyApp());
}
class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'iranyekanbold',
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      // home: MainPage(),
    );
  }
}

