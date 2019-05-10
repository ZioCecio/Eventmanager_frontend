import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localstorage/flutter_localstorage.dart';
import 'package:http/http.dart' as http;

import './MainScreen.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  final LocalStorage localStorage = new LocalStorage();

  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();
  static final nameController = TextEditingController();
  static final surnameController = TextEditingController();

  bool disabled = false;

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

    final name = Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: nameController,
        decoration: InputDecoration(
            hintText: "Nome...",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      ),
    );

    final surname = Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: surnameController,
        decoration: InputDecoration(
            hintText: "Cognome...",
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
          onPressed: disabled ? () {} : () async {
            setState(() {
             disabled = true; 
            });

            final String url =
                'https://eventmanager-374c0.firebaseapp.com/signup';

            String email = emailController.text;
            String password = passwordController.text;
            String name = nameController.text;
            String surname = surnameController.text;

            var data = {
              'email': email,
              'password': password,
              'name': name,
              'surname': surname
            };

            var response = await http.post(url,
                headers: {'Content-Type': 'application/json'},
                body: json.encode(data));

            setState(() {
             disabled = false; 
            });

            if (response.statusCode == 400) {
              return _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Dati non validi.'),
                  duration: Duration(seconds: 1)));
            }

            if (response.statusCode == 422) {
              return _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('E-mail già in uso.'),
                  duration: Duration(seconds: 1)));
            }

            try {
              localStorage.setItem('email', email);
              localStorage.setItem('password', password);
            } catch (error) {
              print(error);
            }

            Navigator.push(context, MaterialPageRoute(
              builder: (context) => MainScreen(API_KEY: json.decode(response.body)['token'])
            ));
          },
          child: disabled ? SizedBox(width: MediaQuery.of(context).size.width * 0.07, height: MediaQuery.of(context).size.width * 0.07, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),) : Text('SIGNUP'),
          textColor: Colors.white),
    );

    final form = Expanded(
      flex: 9,
      child: Center(
        child: SizedBox(
          width: textInputWidth,
          child: ListView(
            children: <Widget>[email, password, name, surname, submitButton],
          ),
        ),
      ),
    );

    final subscribeLabel = Expanded(
      flex: 1,
      child: GestureDetector(
        child: Center(
          child: Text('Hai già un account? Accedi!'),
        ),
        onTap: () {
          Navigator.pop(context);
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
