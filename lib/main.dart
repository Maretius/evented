import 'dart:async';
import 'package:evented/event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'contacts.dart';
import 'newEvent.dart';
import 'event.dart';
import 'package:intl/intl.dart';
import 'database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // WidgetsFlutterBinding for deprecated API message
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: Evented()));
}

class Evented extends StatefulWidget {
  @override
  _EventedState createState() => _EventedState();
}

class _EventedState extends State<Evented> {
  User user;
  DatabaseService database;
  bool isLoggedIn = false;
  String localUserID;
  LocalUser databaseUser;

  Future<void> connectToFirebase() async {
    print(localUserID);
    database = DatabaseService(localUserID);
    databaseUser = await database.getUserData();
  }

  @override
  void initState() {
    super.initState();
    // if (localUserID != null) {
    //   connectToFirebase();
    //   print("TEST1");
    // } else {
      autoLogIn();
    // }
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userid');

    await Firebase.initializeApp();
    if (userID != null) {
      setState(() {
        isLoggedIn = true;
        localUserID = userID;
      });
    } else {
      String userID = await signInWithGoogle();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userid', userID);
      setState(() {
        isLoggedIn = true;
        localUserID = userID;
      });
      await DatabaseService(userID).checkIfUserExists();
      setState(() {
      });
    }
    connectToFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                'assets/images/evented_logo_white_without_bg.png',
                fit: BoxFit.cover,
                height: 38.0,
              ),
            ],
          ),
          title: Text("evented", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600, fontFamily: 'SourceSansPro')),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person_add_alt_1_rounded,
                size: 32.0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Contacts(localUserID, localUserID.substring(localUserID.length - 6), databaseUser.userName, databaseUser.userFriends)));
              },
            ),
          ],
          backgroundColor: kPrimaryColor,
          shadowColor: kPrimaryColor,
          elevation: 20.0,
        ),
        body: FutureBuilder(
            future: connectToFirebase(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                return Center(child: CircularProgressIndicator());
              } else {
                return StreamBuilder<DocumentSnapshot>(
                    stream: database.getUser(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: null);
                      } else {
                        var userDocument = snapshot.data;
                        List<dynamic> userEvents = userDocument["userEvents"];

                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: userEvents.length,
                          itemBuilder: (context, i) {
                            String eventID = userEvents[i];
                            return StreamBuilder<DocumentSnapshot>(
                              stream: database.getEvent(eventID),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: null);
                                } else {
                                  var userEventDocument = snapshot.data;
                                  Map<String, dynamic> eventStatus = userEventDocument["eventStatus"];
                                  Map<String, dynamic> eventUsers = userEventDocument["eventUsers"];
                                  String userkey = "";
                                  String useranswer = "";
                                  String localUserStatus = "";
                                  bool localUserIsAdmin = false;

                                  List<String> eventInvitedUsers = [];
                                  eventUsers.forEach((key, value) {
                                    eventInvitedUsers.add(key);
                                  });
                                  for (var u = 0; u < eventUsers.length; u++) {
                                    userkey = eventInvitedUsers.elementAt(u);
                                    useranswer = eventStatus[userkey];
                                    if (userkey == localUserID) {
                                      localUserStatus = useranswer;
                                    }
                                    if (useranswer == "Admin" && userkey == localUserID) {
                                      localUserIsAdmin = true;
                                    }
                                  }
                                  var datetime = userEventDocument["eventDateTime"].toDate();
                                  return SingleEvent(userEventDocument["eventIcon"], userEventDocument["eventName"], userEventDocument["eventDetails"], datetime, localUserID, localUserStatus, localUserIsAdmin, databaseUser.userFriends, eventUsers, eventStatus, userEventDocument["eventTasksUser"], eventID, database,
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    });
              }
            }),
        backgroundColor: kPrimaryBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewEvent(localUserID, databaseUser.userName, databaseUser.userFriends)));
          },
          child: Icon(Icons.add_rounded, size: 32.0),
          backgroundColor: kPrimaryColor,
        ));
  }
}

class SingleEvent extends StatelessWidget {
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
  final DatabaseService database;
  const SingleEvent(this.eventIcon, this.eventTitle, this.eventDetails, this.eventDateTime, this.localUserID, this.eventUserStatus, this.localUserIsAdmin, this.userFriends, this.eventUsers, this.eventStatus,
      this.eventTasksUser, this.eventID, this.database);

  @override
  Widget build(BuildContext context) {
    Color eventColor;
    if (eventUserStatus == "not decided") {
      eventColor = kThirdColor;
    } else if (eventUserStatus == "promised" || eventUserStatus == "Admin") {
      eventColor = kPrimaryColor;
    } else {
      eventColor = kFourthColor;
    }

    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.0),
        leading: Text(
          eventIcon,
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        title: Text(
          eventTitle,
          style: TextStyle(fontSize: 22.0, color: Colors.white, fontFamily: 'SourceSansPro'),
        ),
        onTap: () {
          if (eventUserStatus == "not decided") {
            showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                  ),
                  title: Text(eventTitle, style: TextStyle(color: Colors.white, fontFamily: 'SourceSansPro'),
                  ),
                  content: Text("Details: " + eventDetails + "\n\nAt: " + DateFormat('dd.MM.yyyy, kk:mm').format(eventDateTime) + "\n\nDo u want to accept the Invite?",
                          style: TextStyle(color: Colors.white, fontFamily: 'SourceSansPro'),
                        ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Accept', style: TextStyle(color: kTextColor, fontFamily: 'SourceSansPro')),
                      onPressed: () {
                        database.changeEventUserStatus(eventID, "promised");
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Decline', style: TextStyle(color: kTextColor, fontFamily: 'SourceSansPro')),
                      onPressed: () {
                        database.changeEventUserStatus(eventID, "called off");
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Event(database, eventID, localUserID, userFriends)));
            // eventUsers, eventStatus,
          // eventTasksUser,
            // eventID)));
          }
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: eventColor, borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [BoxShadow(color: eventColor.withOpacity(0.6), spreadRadius: 0, blurRadius: 0.0, offset: Offset(3, 3))]
      ),
    );
  }
}
