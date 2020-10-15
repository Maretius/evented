import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class Event extends StatelessWidget {
  final String eventIcon;
  final String evenTitle;
  const Event(this.eventIcon, this.evenTitle);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          evenTitle,
          style: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Text(
            eventIcon,
          style: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.w600,
          ),),
        ],
      ),
    );
  }
}

