import 'package:evented/login.dart';
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
  String localUserID = '';

  void connectToFirebase() async {
    print(localUserID);
    database = DatabaseService(localUserID);
  }

  @override
  void initState() {
    super.initState();

    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userid');

    await Firebase.initializeApp();
    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        localUserID = userId;
      });
    } else {
      await loginUser();
    }
    connectToFirebase();
    database.checkIfUserExists();
  }

  void logout() async {
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

    return null;
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GoogleLogin()));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_add_alt_1_rounded,
                size: 28.0,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Contacts()));
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
                          borderRadius: BorderRadiusDirectional.vertical(
                              top: Radius.circular(20.0),
                              bottom: Radius.circular(20.0)),
                        ),
                        children: [
                          RaisedButton(
                            onPressed: () {
                              isLoggedIn ? logout() : loginUser();
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
        body: EventList(),
        backgroundColor: kPrimaryBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewEvent(userID: localUserID)));
          },
          child: Icon(
            Icons.add_rounded,
            size: 32.0,
          ),
          backgroundColor: kPrimaryColor,
        ));
  }
}

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<String> eventlistEventID = ['#1234567', '#7654321', '#192837465'];
  Map<String, String> eventlistIcon = {
    '#1234567': '🦆',
    '#7654321': '🐣',
    '#192837465': '🏒'
  };
  Map<String, String> eventlistName = {
    '#1234567': '1. Veranstaltung',
    '#7654321': '2. Veranstaltung',
    '#192837465': '3. Veranstaltung'
  };
  Map<String, String> eventlistDetails = {
    '#1234567': 'Eventdetails 1.',
    '#7654321': 'Eventdetails 2.',
    '#192837465': 'Eventdetails 3.'
  };
  Map<String, DateTime> eventlistDateTime = {
    '#1234567': DateTime.now(),
    '#7654321': DateTime.now(),
    '#192837465': DateTime.now()
  };
  Map<String, String> eventlistUserStatus = {
    '#1234567': 'not decided',
    '#7654321': 'promised',
    '#192837465': 'promised'
  };
  Map<String, List<String>> eventlistInvitedUsers = {
    '#1234567': ['#24552', '#2951', '#546893', '#324325'],
    '#7654321': ['#23505', '#28592', '#482593'],
    '#192837465': ['#439503', '#435344', '#258235']
  };
  Map<String, String> eventlistUsers = {
    '#24552': "Pascal",
    '#2951': "Jimmy",
    '#546893': "Annegred",
    '#324325': "Fred",
    '#23505': "Gunther",
    '#28592': "Hans",
    '#482593': "Jürgen",
    '#439503': "Pomm",
    '#435344': "Fritz",
    '#258235': "Dieter"
  };
  Map<String, String> eventlistInvitedUsersWithAnswer = {
    "#24552": 'not decided',
    "#2951": 'promised',
    "#546893": 'promised',
    "#324325": 'called off',
    "#23505": 'not decided',
    "#28592": 'called off',
    "#482593": 'not decided',
    "#439503": 'promised',
    "#435344": 'promised',
    "#258235": 'called off'
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: eventlistEventID.length,
      itemBuilder: (context, i) {
        String eventkey = eventlistEventID.elementAt(i);

        List<String> eventlistInvitedUsersToThis = eventlistInvitedUsers[eventkey];
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
    );
  }
}

class SingleEvent extends StatelessWidget {
  final String eventIcon;
  final String eventTitle;
  final String eventDetails;
  final DateTime eventDateTime;
  final String eventUserStatus;
  final Map eventUserWithAnswer;
  const SingleEvent(this.eventIcon, this.eventTitle, this.eventDetails,
      this.eventDateTime, this.eventUserStatus, this.eventUserWithAnswer);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.0),
        leading: Text(
          eventIcon,
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.w600, color: kTextColor),
        ),
        title: Text(
          eventTitle,
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.w600, color: kTextColor),
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
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(20.0),
                        bottom: Radius.circular(20.0)),
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
                          DateFormat('dd.MM.yyyy, kk:mm')
                                  .format(eventDateTime) +
                              " Uhr",
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Event(
                                    eventIcon,
                                    eventTitle,
                                    eventDetails,
                                    eventDateTime,
                                    eventUserStatus,
                                    eventUserWithAnswer)));
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Event(
                        eventIcon,
                        eventTitle,
                        eventDetails,
                        eventDateTime,
                        eventUserStatus,
                        eventUserWithAnswer)));
          }
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color:
              eventUserStatus == "not decided" ? kThirdColor : kSecondaryColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5.0))),
    );
  }
}
