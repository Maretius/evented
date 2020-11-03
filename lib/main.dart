import 'package:flutter/material.dart';
import 'constants.dart';
import 'contacts.dart';
import 'newEvent.dart';
import 'event.dart';
// import 'database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(home: Evented()));

class Evented extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                'assets/images/evented_logo_white_without_bg.png',
                fit: BoxFit.cover,
                height: 38.0,
              ),
            ],
          ),
          title: Text(
            "Evented",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              fontFamily: "Arial",
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search_rounded,
                size: 28.0,
              ),
              onPressed: () {
                // do something
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_add_alt_1_rounded,
                size: 28.0,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contacts()));
              },
            ),
          ],
          backgroundColor: kPrimaryColor,
        ),
        body: EventList(),
        backgroundColor: kPrimaryBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewEvent()));
          },
          child: Icon(
            Icons.add_rounded,
            size: 32.0,
          ),
          backgroundColor: kPrimaryColor,
        )
    );
  }
}

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<String> eventlistEventID = ['#1234567', '#7654321', '#192837465'];
  Map<String, String> eventlistIcon = {
    '#1234567': '🦆',
    '#7654321': '🐣',
    '#192837465': '🏒'
  };
  Map<String, String> eventlistName = {
    '#1234567': '1. Veranstaltung',
    '#7654321': '2. Veranstaltung',
    '#192837465': '3. Veranstaltung'
  };
  Map<String, String> eventlistDetails = {
    '#1234567': 'Eventdetails 1.',
    '#7654321': 'Eventdetails 2.',
    '#192837465': 'Eventdetails 3.'
  };
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: eventlistEventID.length,
      itemBuilder: (context, i) {
        String key = eventlistEventID.elementAt(i);
        return SingleEvent(
          eventlistIcon[key],
          eventlistName[key],
          eventlistDetails[key],
        );
      },
    );
  }
}

class SingleEvent extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  const SingleEvent(this.eventIcon, this.eventTitle, this.eventDetails);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.0),
        leading: Text(
          eventIcon,
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.w600, color: kTextColor),
        ),
        title: Text(
          eventTitle,
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.w600, color: kTextColor),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Event(eventIcon, eventTitle, eventDetails)));
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
    );
  }
}
