import 'package:flutter/material.dart';
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
        backgroundColor: kBackgroundColorPrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          EventEmoji(),
          EventName(),
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
    return TextField(
      onChanged: updateEventName,
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
