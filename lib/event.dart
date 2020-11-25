import 'package:evented/constants.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
// import 'main.dart';
// import 'newEvent.dart';

class Event extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final String eventUserStatus;
  final Map eventUserWithAnswer;
  final Map eventTasksUser;
  final String eventID;

  const Event(this.eventIcon, this.eventTitle, this.eventDetails, this.eventDateTime, this.eventUserStatus, this.eventUserWithAnswer, this.eventTasksUser, this.eventID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded)),
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
                          borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
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
                            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                DateFormat('dd.MM.yyyy').format(eventDateTime),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('kk:mm').format(eventDateTime) + " Uhr",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      body: InvitedFriendsList(eventUserWithAnswer),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
            ),
            builder: (context) => new GridView.count(
              shrinkWrap: true,
              childAspectRatio: 1.0,
              crossAxisCount: 3,
              children: <Widget>[
                ButtonContainer(Icons.event_note_rounded, "Change Details", "changeDetails", eventDetails),
                ButtonContainer(Icons.person_add_alt_1_rounded, "Invite Friends", "inviteFriends", eventDetails),
                ButtonContainer(Icons.menu_open_rounded, "Add Task", "addTask", eventDetails),
                ButtonContainer(Icons.date_range_rounded, "Change Date", "changeDate", eventDetails),
                ButtonContainer(Icons.access_time_rounded, "Change Time", "changeTime", eventDetails),
                ButtonContainer(Icons.delete_forever_rounded, "Delete Event", "deleteEvent", eventDetails),
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
  const ButtonContainer(this.buttonIcon, this.buttonText, this.buttonTheme, this.eventDetails);
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
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => Wrap(
                    children: [
                      EventDetails(),
                    ],
                  ),
                );
              }
              if (buttonTheme == "inviteFriends") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
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
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new Center(
                    child: EventTasks(),
                  ),
                );
              } else if (buttonTheme == "changeDate") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => Wrap(
                    children: [
                      EventDate(),
                    ],
                  ),
                );
              } else if (buttonTheme == "changeTime") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => Wrap(
                    children: [
                      EventTime(),
                    ],
                  ),
                );
              } else if (buttonTheme == "deleteEvent") {
                return showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext cxt) {
                    return AlertDialog(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
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
  Map eventUserWithAnswer;
  InvitedFriendsList(this.eventUserWithAnswer);
  @override
  _InvitedFriendsListState createState() => _InvitedFriendsListState(eventUserWithAnswer);
}

class _InvitedFriendsListState extends State<InvitedFriendsList> {
  Map eventUserWithAnswer;
  _InvitedFriendsListState(this.eventUserWithAnswer);

  void deleteInvitedFriend(String key) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: eventUserWithAnswer.length,
      itemBuilder: (context, i) {
        String key = eventUserWithAnswer.keys.elementAt(i);
        return InvitedFriend(key, eventUserWithAnswer[key], () {
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
    if (status == "promised") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(color: kSecondaryColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext cxt) {
                return SimpleDialog(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                    ),
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              friendName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            InvitedFriendTasklist(),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      ),
                    ]);
              },
            );
          },
        ),
      );
    } else if (status == "not decided") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(color: kFifthColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext cxt) {
                return SimpleDialog(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                    ),
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              friendName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      ),
                    ]);
              },
            );
          },
        ),
      );
    } else if (status == "Admin") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(color: kSecondaryColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
            Icons.person_rounded,
            size: 32.0,
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext cxt) {
                return SimpleDialog(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                    ),
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              friendName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      ),
                    ]);
              },
            );
          },
        ),
      );
    } else if (status == "called off") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(color: kFourthColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext cxt) {
                return SimpleDialog(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                    ),
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              friendName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      ),
                    ]);
              },
            );
          },
        ),
      );
    }
  }
}

class InvitedFriendTasklist extends StatefulWidget {
  @override
  _InvitedFriendTasklistState createState() => _InvitedFriendTasklistState();
}

class _InvitedFriendTasklistState extends State<InvitedFriendTasklist> {
  void toggleMember(String key) {
    setState(() {
      eventinvitedFriendsTasks.update(key, (bool done) => !done);
    });
  }

  Map<String, bool> eventinvitedFriendsTasks = {
    'Task 1': false,
    'Task 2': false,
    'Task 3': false,
    'Task 4': false,
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
          onPressed: () {},
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: eventinvitedFriendsTasks.length,
            itemBuilder: (context, i) {
              String key = eventinvitedFriendsTasks.keys.elementAt(i);
              return InvitedFriendTask(key, eventinvitedFriendsTasks[key], () {
                toggleMember(key);
              });
            },
          ),
        ),
      ],
    );
  }
}

class InvitedFriendTask extends StatelessWidget {
  final String friendName;
  final bool done;
  final Function toggle;
  const InvitedFriendTask(this.friendName, this.done, this.toggle);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: done ? kPrimaryColor : kPrimaryBackgroundColor, border: Border.all(color: done ? kPrimaryColor : Colors.white), borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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

// TODO: Bereits eingestellte Details übergeben und vorher anzeigen
class EventDetails extends StatefulWidget {
  String eventDetails;
  EventDetails();
  @override
  _EventDetailsState createState() => _EventDetailsState(this.eventDetails);
}

class _EventDetailsState extends State<EventDetails> {
  String eventDetails;
  _EventDetailsState(this.eventDetails);

  String userText3 = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventdetails"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.check_rounded,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        )
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
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
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
          color: done ? kPrimaryColor : kPrimaryBackgroundColor, border: Border.all(color: done ? kPrimaryColor : Colors.white), borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
              decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventtasks"),
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
      decoration: BoxDecoration(color: kSecondaryColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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

class EventDate extends StatefulWidget {
  @override
  _EventDateState createState() => _EventDateState();
}

class _EventDateState extends State<EventDate> {
  final dateFormat = DateFormat("dd.MM.yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: DateTimeField(
            format: dateFormat,
            onShowPicker: (context, currentValue) {
              return showDatePicker(context: context, firstDate: DateTime(1900), initialDate: currentValue ?? DateTime.now(), lastDate: DateTime(2100));
            },
            decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventdate"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.check_rounded,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        )
      ],
    ); // URL: https://pub.dev/packages/datetime_picker_formfield
  }
}

class EventTime extends StatefulWidget {
  @override
  _EventTimeState createState() => _EventTimeState();
}

class _EventTimeState extends State<EventTime> {
  final dateFormat = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
        child: DateTimeField(
          format: dateFormat,
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.convert(time);
          },
          decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventtime"),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
        child: IconButton(
          icon: Icon(
            Icons.check_rounded,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      )
    ]); // URL: https://pub.dev/packages/datetime_picker_formfield
  }
}
