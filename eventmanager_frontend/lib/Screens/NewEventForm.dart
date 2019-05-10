import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './../Settings.dart';

class NewEventForm extends StatefulWidget {
  final Function authorPaolo;

  NewEventForm({Key key, @required Function this.authorPaolo});

  @override
  _NewEventFormState createState() => _NewEventFormState();
}

class _NewEventFormState extends State<NewEventForm> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  static final nameController = TextEditingController();
  static final descriptionController = TextEditingController();
  static final partecipantsController = TextEditingController();
  static final durationController = TextEditingController();

  static DateTime dateController = DateTime.now();
  static TimeOfDay hourController = TimeOfDay.now();

  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    final double marginTopFormElements =
        MediaQuery.of(context).size.height * 0.04;

    final name = Padding(
        padding: EdgeInsets.only(top: marginTopFormElements),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Nome dell\'evento',
          ),
        ));

    final description = Padding(
      padding: EdgeInsets.only(top: marginTopFormElements),
      child: TextFormField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: descriptionController,
        decoration: InputDecoration(hintText: 'Descrizione dell\'evento'),
      ),
    );

    final maxPartecipants = Padding(
      padding: EdgeInsets.only(top: marginTopFormElements),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: partecipantsController,
        decoration: InputDecoration(hintText: 'Massimo numero di partecipanti'),
      ),
    );

    final duration = Padding(
      padding: EdgeInsets.only(top: marginTopFormElements),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: durationController,
        decoration: InputDecoration(hintText: 'Durata dell\'evento'),
      ),
    );

    final date = Padding(
      padding: EdgeInsets.only(top: marginTopFormElements),
      child: Row(
        children: <Widget>[
          Text(
            'Data dell\'evento: ${dateController.year}-${dateController.month}-${dateController.day}',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: RaisedButton(
              child: Text('Cambia'),
              onPressed: () {
                selectDate(context);
              },
            ),
          )
        ],
      ),
    );

    final hour = Padding(
      padding: EdgeInsets.only(top: marginTopFormElements),
      child: Row(
        children: <Widget>[
          Text(
            'Ora dell\'evento: ${hourController.format(context)}          ',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: RaisedButton(
              child: Text('Cambia'),
              onPressed: () {
                selectHour(context);
              },
            ),
          )
        ],
      ),
    );

    final submitButton = Padding(
      padding: EdgeInsets.only(top: marginTopFormElements),
      child: ButtonTheme(
          child: RaisedButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () async {
          setState(() {
            disabled = true;
          });

          final String url =
              'https://eventmanager-374c0.firebaseapp.com/events';

          var response;
          final String month = dateController.month < 10 ? '0${dateController.month}' : '${dateController.month}';

          var data = {
            'name': nameController.text,
            'description': descriptionController.text,
            'date':
                '${dateController.year}-${month}-${dateController.day}T${hourController.format(context)}',
            'place': '0.123213,-0.312312',
            'maxPartecipants': partecipantsController.text,
            'duration': durationController.text,
            'type': 'CommonEvent'
          };

          try {
            response = await http.post(url, body: data, headers: {'token': Settings.token});
          } catch (e) {
            print(e);
          }

          setState(() {
           disabled = false; 
          });

          print(response.body);

          if (response.statusCode == 400 || response.statusCode == 422)
            return _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Tutti i campi vanno compilati correttamente.'),
                duration: Duration(seconds: 1)));

          nameController.text = '';
          descriptionController.text = '';
          partecipantsController.text = '';
          durationController.text = '';
          dateController = DateTime.now();
          hourController = TimeOfDay.now();

          this.widget.authorPaolo();
          Navigator.pop(context);
        },
        child: disabled
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.width * 0.07,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text('CREA'),
        textColor: Colors.white,
      )),
    );

    final form = Expanded(
      flex: 9,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView(
            children: <Widget>[
              name,
              description,
              maxPartecipants,
              duration,
              date,
              hour,
              submitButton
            ],
          ),
        ),
      ),
    );

    return (Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Aggiungi un evento'),
        ),
        body: Column(
          children: <Widget>[form],
        ))
        );
  }

  Future<Null> selectDate(BuildContext context) async {
    DateTime selectDate = await showDatePicker(
        context: context,
        initialDate: dateController,
        firstDate: DateTime(2019),
        lastDate: DateTime(2030));

    setState(() {
      dateController = selectDate;
    });
  }

  Future<Null> selectHour(BuildContext context) async {
    TimeOfDay selectHour =
        await showTimePicker(context: context, initialTime: hourController);

    setState(() {
      hourController = selectHour;
    });
  }
}
