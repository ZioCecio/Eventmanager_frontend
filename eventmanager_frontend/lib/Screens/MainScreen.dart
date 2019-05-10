import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../Widgets/EventList.dart';
import './NewEventForm.dart';

class MainScreen extends StatefulWidget {
  final String API_KEY;

  MainScreen({Key key, @required this.API_KEY}) : super(key : key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
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

    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = <Widget> [
      EventList(events: events, type: 'events'),
      EventList(events: events, type: 'subscribedEvents'),
      EventList(events: events, type: 'createdEvents')
    ];

    return (
      Scaffold(
        appBar: AppBar(
          title: Text("EventManager"),
        ),
        body: this.events == null ? Center(child: CircularProgressIndicator()) : widgets[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text("Eventi")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text("Iscrizioni")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text("Creati")
            )
          ],
          onTap: (int index) {
            setState(() {
             this._selectedIndex = index;
             this.events = null;
             this._fetchEvents();
            });
          },
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
        ),
        floatingActionButton: _selectedIndex == 2 ? FloatingActionButton(
          heroTag: 'createButtons',
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventForm(authorPaolo: this._onPress)));},
        ) : null
      )
    );
  }

  _onPress () {
    setState(() {
     _fetchEvents(); 
    });
  }
}