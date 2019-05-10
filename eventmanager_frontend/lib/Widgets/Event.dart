import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../Settings.dart';

class Event extends StatefulWidget {
  final event;
  final String type;
  final Function itemTapped;

  Event({Key key, @required this.event, @required this.type, this.itemTapped});

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    final double fontSize = MediaQuery.of(context).size.width * 0.07;
    final double minHeightCard = MediaQuery.of(context).size.height * 0.15;
    final double fontSizeIcons = MediaQuery.of(context).size.width * 0.05;
    final double floatingButtonWidth = MediaQuery.of(context).size.width * 0.15;

    final String dateTime = new DateTime.fromMillisecondsSinceEpoch(
            this.widget.event['date']['_seconds'] * 1000)
        .toIso8601String();
    final List date = dateTime.split('T');

    return (ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeightCard),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minHeightCard),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  this.widget.event['name'],
                                  style: TextStyle(fontSize: fontSize),
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(this.widget.event['description']),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: minHeightCard),
                        child: Container(
                            child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.supervised_user_circle),
                                  Text(
                                    '${this.widget.event["numberOfAlreadySubscribed"]}/${this.widget.event["maxPartecipants"]}',
                                    style: TextStyle(
                                      fontSize: fontSizeIcons,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.timer),
                                  Text(
                                    '${this.widget.event["duration"]}',
                                    style: TextStyle(
                                      fontSize: fontSizeIcons,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.calendar_today),
                                  Text(
                                    '${date[0]}',
                                    style: TextStyle(
                                      fontSize: fontSizeIcons * 0.7,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.watch_later),
                                  Text(
                                    '${date[1].substring(0, 5)}',
                                    style: TextStyle(
                                      fontSize: fontSizeIcons,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                      ))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(width: 2)),
                        child: Text('Da ${this.widget.event['id']}'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: floatingButtonWidth,
                      height: floatingButtonWidth,
                      padding: EdgeInsets.only(bottom: 7),
                      child: FloatingActionButton(
                        heroTag: '${this.widget.event['id']}',
                        child: this.widget.type == 'event'
                            ? Icon(Icons.add)
                            : Icon(Icons.delete),
                        backgroundColor: this.widget.type == 'event'
                            ? Colors.blue
                            : Colors.red,
                        onPressed: this.widget.type == 'event'
                            ? () => _subscribeOnAEvent()
                            : this.widget.type == 'subscribedEvents'
                            ? () => _unSubscribeFromEvent()
                            : () => _deleteEvent(),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  _subscribeOnAEvent() async {
    final String url =
        'https://eventmanager-374c0.firebaseapp.com/events/${this.widget.event["id"]}/users';
    var response;

    try {
      response = await http.post(url, headers: {'token': Settings.token});

      this.widget.itemTapped();
    } catch (e) {
      print(e);
    }
  }

  _unSubscribeFromEvent() async {
    final String url =
        'https://eventmanager-374c0.firebaseapp.com/events/${this.widget.event["id"]}/users/${Settings.userId}';

    var response;

    try {
      response = await http.delete(url, headers: {'token': Settings.token});
      this.widget.itemTapped();
    } catch (e) {
      print(e);
    }
  }

  _deleteEvent() async {
    final String url =
        'https://eventmanager-374c0.firebaseapp.com/events/${this.widget.event["id"]}';

    var response;

    try {
      response = await http.delete(url, headers: {'token': Settings.token});
      this.widget.itemTapped();
    }catch(e){
      print(e);
    }
  }
}
