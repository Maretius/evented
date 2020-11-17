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
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;
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

class DatabaseService {

  final String userID;
  DatabaseService(this.userID);

  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

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

    final eventUsers = List<Map<String,String>>.generate(eventTasks.length,(index) => null);


    return await events.doc().set(
      {
        "eventName" : eventTitle,
        "eventIcon" : eventIcon,
        "eventDateTime" : eventDateTime,
        "eventDetails" : eventDetails,
        "eventTasksUnassigned" : eventTasks,
        "eventUser" : eventMembers,

        // "eventAdmin" : userID,
        // "eventUsers": eventUsers,
      }
    );
  }

  Future addUser() async {
    return await users.doc(userID).set(
        {
          "userName": user.displayName,
        }
        );
  }

  Future checkIfUserExists() async {
    await Firebase.initializeApp();
    if ((await users.doc(userID).get()).exists) {
      return true;
    } else {
      addUser();
    }
  }
}
