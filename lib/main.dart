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

void main() => runApp(MaterialApp(home: Evented()));

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
    if (localUserID != null) {
      connectToFirebase();
    } else {
      autoLogIn();
    }
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
      await loginUser();
    }
    connectToFirebase();
    await database.checkIfUserExists();
  }

  void logoutUser() async {
    signOutWithGoogle();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', null);

    setState(() {
      localUserID = '';
      isLoggedIn = false;
    });
  }

  Future<Null> loginUser() async {
    String userID = await signInWithGoogle();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', userID);

    setState(() {
      localUserID = userID;
      isLoggedIn = true;
    });
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
          title: Text(
            "Evented",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              fontFamily: "Arial",
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search_rounded,
                size: 28.0,
              ),
              onPressed: () {
/*                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GoogleLogin()));*/
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_add_alt_1_rounded,
                size: 28.0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Contacts(localUserID, localUserID.substring(localUserID.length - 6), databaseUser.userName, databaseUser.userFriends)));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
                size: 28.0,
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
                          RaisedButton(
                            onPressed: () {
                              isLoggedIn ? logoutUser() : loginUser();
                            },
                            child: isLoggedIn ? Text('Logout') : Text('Login'),
                          )
                        ]);
                  },
                );
              },
            ),
          ],
          backgroundColor: kPrimaryColor,
        ),
        body: SizedBox(
          height: 800.0,
          child: FutureBuilder(
              // Wait until [connectToFirebase] returns stream
              future: connectToFirebase(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  print("Diese2: " + databaseUser.userEvents.toString());
                  return SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: databaseUser.userEvents.length,
                        itemBuilder: (context, i) {
                          String eventID = databaseUser.userEvents[i];
                          return StreamBuilder<DocumentSnapshot>(
                            stream: database.getEvents(eventID),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                              } else {
                                // resolve stream... Stream<DocumentSnapshot> -> DocumentSnapshot -> Map<String, bool>
                                Map<String, dynamic> items = snapshot.data.data();
                                var userDocument = snapshot.data;
                                //userDocument["eventName"]
                                return SizedBox(
                                  height: 85,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: 1,
                                      itemBuilder: (context, i) {
                                        Map<String, dynamic> eventStatus = userDocument["eventStatus"];
                                        Map<String, dynamic> eventUsers = userDocument["eventUsers"];

                                        List<String> eventInvitedUsers = [];
                                        eventUsers.forEach((key, value) {
                                          eventInvitedUsers.add(key);
                                        });

                                        Map<String, String> UserWithAnswer = {};
                                        String userkey = "";
                                        String username = "";
                                        String useranswer = "";
                                        String localUserStatus = "";
                                        bool localUserIsAdmin = false;

                                        for (var u = 0; u < eventUsers.length; u++) {
                                          userkey = eventInvitedUsers.elementAt(u);
                                          username = eventUsers[userkey];
                                          useranswer = eventStatus[userkey];
                                          if (userkey == localUserID) {
                                            localUserStatus = useranswer;
                                          }
                                          if (useranswer == "Admin" && userkey == localUserID) {
                                            localUserIsAdmin = true;
                                          }
                                          UserWithAnswer[username] = useranswer;
                                        }

                                        var datetime = userDocument["eventDateTime"].toDate();
                                        return SingleEvent(
                                          userDocument["eventIcon"],
                                          userDocument["eventName"],
                                          userDocument["eventDetails"],
                                          datetime,
                                          localUserStatus,
                                          UserWithAnswer,
                                        );
                                      }),
                                );

                                /* new ListView.builder(
  scrollDirection: Axis.vertical,
    itemCount: eventlistEventID.length,
    itemBuilder: (context, i) {
    String eventkey = eventlistEventID.elementAt(i);

    List<String> eventlistInvitedUsersToThis =
    eventlistInvitedUsers[eventkey];
    Map<String, String> UserWithAnswer = {};
    String userkey = "";
    String username = "";
    String useranswer = "";

    for (var u = 0; u < eventlistInvitedUsersToThis.length; u++) {
    userkey = eventlistInvitedUsersToThis.elementAt(u);
    username = eventlistUsers[userkey];
    useranswer = eventlistInvitedUsersWithAnswer[userkey];
    UserWithAnswer[username] = useranswer;
    }
    return SingleEvent(
    eventlistIcon[eventkey],
    eventlistName[eventkey],
    eventlistDetails[eventkey],
    eventlistDateTime[eventkey],
    eventlistUserStatus[eventkey],
    UserWithAnswer,
    );
    },
                          );*/
                              }
                            },
                          );
                        }),
                  );
                }
              }),
        ),
        backgroundColor: kPrimaryBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewEvent(localUserID, databaseUser.userName, databaseUser.userFriends)));
          },
          child: Icon(
            Icons.add_rounded,
            size: 32.0,
          ),
          backgroundColor: kPrimaryColor,
        ));
  }
}

class SingleEvent extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final String eventUserStatus;
  final Map eventUserWithAnswer;
  const SingleEvent(this.eventIcon, this.eventTitle, this.eventDetails, this.eventDateTime, this.eventUserStatus, this.eventUserWithAnswer);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.0),
        leading: Text(
          eventIcon,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: kTextColor),
        ),
        title: Text(
          eventTitle,
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: kTextColor),
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
                  title: Text(
                    eventTitle,
                    style: TextStyle(color: Colors.white),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          eventDetails,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          DateFormat('dd.MM.yyyy, kk:mm').format(eventDateTime) + " Uhr",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Do u want to accept the Invite?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Accept',
                        style: TextStyle(color: kTextColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Event(eventIcon, eventTitle, eventDetails, eventDateTime, eventUserStatus, eventUserWithAnswer)));
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Decline',
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
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Event(eventIcon, eventTitle, eventDetails, eventDateTime, eventUserStatus, eventUserWithAnswer)));
          }
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(color: eventUserStatus == "not decided" ? kThirdColor : kSecondaryColor, borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
    );
  }
}
