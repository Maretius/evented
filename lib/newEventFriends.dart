import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';
//import 'newEvent.dart';

class NewEventFriends extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final List<String> eventTask;
  const NewEventFriends(this.eventIcon, this.eventTitle, this.eventDetails, this.eventDateTime, this.eventTask);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_rounded),
        ),
        title: Text(
          eventTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Evented()),
                );
              },
              icon: Icon(Icons.check_rounded)),
        ],
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: EventFriends(),
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class EventFriends extends StatefulWidget {
  @override
  _EventFriendsState createState() => _EventFriendsState();
}

class _EventFriendsState extends State<EventFriends> {
  void toggleMember(String key) {
    setState(() {
      eventFriends.update(key, (bool done) => !done);
    });
  }

  Map<String, bool> eventFriends = {
    'Jeremy': false,
    'Hans Jürgen': false,
    'Gertrude': false,
    'Peter Silie': false,
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: eventFriends.length,
      itemBuilder: (context, i) {
        String key = eventFriends.keys.elementAt(i);
        return EventFriend(key, eventFriends[key], () {
          toggleMember(key);
        });
      },
    );
  }
}

class EventFriend extends StatelessWidget {
  final String friendName;
  final bool friendMember;
  final Function friendToggle;
  const EventFriend(this.friendName, this.friendMember, this.friendToggle);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      margin: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: friendMember ? kPrimaryColor : kPrimaryBackgroundColor,
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
        title: Text(
          friendName,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        trailing: Checkbox(
          value: friendMember,
          onChanged: (bool value) {
            friendToggle();
          },
          activeColor: kPrimaryBackgroundColor,
          checkColor: kPrimaryColor,
        ),
      ),
    );
  }
}
