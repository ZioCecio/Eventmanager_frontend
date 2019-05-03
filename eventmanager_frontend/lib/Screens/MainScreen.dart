import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localstorage/flutter_localstorage.dart';
import 'package:http/http.dart' as http;

import './Signup.dart';
import './../Widgets/EventList.dart';

class MainScreen extends StatefulWidget {
  final String API_KEY;

  MainScreen({Key key, @required this.API_KEY}) : super(key : key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List events;

  _fetchEvents() async {
    final String url = 'https://eventmanager-374c0.firebaseapp.com/events';

    var response = await http.get(url, headers: {"token": this.widget.API_KEY});

    setState(() {
     events = json.decode(response.body).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    this._fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
        body: this.events == null ? CircularProgressIndicator() : EventList(events: events),
      )
    );
  }
}