import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';
import 'database.dart';
//import 'newEvent.dart';

class NewEventFriends extends StatelessWidget {
  final String userID;
  final String userName;
  final Map<String, String> userFriends;
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final List<String> eventTask;
  const NewEventFriends(this.userID, this.userName, this.userFriends, this.eventIcon, this.eventTitle, this.eventDetails, this.eventDateTime, this.eventTask);

  Map<String, bool> get eventFriends => null;

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
                // TODO hier soll er sich die Freundesliste aus EventFriends holen

                DatabaseService(userID).addEvent(userName, eventIcon, eventTitle, eventDetails, eventDateTime, eventTask, eventFriends);
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
        child: EventFriends(userFriends),
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class EventFriends extends StatefulWidget {
  final Map<String, String> userFriends;
  const EventFriends(this.userFriends);
  @override
  _EventFriendsState createState() => _EventFriendsState();
}

class _EventFriendsState extends State<EventFriends> {
  Map<String, bool> eventFriends = {};

  @override
  void initState() {
    super.initState();
    widget.userFriends.forEach((key, value) {
      eventFriends[value] = false;
    });
  }

  void toggleMember(String key) {
    setState(() {
      eventFriends.update(key, (bool done) => !done);
    });
  }

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
          color: friendMember ? kPrimaryColor : kPrimaryBackgroundColor, border: Border.all(color: kPrimaryColor, width: 2), borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
