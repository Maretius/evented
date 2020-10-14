import 'package:flutter/material.dart';
import 'package:todo/constants.dart';

void main() => runApp(MaterialApp(home: ToDo()));

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evented",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          fontFamily: "Arial",
        ),),
        backgroundColor: kPrimaryColor,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[SingleEvent("🐣", "Abfahrt"),SingleEvent("🐣", "Tschüss"),SingleEvent("🐣", "Gutschi"),SingleEvent("🐣", "LOL"),SingleEvent("🐣", "Abfahrt"),SingleEvent("🐣", "Abfahrt")],
      ),
        backgroundColor: kBackgroundColorPrimary,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewEvent()));
        },
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      )
    );
  }
}

class SingleEvent extends StatelessWidget {
  final String eventIcon;
  final String evenTitle;
  const SingleEvent(this.eventIcon, this.evenTitle);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: 22
        ),
        child:
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 4.0),
          leading: Text(eventIcon,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: kTextColor
          ),),
          title: Text(evenTitle,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: kTextColor),
          ),
        ),
    );
  }
}

class NewEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Event'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
            },
        ),
      ),
    );
  }
}


