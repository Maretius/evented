import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'constants.dart';
import 'main.dart';

class Contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          "Contacts",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          MyName(),
          MyID(),
          FriendID(),
          FriendList(),
        ],
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class MyName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: "Jeremy",
        enabled: false,
        decoration: InputDecoration(
          labelText: "My Name:",
          labelStyle: TextStyle(
            color: kTextColor,
            fontSize: 20.0,
          ),
          filled: true,
          fillColor: kSecondaryColor,
        ),
        style: TextStyle(
          color: kTextColor,
          fontSize: 22.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
    );
  }
}

class MyID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: "#70425",
        enabled: false,
        decoration: InputDecoration(
          labelText: "My ID:",
          labelStyle: TextStyle(
            color: kTextColor,
            fontSize: 20.0,
          ),
          filled: true,
          fillColor: kSecondaryColor,
        ),
        style: TextStyle(
          color: kTextColor,
          fontSize: 22.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
    );
  }
}

class FriendID extends StatefulWidget {
  @override
  _FriendIDState createState() => _FriendIDState();
}

class _FriendIDState extends State<FriendID> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
