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
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SingleEvent("🦆", "1. Veranstaltung", "Eventdetails 1."),
            SingleEvent("🐣", "2. Veranstaltung", "Eventdetails 2."),
            SingleEvent("🏒", "3. Veranstaltung", "Eventdetails 3."),
          ],
        ),
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
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Event(eventIcon, eventTitle, eventDetails)));
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
