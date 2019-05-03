import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localstorage/flutter_localstorage.dart';
import 'package:http/http.dart' as http;

class EventList extends StatefulWidget {
  final List events;

  EventList({Key key, @required this.events});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = this.widget.events;

    return (ListView.builder(
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) {
        return (Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(events[index]['name'])),
                      Text(events[index]['description'])
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.supervisor_account),
                        Text(
                            '${events[index]["numberOfAlreadySubscribed"]}/${events[index]["maxPartecipants"]}')
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.timer),
                        Text('${events[index]["duration"]}')
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
      },
    ));
  }
}
