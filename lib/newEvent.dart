import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
// import 'main.dart';

class NewEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_rounded)),
          title: Text(
            "New Event",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.done_rounded)),
          ],
          backgroundColor: kPrimaryColor,
        ),
        body: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width / 6.0,
                        child: EventEmoji(),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: EventName(),
                      ),
                    ],
                  ),
                ),
                EventDetails(),
                EventDate(),
                EventTasks(),
                Container(
                  height: 200,
                  color: Colors.yellow,
                )
              ],
            ),
          ),
        ),
        // TODO backgroundColor: kPrimaryBackgroundColor,
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
      textAlign: TextAlign.center,
      onChanged: updateEventName,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Icon"),
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
      maxLength: 20,
      // TODO autofocus: true,
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
      maxLines: 3,
      maxLength: 200,
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: "Eventdetails"),
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
      onDateSelected:
          updateEventDate, //TODO hier am besten das aktuelle Jahr; LastDate kann weggelassen werden
    );
  }
}

class EventTasks extends StatefulWidget {
  @override
  _EventTasksState createState() => _EventTasksState();
}

class _EventTasksState extends State<EventTasks> {
  void updateEventTasks(String text4) {
    setState(() {
      userText4 = text4;
    });
  }

  String userText4 = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: updateEventTasks,
      decoration:
      InputDecoration(border: OutlineInputBorder(), labelText: "Eventtasks"),
    );
  }
}