import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//final Firestore firestore = Firestore();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
User user;

Future<String> signInWithGoogle() async {
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  while (googleSignInAccount == null) {
     googleSignInAccount = await googleSignIn.signIn();
  }
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
  }
  return user.uid;
}

class LocalUser {
  String userName;
  List<String> userEvents;
  Map<String, String> userFriends;
  LocalUser(this.userName, this.userEvents, this.userFriends);
}

class DatabaseService {
  final String userID;
  DatabaseService(this.userID);
  String postUrl = "fcm.googleapis.com/fcm/send";

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

  Future addEvent(String userName, String eventIcon, String eventTitle, String eventDetails, DateTime eventDateTime, List<String> eventTasks, Map<String, String> userFriends, Map<String, bool> eventMembers,) async {
    Map<String, String> eventUsers = {userID: userName};
    Map<String, String> eventTasksUser = {};
    Map<String, String> eventStatus = {};
    String userMessagingToken;

    userFriends.forEach((key, value) {
      if (eventMembers[key] == true) {
        eventUsers[key] = value;
      }
    });
    eventTasks.forEach((element) {
      eventTasksUser[element] = null;
    });
    eventUsers.forEach((key, value) {
      if (key == userID) {
        eventStatus[key] = "Admin";
      } else {
        eventStatus[key] = "not decided";
      }
    });
    final result = await events.add({
      "eventName": eventTitle,
      "eventDetails": eventDetails,
      "eventIcon": eventIcon,
      "eventDateTime": eventDateTime,
      "eventUsers" : eventUsers,
      "eventTasksUser": eventTasksUser,
      "eventStatus": eventStatus,
    });
    eventUsers.forEach((key, value) async { 
      users.doc(key).update({
        "userEvents": FieldValue.arrayUnion([result.id])
      });
      // send Message to each user
      if (userID != key) {
        await users.doc(key).get().then((value) {
          userMessagingToken = (value.data()["userMessagingToken"]);
        });
        PushNotificationsManager.instance.sendNotification(userMessagingToken, "event invitation", "Hey, you have been invited to $eventTitle $eventIcon");
      }
      });
  }

  Future changeEventUsers(String eventID, Map<String, String> newEventUsers) async {
    String userMessagingToken;
    Map<String, String> eventStatus = {};
    newEventUsers.forEach((key, value) {
        eventStatus[key] = "not decided";
    });
    await events.doc(eventID).set({
      "eventUsers" : newEventUsers,
      "eventStatus": eventStatus,
    }, SetOptions(merge: true));
    newEventUsers.forEach((key, value) async {
      users.doc(key).update({
        "userEvents": FieldValue.arrayUnion([eventID])
      });
      await users.doc(key).get().then((value) {
        userMessagingToken = (value.data()["userMessagingToken"]);
      });
      PushNotificationsManager.instance.sendNotification(userMessagingToken, "event invitation", "Hey, you have been invited to an event");
    });
  }

  Future changeEventUserStatus(String eventID, String userEventStatus) async {
    String query = "eventStatus." + userID;
    await events.doc(eventID).update({
      query : userEventStatus
    });
  }

  Future changeEventDetails(String eventID, String eventDetails) async {
    print("ID: " + eventID);
    await events.doc(eventID).update({
      "eventDetails" : eventDetails,
    });
  }

  Future changeEventDateTime(String eventID, DateTime eventDateTime) async {
    await events.doc(eventID).update({
      "eventDateTime" : eventDateTime,
    });
  }

  Future addEventTask(String eventID, String eventTask) async {
    String query = "eventTasksUser." + eventTask;
    await events.doc(eventID).update({
      query : null,
    });
  }

  Future removeEventTask(String eventID, String eventTask) async {
    String query = "eventTasksUser." + eventTask;
    await events.doc(eventID).update({query: FieldValue.delete()});
  }

  Future changeEventTask(String eventID, Map<String, String> eventTasksUser) async {
    await events.doc(eventID).set({
      "eventTasksUser" : eventTasksUser,
    }, SetOptions(merge: true));
  }

  Future addEventTaskToUser(String eventID, String eventTask, String eventUserID) async {
    String query = "eventTasksUser." + eventTask;
    await events.doc(eventID).update({
      query : eventUserID,
    });
  }

  Future deleteEvent(String eventID) async {
    Map<String, String> eventUser = {};
    await events.doc(eventID).get().then((value) {
      eventUser = Map.from(value.data()["eventUsers"]);
    });
    List<String> eventUserIDs = [];
    eventUser.forEach((key, value) {
      eventUserIDs.add(key);
    });
    for (var u = 0; u < eventUserIDs.length; u++) {
      String query = "userEvents";
      await users.doc(eventUserIDs[u]).update({query: FieldValue.arrayRemove([eventID])});
    }
    await events.doc(eventID).delete();
  }

  Future checkIfUserExists() async {
    String userName;
    String userMessagingToken;
    // get Firebase Messaging Token
    String userDBMessagingToken = await PushNotificationsManager.instance.init();

    if ((await users.doc(userID).get()).exists) {
      await users.doc(userID).get().then((value) {
        userName = (value.data()["userName"]);
        userMessagingToken = (value.data()["userMessagingToken"]);
      });
      if (userDBMessagingToken != userMessagingToken) {
        await users.doc(userID).update({
          "userMessagingToken": userDBMessagingToken,
        });
      }
      return userName;
    } else {
      // add User to Firebase
      String userToken = userID.substring(userID.length - 6);
      Map<String, String> userFriends = {};
      List<String> userEvents = [];
      await users.doc(userID).set({
        "userName": user.displayName,
        "userToken": userToken,
        "userMessagingToken": userDBMessagingToken,
        "userEvents": userEvents,
        "userFriends": userFriends,
      });
      return user.displayName;
    }
  }

  Stream getEvent(String eventID) {
    return events.doc(eventID).snapshots();
  }

  Stream getUser() {
    return users.doc(userID).snapshots();
  }

  Future<Map<String, String>> addFriend(String userFriendToken, List<String> userFriendIDs) async {
    String userFriendName;
    var result = await users.where("userToken", isEqualTo: userFriendToken).limit(1).get();
    // Check if User exists
    if (result.docs.length == 0) {
      return null;
    } else {
      final String userFriendID = result.docs.first.id;
      await users.doc(userFriendID).get().then((value) {
        userFriendName = value.data()["userName"];
      });
      String query = "userFriends." + userFriendID;
      // Check if Friend already exist
      if (userFriendIDs.contains(userFriendID)) {
        return null;
      } else {
        users.doc(userID).update({
          query: userFriendName,
        });
        Map<String, String> map = {userFriendID: userFriendName};
        return map;
      }
    }
  }

  Future deleteFriend(String userFriendID) async {
    String query = "userFriends." + userFriendID;
    await users.doc(userID).update({query: FieldValue.delete()});
  }

  Future getUserData() async {
    String userName;
    List<String> userEvents;
    Map<String, String> userFriends;
    await users.doc(userID).get().then((value) {
      userName = value.data()["userName"];
      userEvents = List.from(value.data()["userEvents"]);
      userFriends = Map.from(value.data()["userFriends"]);
    });
    return LocalUser(userName, userEvents, userFriends);
  }
}

class PushNotificationsManager {

  PushNotificationsManager._();
  factory PushNotificationsManager() => instance;
  static final PushNotificationsManager instance = PushNotificationsManager._();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  bool initialized = false;
  String token;
  String serverKey = "AAAAvM0bnq8:APA91bHLcWVZ47ho1jhJl2UNxCr8N4q5TEne8Bbd7matb6LdVPM8WffxztmIvo0HAYSEZ5Io3MaXOhUPtNXbUgoqlVBh-9T-o5LxW5D_CPOl19a10QNXFG_7b55WWWUG--r2279Ip_yt";

  Future init() async {
    if (!initialized) {
      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
        },
        onLaunch: (Map<String, dynamic> message) async {
        },
        onResume: (Map<String, dynamic> message) async {
        },
      );

      token = await firebaseMessaging.getToken();
      initialized = true;
    } else {
      token = await firebaseMessaging.getToken();
    }
    return token;
  }

  Future sendNotification(userFriendMessagingToken, messageTitle, messageBody) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': messageBody,
            'title': messageTitle
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': userFriendMessagingToken,
        },
      ),
    );
  }

}