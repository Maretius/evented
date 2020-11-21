import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

//final Firestore firestore = Firestore();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
User user;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
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


class DatabaseService {
  final String userID;
  DatabaseService(this.userID);

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference events =
      FirebaseFirestore.instance.collection('events');

  // Future setFriend(String friendID, String friendName) async {
  //   return await userFriends.doc(userID).set(
  //     {friendID: friendName},
  //   );
  // }

  // Future deleteFriend(String friendID) async {
  //   return await userFriends.doc(userID).update({userID: FieldValue.delete()});
  // }

  Future addEvent(String eventIcon, String eventTitle, String eventDetails, DateTime eventDateTime, List<String> eventTasks, Map<String, bool> eventMembers,) async { // List<String> eventMembers

    // List<Map<String, String>> eventUsers = [
    //   for (var u = 0; u < eventTask.length; u++){
    //     {
    //       "eventUserID": "UserID",
    //       "eventUserName": eventTask[u],
    //       "eventUserRole" : if
    //     },
    //   }
    // ];

    final eventUsers =
        List<Map<String, String>>.generate(eventTasks.length, (index) => null);

    return await events.doc().set({
      "eventName": eventTitle,
      "eventIcon": eventIcon,
      "eventDateTime": eventDateTime,
      "eventDetails": eventDetails,
      "eventTasksUnassigned": eventTasks,
      "eventUser": eventMembers,

      // "eventAdmin" : userID,
      // "eventUsers": eventUsers,
    });
  }

  Future addUser() async {
    String userToken = userID.substring(userID.length - 6);
    return await users.doc(userID).set(
        {
          "userName": user.displayName,
          "userToken" : userToken,
        }
        );
  }

  Future checkIfUserExists() async {
    //await Firebase.initializeApp();
    String userName;
    if ((await users.doc(userID).get()).exists) {
      await users.doc(userID).get().then((value){
        userName = (value.data()["userName"]);
      });
      return userName;
    } else {
      addUser();
    }
  }

  //K3yd3WhOj24JJO2cEeUg
//hjWD8EEn0vhTsR3zHzlJpPgVzEo2
  Stream getEvents(String eventID) {
    return events.doc(eventID).snapshots();
  }

  Future<List<String>> getEventIDs() async{
    List<String> eventIDs;
    await users.doc(userID).get().then((value){
      eventIDs = List.from(value.data()["userEvents"]);
    });
    return eventIDs;
  }

  Future<bool> addFriend(String userFriendToken) async {
    String userFriendName;
    // TODO schmeißt hier Fehler wenn Token falsch, da kein Dokument da
     var result = await users.where("userToken", isEqualTo: userFriendToken).limit(1).get();
     // Check if User exists
     if (result.docs.length == 0) {
       return false;
     } else {
       final String userFriendID = result.docs.first.id;
       await users.doc(userFriendID).get().then((value){
          userFriendName = value.data()["userName"];
       });
       String query = "userFriends." + userFriendID;
       result = await users.where(query, isEqualTo: userFriendName).limit(1).get();
       // Check if Friend already exist
       if (result.docs.length == 0) {
         users.doc(userID).update({
           query : userFriendName,
         });
         return true;
       } else {
         return false;
       }
     }
  }


  Future<Map<String, String>> getFriends() async {
    Map<String, String> friendMap;
    await users.doc(userID).get().then((value){
      friendMap = value.data()["userFriends"];
    });
    print(friendMap.toString());
  }

}
