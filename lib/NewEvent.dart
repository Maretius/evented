import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';


class NewEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ToDo()));
                  },
                  icon: Icon(Icons.arrow_forward)),
                Text("New Event",),
                Icon(Icons.arrow_forward, color: kTextColor,)
              ],
            ),
        backgroundColor: kBackgroundColorPrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          EventName()
        ],
      ),
    );
  }
}

class EventName extends StatefulWidget {
  @override
  _EventNameState createState() => _EventNameState();
}

class _EventNameState extends State<EventName> {
  void updateEventName(String text){
    setState(() {
      userText = text;
    });
  }
  String userText = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: updateEventName,
    );
  }
}
