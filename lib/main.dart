import 'package:flutter/material.dart';
import 'constants.dart';
import 'NewEvent.dart';

void main() => runApp(MaterialApp(home: ToDo()));

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Evented",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w600,
              fontFamily: "Arial",
            ),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SingleEvent("🦆", "Ehre!"),
            SingleEvent("🐣", "Tschüss"),
            SingleEvent("🐣", "Gutschi"),
            SingleEvent("🐣", "LOL"),
            SingleEvent("☀", "Hot"),
            SingleEvent("🐣", "Abfahrt")
          ],
        ),
        backgroundColor: kPrimaryBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewEvent()));
          },
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
        ));
  }
}

class SingleEvent extends StatelessWidget {
  final String eventIcon;
  final String evenTitle;
  const SingleEvent(this.eventIcon, this.evenTitle);
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
          evenTitle,
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.w600, color: kTextColor),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: new BorderRadius.all(const Radius.circular(5.0))
      ),
    );
  }
}
