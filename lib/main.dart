import 'package:flutter/material.dart';
import 'constants.dart';
import 'contacts.dart';
import 'newEvent.dart';
import 'event.dart';
import 'package:intl/intl.dart';

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
        ));
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
    '#192837465': 'Eventdetails 3.'
  };
  Map<String, DateTime> eventlistDateTime = {
    '#1234567': DateTime.now(),
    '#7654321': DateTime.now(),
    '#192837465': DateTime.now()
  };
  Map<String, String> eventlistUserStatus = {
    '#1234567': 'not decided',
    '#7654321': 'called off',
    '#192837465': 'promised'
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
          eventlistDateTime[key],
          eventlistUserStatus[key],
        );
      },
    );
  }
}

class SingleEvent extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final String eventUserStatus;
  const SingleEvent(this.eventIcon, this.eventTitle, this.eventDetails,
      this.eventDateTime, this.eventUserStatus);

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
          if (eventUserStatus == "not decided") {
            showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0),
                        bottom: Radius.circular(20.0)),
                  ),
                  title: Text(
                    eventTitle,
                    style: TextStyle(color: Colors.white),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          eventDetails,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          DateFormat('dd.MM.yyyy, kk:mm')
                              .format(eventDateTime) + " Uhr",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Do u want to accept the Invite?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Accept',
                        style: TextStyle(color: kTextColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Event(
                                    eventIcon,
                                    eventTitle,
                                    eventDetails,
                                    eventDateTime,
                                    eventUserStatus)));
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Decline',
                        style: TextStyle(color: kTextColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Event(eventIcon, eventTitle,
                        eventDetails, eventDateTime, eventUserStatus)));
          }
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color:
              eventUserStatus == "not decided" ? kThirdColor : kSecondaryColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
    );
  }
}
