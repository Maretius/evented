import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';
import 'database.dart';
//import 'newEvent.dart';

class NewEventFriends extends StatefulWidget {
  final String userID;
  final String userName;
  final Map<String, String> userFriends;
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final List<String> eventTask;
  const NewEventFriends(this.userID, this.userName, this.userFriends, this.eventIcon, this.eventTitle, this.eventDetails, this.eventDateTime, this.eventTask);

  @override
  _NewEventFriendsState createState() => _NewEventFriendsState();
}

class _NewEventFriendsState extends State<NewEventFriends> {
  Map<String, bool> eventFriends = {};

  @override
  void initState() {
    super.initState();
    widget.userFriends.forEach((key, value) {
      eventFriends[key] = false;
    });
  }

  void toggleMember(String key) {
    setState(() {
      eventFriends.update(key, (bool done) => !done);
    });
  }

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
          widget.eventTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
               await DatabaseService(widget.userID).addEvent(widget.userName, widget.eventIcon, widget.eventTitle, widget.eventDetails, widget.eventDateTime, widget.eventTask, widget.userFriends, eventFriends);
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
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: eventFriends.length,
          itemBuilder: (context, i) {
            String eventFriendID = eventFriends.keys.elementAt(i);
            String eventFriendUserName = widget.userFriends[eventFriendID];
            return EventFriend(eventFriendUserName, eventFriends[eventFriendID], () {toggleMember(eventFriendID);});
          },
        ),
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class EventFriend extends StatelessWidget {
  final String friendUserName;
  final bool friendMember;
  final Function friendToggle;
  const EventFriend(this.friendUserName, this.friendMember, this.friendToggle);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: friendMember ? kPrimaryColor : kPrimaryBackgroundColor,
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: ListTile(
        title: Text(
          friendUserName,
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
