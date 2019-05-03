import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localstorage/flutter_localstorage.dart';
import 'package:http/http.dart' as http;

import './Signup.dart';
import './MainScreen.dart';

class Login extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  final LocalStorage localStorage = new LocalStorage();

  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double textInputWidth = MediaQuery.of(context).size.width * 0.8;

    final logo = Expanded(flex: 4, child: Icon(Icons.adjust));

    final email = Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
            hintText: "E-mail...",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      ),
    );

    final password = Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: "Password...",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      ),
    );

    final submitButton = ButtonTheme(
      minWidth: textInputWidth,
      child: RaisedButton(
          color: Colors.blueAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          onPressed: () async {
            //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("LOL"), duration: Duration(seconds: 1)));

            final String url =
                'https://eventmanager-374c0.firebaseapp.com/signin';

            String email = emailController.text;
            String password = passwordController.text;

            var data = {'email': email, 'password': password};

            var response = await http.post(url,
                headers: {"Content-Type": "application/json"},
                body: json.encode(data));

            //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${response.statusCode}"), duration: Duration(seconds: 1)));

            if (response.statusCode == 400) {
              return _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("E-mail e/o password non valida!"),
                  duration: Duration(seconds: 1)));
            }

            if (response.statusCode == 422) {
              return _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("E-mail e/o password errata!"),
                  duration: Duration(seconds: 1)));
            }

            if(localStorage.getItem("email") == null) {
              localStorage.setItem("email", email);
              localStorage.setItem("password", password);
            }

            Navigator.push(context, MaterialPageRoute(
              builder: (context) => MainScreen(API_KEY: json.decode(response.body)["token"])
            ));
          },
          child: Text("LOGIN"),
          textColor: Colors.white),
    );

    final form = Expanded(
      flex: 5,
      child: Center(
        child: SizedBox(
          width: textInputWidth,
          child: Column(
            children: <Widget>[email, password, submitButton],
          ),
        ),
      ),
    );

    final subscribeLabel = Expanded(
      flex: 1,
      child: GestureDetector(
        child: Center(
          child: Text("Non hai un account? Registrati!"),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Signup()));
        },
      ),
    );

    return (Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[logo, form, subscribeLabel],
      ),
    ));
  }
}
