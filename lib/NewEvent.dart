import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'main.dart';

class NewEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ToDo()));
                },
                icon: Icon(Icons.arrow_back_ios_rounded)),
            Text(
              "New Event",
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ToDo()));
                },
                icon: Icon(Icons.done)),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          EventEmoji(),
          EventName(),
          EventDetails(),
          EventDate(),
        ],
      ),
    );
  }
}

class EventEmoji extends StatefulWidget {
  @override
  _EventEmojiState createState() => _EventEmojiState();
}

class _EventEmojiState extends State<EventEmoji> {
  void updateEventName(String text1) {
    setState(() {
      userText1 = text1;
    });
  }

  String userText1 = "";
  @override
  Widget build(BuildContext context) {
    return TextField(   onChanged: updateEventName,
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: "Icon"),
    );
  }
}


class EventName extends StatefulWidget {
  @override
  _EventNameState createState() => _EventNameState();
}

class _EventNameState extends State<EventName> {
  void updateEventName(String text2) {
    setState(() {
      userText2 = text2;
    });
  }

  String userText2 = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: updateEventName,
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: "Eventname"),
    );
  }
}


class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  void updateEventDetails(String text3) {
    setState(() {
      userText3 = text3;
    });
  }

  String userText3 = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: updateEventDetails,
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      decoration:
      InputDecoration(border: OutlineInputBorder(), labelText: "Eventdetails"),
    );
  }
}

class EventDate extends StatefulWidget {
  @override
  _EventDateState createState() => _EventDateState();
}

class _EventDateState extends State<EventDate> {
  void updateEventDate(DateTime text4) {
    setState(() {
      userText4 = text4;
    });
  }

  DateTime userText4;
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      selectedDate: userText4,
      onDateSelected: updateEventDate, //TODO hier am besten das aktuelle Jahr; LastDate kann weggelassen werden
    );
  }
}


