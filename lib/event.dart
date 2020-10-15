import 'package:evented/constants.dart';
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
        centerTitle: true,
        title: Text(
          evenTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                eventIcon,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}

class EventUserTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
