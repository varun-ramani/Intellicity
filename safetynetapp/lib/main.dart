import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'homescreen.dart';
import 'package:flutter/services.dart';
import 'permissions_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext build) {
    PermissionsService().requestCamera();
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SafetyNet",
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
