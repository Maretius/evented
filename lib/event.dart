import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evented/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'database.dart';
import 'main.dart';

class Event extends StatefulWidget {
  final DatabaseService database;
  final String eventID;
  final String userID;
  final Map<String, String> userFriends;
  const Event(this.database, this.eventID, this.userID, this.userFriends);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: widget.database.getEventInfos(widget.eventID),
    //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       } else {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.database.getEvent(widget.eventID),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          var eventSnapshot = snapshot.data;
          String eventTitle = eventSnapshot["eventName"];
          String eventDetails = eventSnapshot["eventDetails"];
          String eventIcon = eventSnapshot["eventIcon"];
          var eventDateTime = eventSnapshot["eventDateTime"].toDate();
          Map<String, dynamic> eventTasksUser = eventSnapshot["eventTasksUser"];
          Map<String, dynamic> eventUsers = eventSnapshot["eventUsers"];
          Map<String, dynamic> eventStatus = eventSnapshot["eventStatus"];
          bool userIsAdmin = false;
          if (eventStatus[widget.userID] == "Admin") {
            userIsAdmin = true;
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded)),
              centerTitle: true,
              title: Text(eventTitle, style: TextStyle(fontSize: 24.0)),
              backgroundColor: kPrimaryColor,
              actions: <Widget>[
                IconButton(
                    icon: Text(eventIcon, style: TextStyle(fontSize: 26.0)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                              ),
                              title: Text(
                                "Eventdetails",
                                style: TextStyle(color: Colors.white, fontSize: 22.0),
                              ),
                              children: [
                                Text(
                                  eventDetails,
                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            );
                          });
                    })
              ],
              bottom: PreferredSize(
                preferredSize: Size(0.0, 22.0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        DateFormat('dd.MM.yyyy').format(eventDateTime),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        DateFormat('kk:mm').format(eventDateTime) + " Uhr",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: eventUsers.length,
                itemBuilder: (context, i) {
                  String eventUserID = eventUsers.keys.elementAt(i);
                  String eventUserName = eventUsers.values.elementAt(i);
                  String eventUserStatus = eventStatus[eventUserID];
                  return EventUsers(widget.eventID, widget.userID, userIsAdmin, eventUserID, eventUserName, eventUserStatus, eventTasksUser);
                }),
            floatingActionButton: Visibility(
              visible: userIsAdmin,
              child: FloatingActionButton(
                child: Icon(Icons.settings_rounded, size: 32.0),
                backgroundColor: kPrimaryColor,
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                      ),
                      context: context,
                      builder: (context) => GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            children: <Widget>[
                              ButtonContainer(widget.eventID, Icons.event_note_rounded, "Details", eventDetails, null),
                              ButtonContainer(widget.eventID, Icons.person_add_alt_1_rounded,"Friends", widget.userFriends, eventUsers),
                              ButtonContainer(widget.eventID, Icons.menu_open_rounded,"Tasks",  eventTasksUser, null),
                              ButtonContainer(widget.eventID, Icons.date_range_rounded, "Date & Time", eventDateTime, null),
                              ButtonContainer(widget.eventID, Icons.delete_forever_rounded, "Delete Event", null, null),
                            ],
                          ));
                },
              ),
            ),
            backgroundColor: kPrimaryBackgroundColor,
          );
        }
      },
    );
    //}
    //});
  }
}

class EventUsers extends StatefulWidget {
  final String eventID;
  final String userID;
  final bool userIsAdmin;
  final String eventUserID;
  final String eventUserName;
  final String eventUserStatus;
  final Map eventTasksUser;
  const EventUsers(this.eventID, this.userID, this.userIsAdmin, this.eventUserID, this.eventUserName, this.eventUserStatus, this.eventTasksUser);

  @override
  _EventUsersState createState() => _EventUsersState();
}

class _EventUsersState extends State<EventUsers> {
  @override
  Widget build(BuildContext context) {
    Map<String, bool> eventTasks = {};
    IconData userIcon;
    Color userColor;
    bool edit = false;

    widget.eventTasksUser.forEach((key, value) {
      if (widget.eventUserStatus == "Admin" || widget.eventUserStatus == "promised") {
        if (widget.userIsAdmin) {
          if (widget.eventTasksUser[key] == widget.eventUserID) {
            eventTasks[key] = true;
          } else if (widget.eventTasksUser[key] == null) {
            eventTasks[key] = false;
          }
        } else {
          if (widget.eventTasksUser[key] == widget.eventUserID) {
            eventTasks[key] = true;
          } else if (widget.eventTasksUser[key] == null && widget.eventUserID == widget.userID) {
            eventTasks[key] = false;
          }
        }
      }
    });

    if (widget.eventUserStatus == "Admin") {
      userIcon = Icons.engineering_rounded;
      userColor = kPrimaryColor;
    } else if (widget.eventUserStatus == "promised") {
      userIcon = Icons.person_add_alt_1_rounded;
      userColor = kSecondaryColor;
    } else if (widget.eventUserStatus == "not decided") {
      userIcon = Icons.person_outline_rounded;
      userColor = kThirdColor;
    } else {
      userIcon = Icons.person_remove_rounded;
      userColor = kFourthColor;
    }
    if (widget.eventUserStatus == "Admin" || widget.eventUserStatus == "promised") {
      edit = true;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(color: userColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
          title: Text(widget.eventUserName, style: TextStyle(fontSize: 22, color: Colors.white)),
          trailing: Icon(userIcon, color: Colors.white, size: 28),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    backgroundColor: userColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                    ),
                    children: [
                      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(widget.eventUserName, style: TextStyle(color: Colors.white, fontSize: 25.0)),
                        Text(widget.eventUserStatus, style: TextStyle(color: Colors.white, fontSize: 16.0)),
                        Visibility(visible: edit, child: EventUserTasks(widget.eventID, widget.userID, widget.userIsAdmin, widget.eventUserID, widget.eventUserName, widget.eventUserStatus, eventTasks))
                      ])
                    ],
                  );
                });
          }),
    );
  }
}

class EventUserTasks extends StatefulWidget {
  final String eventID;
  final String userID;
  final bool userIsAdmin;
  final String eventUserID;
  final String eventUserName;
  final String eventUserStatus;
  final Map<String, bool> eventTasks;
  const EventUserTasks(this.eventID, this.userID, this.userIsAdmin, this.eventUserID, this.eventUserName, this.eventUserStatus, this.eventTasks);

  @override
  _EventUserTasksState createState() => _EventUserTasksState();
}

class _EventUserTasksState extends State<EventUserTasks> {
  Map<String, String> newEventTasks = {};

  void toggleMember(String key) {
    setState(() {
      if (widget.eventUserID == widget.userID || widget.userIsAdmin) {
        widget.eventTasks.update(key, (bool done) => !done);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.eventTasks.length,
          itemBuilder: (context, i) {
            String taskName = widget.eventTasks.keys.elementAt(i);
            return InvitedFriendTask(taskName, widget.eventTasks[taskName], () {
              toggleMember(taskName);
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.check_rounded,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () {
            if (widget.eventTasks.length != 0) {
              widget.eventTasks.forEach((key, value) {
                if (value) {
                  newEventTasks[key] = widget.eventUserID;
                } else {
                  newEventTasks[key] = null;
                }
              });
              DatabaseService(null).changeEventTask(widget.eventID, newEventTasks);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class InvitedFriendTask extends StatelessWidget {
  final String taskName;
  final bool done;
  final Function toggle;
  const InvitedFriendTask(this.taskName, this.done, this.toggle);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration:
          BoxDecoration(color: done ? kSecondaryColor : kPrimaryBackgroundColor, border: Border.all(color: done ? Colors.white : Colors.white, width: 2.0), borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
        title: Text(
          taskName,
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
          checkColor: Colors.white,
        ),
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  final String eventID;
  final IconData eventSettingsIcon;
  final String eventSettingsName;
  var eventSettingsDefault;
  var eventSettingsDefault2;
  ButtonContainer(this.eventID, this.eventSettingsIcon, this.eventSettingsName, this.eventSettingsDefault, this.eventSettingsDefault2);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(eventSettingsIcon, color: Colors.white, size: 30.0),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                      ),
                      title: Text(eventSettingsName, style: TextStyle(color: Colors.white)),
                      content: ButtonContainerSettings(eventID, eventSettingsName, eventSettingsDefault, eventSettingsDefault2),
                    );
                  });
            },
          ),
          Text(eventSettingsName, style: TextStyle(color: Colors.white, fontSize: 16))
        ],
      ),
    );
  }
}

class ButtonContainerSettings extends StatefulWidget {
  final String eventID;
  final String eventSettingsName;
  var eventSettingsDefault;
  var eventSettingsDefault2;
  ButtonContainerSettings(this.eventID, this.eventSettingsName, this.eventSettingsDefault, this.eventSettingsDefault2);

  @override
  _ButtonContainerSettingsState createState() => _ButtonContainerSettingsState();
}

class _ButtonContainerSettingsState extends State<ButtonContainerSettings> {
  var databaseValue;

  @override
  Widget build(BuildContext context) {
    if (widget.eventSettingsName == "Details") {
      TextEditingController eventDetailsTextController;
      eventDetailsTextController = TextEditingController(text: widget.eventSettingsDefault);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: eventDetailsTextController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 200,
            onChanged: (text) {
              databaseValue = text;
            },
            decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventdetails"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('Change', style: TextStyle(color: kTextColor),),
                onPressed: () {
                  DatabaseService(null).changeEventDetails(widget.eventID, databaseValue);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kTextColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      );

    } else if (widget.eventSettingsName == "Friends") {
      // TODO ganz viel Spaß haben!!! Yipppiieeeeee
      List<String> eventTasks = [];
      Map<String, dynamic> eventTasksMap = widget.eventSettingsDefault;
      eventTasksMap.forEach((key, value) {
        eventTasks.add(key);
      });
      return EventFriends(widget.eventID, widget.eventSettingsDefault, widget.eventSettingsDefault2);
    }  else if (widget.eventSettingsName == "Tasks") {
      List<String> eventTasks = [];
      Map<String, dynamic> eventTasksMap = widget.eventSettingsDefault;
      eventTasksMap.forEach((key, value) {
        eventTasks.add(key);
      });
      return EventTasksList(widget.eventID, eventTasks);
    } else if (widget.eventSettingsName == "Date & Time") {
      DateTime eventDateTime;
      final datetimeFormat = DateFormat("dd.MM.yyyy - HH:mm");
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DateTimeField(
            format: datetimeFormat,
            onChanged: (date) {
              eventDateTime = date;
            },
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(context: context, firstDate: DateTime.now(), initialDate: widget.eventSettingsDefault, lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(widget.eventSettingsDefault),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
            decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventdate"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('Change', style: TextStyle(color: kTextColor),),
                onPressed: () {
                  DatabaseService(null).changeEventDateTime(widget.eventID, eventDateTime);
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kTextColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      );
    } else if (widget.eventSettingsName == "Delete Event"){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure u want to delete the event?\nDeleted Events cant be restored!',
            style: TextStyle(color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('Delete', style: TextStyle(color: kTextColor),),
                onPressed: () {
                  DatabaseService(null).deleteEvent(widget.eventID);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Evented()),
                  );
                },
              ),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kTextColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      );
    }
  }
}


class EventFriends extends StatefulWidget {
  final String eventID;
  final Map<String, dynamic> userFriends;
  final Map<String, dynamic> eventMembers;
  const EventFriends(this.eventID, this.userFriends, this.eventMembers);

  @override
  _EventFriendsState createState() => _EventFriendsState();
}

class _EventFriendsState extends State<EventFriends> {
  Map<String, bool> userFriendsEventMember= {};
  Map<String, String> newEventUser = {};
  bool eventOriginalUser;

  @override
  void initState() {
    super.initState();
    widget.userFriends.forEach((key, value) {
      if (widget.eventMembers[key] != null) {
        userFriendsEventMember[key] = true;
      }else {
        userFriendsEventMember[key] = false;
      }
    });
    print("LISTE: " + userFriendsEventMember.toString());
  }

  void toggleMember(String key) {
    setState(() {
      userFriendsEventMember.update(key, (bool done) => !done);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: userFriendsEventMember.length,
            itemBuilder: (context, i) {
              String key = userFriendsEventMember.keys.elementAt(i);
              String eventFriendUserName = widget.userFriends[key];
              if (widget.eventMembers[key] != null){
                eventOriginalUser = true;
              } else {
                eventOriginalUser = false;
              }
              return EventFriend(eventFriendUserName, eventOriginalUser, userFriendsEventMember[key], () {toggleMember(key);});
            },
          ),
        ),
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
                          'Are you sure u want to invite this friends?',
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
                        // Map erstellen mit nur neuen Usern
                        userFriendsEventMember.forEach((key, value) {
                          // prüfe ob in neuer eventMap der alte user vorhanden ist
                          if ( widget.eventMembers[key] == null && value == true) {
                            newEventUser[key] = widget.userFriends[key];
                          }
                        });

                        if (newEventUser.isEmpty == false) {
                          DatabaseService(null).changeEventUsers(widget.eventID, newEventUser);
                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
      ],
    );
  }
}

class EventFriend extends StatelessWidget {
  final String friendName;
  final bool done;
  final bool eventOriginalUser;
  final Function toggle;
  const EventFriend(this.friendName,this.eventOriginalUser, this.done, this.toggle);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: done ? kPrimaryColor : kSecondaryColor, border: Border.all(color: done ? Colors.white : Colors.white), borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
            if (eventOriginalUser == false) {
              toggle();
            }
          },
          activeColor: kPrimaryBackgroundColor,
          checkColor: kPrimaryColor,
        ),
      ),
    );
  }
}








class EventTasksList extends StatefulWidget {
  final String eventID;
  List<String> eventTasks;
  EventTasksList(this.eventID, this.eventTasks);

  @override
  _EventTasksListState createState() => _EventTasksListState();
}

class _EventTasksListState extends State<EventTasksList> {
  final TextEditingController _controller = TextEditingController();
  void addTask(String task) {
    setState(() {
      widget.eventTasks.add(task);
    });
  }

  void deleteEventTask(int index, String task) {
    setState(() {
      widget.eventTasks.removeAt(index);
    });
    DatabaseService(null).removeEventTask(widget.eventID, task);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) {
              if (value != ""){
                addTask(value);
                DatabaseService(null).addEventTask(widget.eventID, value);
                _controller.clear();
              }
            },
            decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: "Eventtasks"),
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        ),
        SizedBox(
          height: 260,
          child: ListView.builder(
            reverse: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.eventTasks.length,
            itemBuilder: (context, i) {
              return TaskItem(widget.eventTasks[i], () {
                deleteEventTask(i, widget.eventTasks[i]);
              });
            },
          ),
        ),
      ],
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

      margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(color: kSecondaryColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
      child: ListTile(
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