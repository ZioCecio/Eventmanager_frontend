import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './Event.dart';

import './../Settings.dart';

class EventList extends StatefulWidget {
  final List events;
  final String type;

  EventList({Key key, @required this.events, @required this.type});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List alreadySubscribedEvents, createdEvents;
  bool fetched = false;

  _fetchAll() async {
    fetched = true;

    var response = await http.get(
        'https://eventmanager-374c0.firebaseapp.com/users/${Settings.userId}/events',
        headers: {'token': Settings.token});

    setState(() {
      alreadySubscribedEvents =
          json.decode(response.body)['subscribedEvents'].toList();
      createdEvents = json.decode(response.body)['createdEvents'].toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!fetched) _fetchAll();

    final events = alreadySubscribedEvents == null
        ? List()
        : this.widget.type == 'events'
            ? this
                .widget
                .events
                .where(
                    (event) => !alreadySubscribedEvents.contains(event['id']))
                .toList()
            : this.widget.type == 'subscribedEvents'
                ? this
                    .widget
                    .events
                    .where((event) =>
                        alreadySubscribedEvents.contains(event['id']))
                    .toList()
                : this.widget.events.where((event) => event['owner'] == Settings.userId).toList();

    if(events.length == 0 && alreadySubscribedEvents != null)
      return Center(child: Text('Nessun evento trovato...', style: TextStyle(color: Colors.blueGrey)));

    if(events.length == 0 && alreadySubscribedEvents == null)
      return Center(child: CircularProgressIndicator());

    return (ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return Event(
            event: events[index],
            type: this.widget.type == 'events' ? 'event' : this.widget.type == 'subscribedEvents' ? 'subscribedEvents' : 'createdEvents',
            itemTapped: _onItemTap,
          );
        }));
  }

  _onItemTap() {
    _fetchAll();
  }
}
