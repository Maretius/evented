import 'package:evented/constants.dart';
import 'package:flutter/material.dart';
// import 'main.dart';
// import 'newEvent.dart';

class Event extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  const Event(this.eventIcon, this.eventTitle, this.eventDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded)),
        centerTitle: true,
        title: Text(
          eventTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            alignment: Alignment.center,
            child: IconButton(
              icon: Text(
                eventIcon,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext cxt) {
                    return SimpleDialog(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.vertical(
                              top: Radius.circular(20.0),
                              bottom: Radius.circular(20.0)),
                        ),
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  eventDetails,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          ),
                        ]);
                  },
                );
              },
            ),
          ),
        ],
        backgroundColor: kPrimaryColor,
        bottom: PreferredSize(
          preferredSize: Size(0.0, 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "01.01.2020",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                "13:30 Uhr",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      body: InvitedFriendsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.vertical(
                  top: Radius.circular(20.0), bottom: Radius.zero),
            ),
            builder: (context) => new GridView.count(
              shrinkWrap: true,
              childAspectRatio: 1.0,
              crossAxisCount: 3,
              children: <Widget>[
                ButtonContainer(Icons.event_note_rounded, "Change Details",
                    "changeDetails", eventDetails),
                ButtonContainer(Icons.person_add_alt_1_rounded,
                    "Invite Friends", "inviteFriends", eventDetails),
                ButtonContainer(Icons.menu_open_rounded, "Add Task", "addTask",
                    eventDetails),
                ButtonContainer(Icons.date_range_rounded, "Change Date",
                    "changeDate", eventDetails),
                ButtonContainer(Icons.access_time_rounded, "Change Time",
                    "changeTime", eventDetails),
                ButtonContainer(Icons.delete_forever_rounded, "Delete Event",
                    "deleteEvent", eventDetails),
              ],
            ),
          );
        },
        child: Icon(
          Icons.settings_rounded,
          size: 32.0,
        ),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer(
      this.buttonIcon, this.buttonText, this.buttonTheme, this.eventDetails);
  final IconData buttonIcon;
  final String buttonText;
  final String buttonTheme;
  final String eventDetails;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              buttonIcon,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {
              if (buttonTheme == "changeDetails") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: EventDetails(),
                  ),
                );
              }
              if (buttonTheme == "inviteFriends") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new Center(
                    child: EventFriends(),
                  ),
                );
              }
              if (buttonTheme == "addTask") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new Center(
                    child: EventTasks(),
                  ),
                );
              } else if (buttonTheme == "changeDate") {
              } else if (buttonTheme == "changeTime") {
              } else if (buttonTheme == "deleteEvent") {
                return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext cxt) {
                    return AlertDialog(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.vertical(
                            top: Radius.circular(20.0),
                            bottom: Radius.circular(20.0)),
                      ),
                      title: Text(
                        'Delete Event?',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              'Are you sure u want to delete the event?',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Deleted Events cant be restored!',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Delete',
                            style: TextStyle(color: kTextColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Cancel',
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
              }
            },
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class InvitedFriendsList extends StatefulWidget {
  @override
  _InvitedFriendsListState createState() => _InvitedFriendsListState();
}

class _InvitedFriendsListState extends State<InvitedFriendsList> {
  Map<String, String> invitedFriends = {
    'Jeremy': 'promised',
    'Hans Jürgen': 'not decided',
    'Gertrude': 'promised',
    'Petfewie': 'called off',
    'Peter Silie': 'promised',
    'Petsdfsdf Silie': 'promised',
    'Peteg': 'promised',
    'eegregerg Silie': 'promised',
  };

  void deleteInvitedFriend(String key) {
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: invitedFriends.length,
      itemBuilder: (context, i) {
        String key = invitedFriends.keys.elementAt(i);
        return InvitedFriend(key, invitedFriends[key], () {
          deleteInvitedFriend(key);
        });
      },
        );
  }
}

class InvitedFriend extends StatelessWidget {
  final String friendName;
  final String status;
  final Function deleteInvitedFriend;
  const InvitedFriend(this.friendName, this.status, this.deleteInvitedFriend);

  @override
  Widget build(BuildContext context) {
    if (status == "promised") {    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: kSecondaryColor,
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
        trailing: Icon(
          Icons.check_rounded,
          size: 32.0,
        ),
      ),
    );
    } else if (status == "not decided") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: kFifthColor,
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
          trailing: Icon(
            Icons.ac_unit_rounded,
            size: 32.0,
          ),
        ),
      );
    } else if (status == "called off") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: kFourthColor,
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
          trailing: Icon(
            Icons.remove,
            size: 32.0,
          ),
        ),
      );
    }
  }
}

// TODO: Bereist eingestellte Details übergeben und vorher anzeigen
class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  _EventDetailsState();
  void updateEventDetails(String text3) {
    setState(() {
      userText3 = text3;
    });
  }

  String userText3 = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: TextField(
            onChanged: updateEventDetails,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Eventdetails"),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.check_rounded,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
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
    'Petfewie': false,
    'Peter Silie': false,
    'Petsdfsdf Silie': false,
    'Peteg': false,
    'eegregerg Silie': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.check_rounded,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0),
                        bottom: Radius.circular(20.0)),
                  ),
                  title: Text(
                    'Invite Friends?',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'Are you sure u want to invite this friends??',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(color: kTextColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'No',
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
          },
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: eventFriends.length,
            itemBuilder: (context, i) {
              String key = eventFriends.keys.elementAt(i);
              return EventFriend(key, eventFriends[key], () {
                toggleMember(key);
              });
            },
          ),
        ),
      ],
    );
  }
}

class EventFriend extends StatelessWidget {
  final String friendName;
  final bool done;
  final Function toggle;
  const EventFriend(this.friendName, this.done, this.toggle);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: done ? kPrimaryColor : kPrimaryBackgroundColor,
          border: Border.all(color: done ? kPrimaryColor : Colors.white),
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
          value: done,
          onChanged: (bool value) {
            toggle();
          },
          activeColor: kPrimaryBackgroundColor,
          checkColor: kPrimaryColor,
        ),
      ),
    );
  }
}

class EventTasks extends StatefulWidget {
  @override
  _EventTasksState createState() => _EventTasksState();
}

class _EventTasksState extends State<EventTasks> {
  void addTask(String task) {
    setState(() {
      eventTask.add(task);
    });
    // Navigator.of(context).pop();
  }

  void deleteEventTask(int index) {
    setState(() {
      eventTask.removeAt(index);
    });
  }

  List<String> eventTask = [
    "Task1",
    "Task2",
    "Task2",
    "Task2",
    "Task2",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            child: TextField(
              onSubmitted: addTask,
              scrollPadding: EdgeInsets.only(bottom: 10.0),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: "Eventtasks"),
            ),
          ),
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: eventTask.length,
              itemBuilder: (context, i) {
                return TaskItem(eventTask[i], () {
                  deleteEventTask(i);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String taskname;
  final Function remove;
  const TaskItem(this.taskname, this.remove);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 2.0),
        title: Text(
          taskname,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever_rounded),
          color: Colors.white,
          iconSize: 28.0,
          onPressed: () {
            remove();
          },
        ),
      ),
    );
  }
}
