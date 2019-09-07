import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  State<LoginScreen> createState() {
    return LoginScreenState();
  }
}
class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    String email = emailController.value.text;
    String password = emailController.value.text;

    Navigator.pushReplacementNamed(context, '/home');
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
      child: Text("Login!", style: TextStyle(color: Colors.white)),
      onPressed: login,
      animationDuration: Duration(seconds: 5),
    );

    final loginTitle = Container(
      padding: EdgeInsets.all(50.0),
      child: Text("SafetyNet", style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: "Verdana")),
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
                  loginButton
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
