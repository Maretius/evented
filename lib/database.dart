import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

//final Firestore firestore = Firestore();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
User user;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
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

Future signOutWithGoogle() async {
  await FirebaseAuth.instance.signOut();
  await _auth.signOut();
  googleSignIn.signOut();
  //googleSignIn.disconnect();
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

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

  Future addEvent(String userName, String eventIcon, String eventTitle, String eventDetails, DateTime eventDateTime, List<String> eventTasks, Map<String, String> userFriends, Map<String, bool> eventMembers,) async {
    Map<String, String> eventUsers = {userID: userName};
    Map<String, String> eventTasksUser = {};
    Map<String, String> eventStatus = {};

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
        eventStatus[key] = "admin";
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
    eventUsers.forEach((key, value) { 
      users.doc(key).update({"userEvents": FieldValue.arrayUnion([result.id])});
    });
  }

  Future changeEventUserStatus(String eventID, String userEventStatus) async {
    String query = "eventStatus." + userID;
    await events.doc(eventID).update({
      query : userEventStatus
    });
  }

  Future changeEventDetails(String eventID, String eventDetails) async {
    await events.doc(eventID).update({
      "eventDetails" : eventDetails,
    });
  }

  Future addEventUsers(String eventID, String userFriendID, String userFriendName) async {
    String statusQuery = "eventStatus." + userFriendID;
    String usersQuery = "eventUsers." + userFriendID;
    await events.doc(eventID).update({
      statusQuery : "not decided",
      usersQuery : userFriendName,
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

  Future addEventTaskToUser(String eventID, String eventTask, String eventUserID) async {
    String query = "eventTasksUser." + eventTask;
    await events.doc(eventID).update({
      query : eventUserID,
    });
  }

  Future addUser() async {
    String userToken = userID.substring(userID.length - 6);
    return await users.doc(userID).set({
      "userName": user.displayName,
      "userToken": userToken,
    });
  }

  Future checkIfUserExists() async {
    //await Firebase.initializeApp();
    String userName;
    if ((await users.doc(userID).get()).exists) {
      await users.doc(userID).get().then((value) {
        userName = (value.data()["userName"]);
      });
      return userName;
    } else {
      addUser();
    }
  }

  Stream getEvents(String eventID) {
    return events.doc(eventID).snapshots();
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
