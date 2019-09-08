import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'globals.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  State<LoginScreen> createState() {
    return LoginScreenState();
  }
}
class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(context) async {
    String email = emailController.value.text;
    String password = passwordController.value.text;

    String url = '$server/api/login';
    Map<String,String> headers = {"Content-type": "application/json"};
    Map<String,String> bodyData = {"email": email, "password": password};
    Response response = await post(url, headers: headers, body: json.encode(bodyData));

    Map<String, dynamic> responseMap = json.decode(response.body);
    if (responseMap['status'] == "error") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Incorrect username or password!"),
          actions: <Widget>[
            MaterialButton(
              child: Text("OK", style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        )
      );
    } else {
      print("Success!");
      final preferences = await SharedPreferences.getInstance();
      preferences.setString("authtoken", responseMap['authtoken']);
      Navigator.pushReplacementNamed(context, "/home");
      print(preferences.getKeys());
    }

  }

  void register(context) async {
    String email = emailController.value.text;
    String password = passwordController.value.text;

    String url = '$server/api/register';
    Map<String,String> headers = {"Content-type": "application/json"};
    Map<String,String> bodyData = {"email": email, "password": password};
    Response response = await post(url, headers: headers, body: json.encode(bodyData));

    Map<String, dynamic> responseMap = json.decode(response.body);
    if (responseMap['status'] == "error") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("That user already exists!"),
          actions: <Widget>[
            MaterialButton(
              child: Text("OK", style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        )
      );
    } else {
      print("Success!");
      final preferences = await SharedPreferences.getInstance();
      preferences.setString("authtoken", responseMap['authtoken']);
      Navigator.pushReplacementNamed(context, "/home");
    }

  }

  Widget build(BuildContext context) {
    final emailField = Container(
      width: 300.0,
      child: TextField(
        controller: emailController,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 3.0),
          )
        )
      ),
      margin: EdgeInsets.only(bottom: 30.0),
    );

    final passwordField = Container(
      width: 300.0,
      child: TextField(
        controller: passwordController,
        obscureText: true,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 3.0),
          )
        )
      )
    );

    final loginButton = MaterialButton(
      child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16.0)),
      onPressed: () => login(context),
      animationDuration: Duration(seconds: 5),
    );

  final registerButton = MaterialButton(
      child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 16.0)),
      onPressed: () => register(context),
      animationDuration: Duration(seconds: 5),
    );

    final loginTitle = Container(
      padding: EdgeInsets.all(50.0),
      child: Text("Intellicity", style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: "Verdana")),
    );

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loginTitle,
            emailField,
            passwordField,
            Container(
              width: 300.0,
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  registerButton, loginButton
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topCenter
          )
        ),
      )
    );
  }
}
