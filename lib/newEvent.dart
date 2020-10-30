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
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: EventEmoji(),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width * 0.58,
                        child: EventName(),
                      ),
                    ],
                  ),
                ),
                EventDetails(),

                EventDate(),


                Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.58,
                        child: EventTasks(),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.add_rounded),
                          iconSize: 32.0,
                          color: Colors.white,
                          splashRadius: 24.0,
                        ),
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: CircleBorder()
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // TODO backgroundColor: kPrimaryBackgroundColor,
    );
  }
}


/* TODO Link zum Date / Timepicker ohne Package
 https://medium.com/@LohaniDamodar/date-and-time-pickers-in-flutter-without-using-any-packages-1de04a13938c
 */

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
          border: OutlineInputBorder(), 
          labelText: "Eventdetails"),
    );
  }
}


class EventDate extends StatefulWidget {
  @override
  _EventDateState createState() => _EventDateState();
}

class _EventDateState extends State<EventDate> {

  DateTime _date = DateTime.now();
  
  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(), 
        firstDate: DateTime.now(), 
        lastDate: DateTime(2021),
        builder: (BuildContext context, Widget child){
          return Theme(data: ThemeData(primaryColor: kPrimaryColor), child: child);
        }
    );
    if (_datePicker != null && _datePicker != _date){
      setState(() {
        _date = _datePicker;
        print(_date.toString());
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () {
        setState(() {
          _selectDate(context);
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Date",
        hintText: _date.toString().substring(0,10),
      ),
    );
  }
}


class EventTime extends StatefulWidget {
  @override
  _EventTimeState createState() => _EventTimeState();
}

class _EventTimeState extends State<EventTime> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: OutlineButton(
        onPressed: () { showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2021)); },
        child: Text("Time"),
      ),
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