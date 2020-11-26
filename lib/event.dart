import 'package:evented/constants.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'database.dart';
import 'main.dart';
// import 'main.dart';
// import 'newEvent.dart';

class Event extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final String localUserID;
  final String eventUserStatus;
  final bool localUserIsAdmin;
  final Map userFriends;
  final Map eventUsers;
  final Map eventStatus;
  final Map eventTasksUser;
  final String eventID;

  const Event(this.eventIcon, this.eventTitle, this.eventDetails, this.eventDateTime, this.localUserID, this.eventUserStatus, this.localUserIsAdmin, this.userFriends, this.eventUsers, this.eventStatus, this.eventTasksUser, this.eventID);

  @override
  Widget build(BuildContext context) {
    List<String> eventTasks = [];
    eventTasksUser.forEach((key, value) {
      eventTasks.add(key);
    });

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
      body: InvitedFriendsList(eventTasksUser, eventUsers, eventStatus, localUserID, localUserIsAdmin),
      floatingActionButton: new Visibility(
        visible: localUserIsAdmin,
        child: FloatingActionButton(
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
                ButtonContainer(eventID, Icons.event_note_rounded, "Change Details", eventDetails, null),
                ButtonContainer(eventID, Icons.person_add_alt_1_rounded, "Invite Friends", userFriends, eventUsers),
                ButtonContainer(eventID, Icons.menu_open_rounded, "Edit Tasks", eventTasks, null),
                ButtonContainer(eventID, Icons.date_range_rounded, "Edit DateTime", eventDateTime, null),
                ButtonContainer(eventID, Icons.delete_forever_rounded, "Delete Event", eventUsers, null),
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
      ),
      backgroundColor: kPrimaryBackgroundColor,
    );
  }
}

class ButtonContainer extends StatelessWidget {
  ButtonContainer(this.eventID, this.buttonIcon, this.buttonText, this.eventVar, this.eventVar2);
  final String eventID;
  final IconData buttonIcon;
  final String buttonText;
  var eventVar;
  var eventVar2;

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
              if (buttonText == "Change Details") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => Wrap(
                    children: [
                      EventDetails(eventID, eventVar),
                    ],
                  ),
                );
              } else if (buttonText == "Invite Friends") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new Center(
                    child: EventFriends(eventID, eventVar, eventVar2),
                  ),
                );
              } else if (buttonText == "Edit Tasks") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => new Center(
                    child: EventTasks(eventVar),
                  ),
                );
              } else if (buttonText == "Edit DateTime") {
                showModalBottomSheet(
                  backgroundColor: kPrimaryColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                  ),
                  builder: (context) => Wrap(
                    children: [
                      EventDate(eventID, eventVar),
                    ],
                  ),
                );
              } else if (buttonText == "Delete Event") {
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
                             DatabaseService(null).deleteEvent(eventVar, eventID);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Evented()),
                            );
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
  final Map eventTasksUser;
  final Map eventUsers;
  final Map eventStatus;
  final String localUserID;
  final bool localUserIsAdmin;
  const InvitedFriendsList(this.eventTasksUser, this.eventUsers, this.eventStatus, this.localUserID, this.localUserIsAdmin);
  @override
  _InvitedFriendsListState createState() => _InvitedFriendsListState();
}

class _InvitedFriendsListState extends State<InvitedFriendsList> {
  void deleteInvitedFriend(String key) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.eventUsers.length,
      itemBuilder: (context, i) {
        String key = widget.eventUsers.keys.elementAt(i);
        return InvitedFriend(widget.localUserID, widget.localUserIsAdmin, widget.eventTasksUser, key, widget.eventUsers[key], widget.eventStatus[key], () {
          deleteInvitedFriend(key);
        });
      },
    );
  }
}

class InvitedFriend extends StatelessWidget {
  final String localUserID;
  final bool localUserIsAdmin;
  final Map eventTasksUser;
  final String userID;
  final String friendName;
  final String status;
  final Function deleteInvitedFriend;
  const InvitedFriend(this.localUserID, this.localUserIsAdmin, this.eventTasksUser, this.userID, this.friendName, this.status, this.deleteInvitedFriend);

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
            Icons.person_add_alt_1_rounded, // how_to_reg
            color: Colors.white,
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
                            InvitedFriendTasklist(localUserID, localUserIsAdmin, eventTasksUser, userID),
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
            Icons.person_outline_rounded,
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
            Icons.engineering_rounded,
            color: Colors.white,
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
                            InvitedFriendTasklist(localUserID, localUserIsAdmin, eventTasksUser, userID),
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
            Icons.person_remove_rounded,
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
  final String localUserID;
  final bool localUserIsAdmin;
  final Map eventTasksUser;
  final String userID;
  const InvitedFriendTasklist(this.localUserID, this.localUserIsAdmin, this.eventTasksUser, this.userID);

  @override
  _InvitedFriendTasklistState createState() => _InvitedFriendTasklistState();
}

class _InvitedFriendTasklistState extends State<InvitedFriendTasklist> {
  Map<String, bool> eventInvitedFriendsTasks = {};

  @override
  void initState() {
    super.initState();
    widget.eventTasksUser.forEach((key, value) {
      if(widget.localUserIsAdmin) {
        if (widget.eventTasksUser[key] == widget.userID) {
          eventInvitedFriendsTasks[key] = true;
        } else if (widget.eventTasksUser[key] == null) {
          eventInvitedFriendsTasks[key] = false;
        } else {}
      }else{
        if (widget.eventTasksUser[key] == widget.userID) {
          eventInvitedFriendsTasks[key] = true;
        } else if (widget.eventTasksUser[key] == null && widget.localUserID == widget.userID) {
          eventInvitedFriendsTasks[key] = false;
        } else {}
      }
    });
  }

  void toggleMember(String key) {
    setState(() {
      if(widget.localUserIsAdmin || widget.localUserID == widget.userID) {
        eventInvitedFriendsTasks.update(key, (bool done) => !done);
      }
    });
  }


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
            itemCount: eventInvitedFriendsTasks.length,
            itemBuilder: (context, i) {
              String key = eventInvitedFriendsTasks.keys.elementAt(i);
              return InvitedFriendTask(key, eventInvitedFriendsTasks[key], () {
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
      decoration: BoxDecoration( // TODO Farben überarbeiten
          color: done ? kSecondaryColor : kPrimaryBackgroundColor, border: Border.all(color: done ? Colors.white : Colors.white, width: 2.0), borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
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
          checkColor: Colors.white,
        ),
      ),
    );
  }
}

// TODO: Bereits eingestellte Details übergeben und vorher anzeigen
class EventDetails extends StatefulWidget {
  final String eventID;
  final String eventDetails;
  EventDetails(this.eventID, this.eventDetails);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  TextEditingController eventDetailsController;
  String eventDetails;
  @override
  void initState() {
    super.initState();
    eventDetailsController = TextEditingController(text: widget.eventDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: TextField(
            controller: eventDetailsController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 200,
            onChanged: (text){
              eventDetails = text;
            },
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
            onPressed: () {
              DatabaseService(null).changeEventDetails(widget.eventID, eventDetails);
            },
          ),
        )
      ],
    );
  }
}

class EventFriends extends StatefulWidget {
  final String eventID;
  final Map<String, String> userFriends;
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
                        // Map erstellen mit nur neuen Usern
                        userFriendsEventMember.forEach((key, value) {
                          // prüfe ob in neuer eventMap der alte user vorhanden ist
                          if ( widget.eventMembers[key] == null && value == true) {
                            newEventUser[key] = widget.userFriends[key];
                          }
                        });
                        print("NEUE USER: " + newEventUser.toString());

                        if (newEventUser.isEmpty == false) {
                          DatabaseService(null).changeEventUsers(widget.eventID, newEventUser);
                        }

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

class EventTasks extends StatefulWidget {
  final List<String> eventTasks;
  const EventTasks(this.eventTasks);
  @override
  _EventTasksState createState() => _EventTasksState();
}

class _EventTasksState extends State<EventTasks> {
  void addTask(String task) {
    setState(() {
      widget.eventTasks.add(task);
    });
    // Navigator.of(context).pop();
  }

  void deleteEventTask(int index) {
    setState(() {
      widget.eventTasks.removeAt(index);
    });
  }
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
              itemCount: widget.eventTasks.length,
              itemBuilder: (context, i) {
                return TaskItem(widget.eventTasks[i], () {
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
  final String eventID;
  final DateTime eventDateTime;
  const EventDate(this.eventID, this.eventDateTime);

  @override
  _EventDateState createState() => _EventDateState();
}

class _EventDateState extends State<EventDate> {
  DateTime eventDateTime;
  final datetimeFormat = DateFormat("dd.MM.yyyy - HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: DateTimeField(
            format: datetimeFormat,
            onChanged: (date) {
              eventDateTime = date;
            },
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(context: context, firstDate: DateTime.now(), initialDate: widget.eventDateTime, lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(widget.eventDateTime),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
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
            onPressed: () {
              print("DATE: " + DateFormat("dd.MM.yyyy - HH:mm").format(eventDateTime));
              DatabaseService(null).changeEventDateTime(widget.eventID, eventDateTime);
            },
          ),
        )
      ],
    ); // URL: https://pub.dev/packages/datetime_picker_formfield
  }
}