import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';


//final Firestore firestore = Firestore();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);


    return user.uid;
  }

  return null;
}

class DatabaseService {
  final String userID;
  DatabaseService(this.userID);

  final CollectionReference userFriends = Firestore.instance
      .collection('users'); //TODO hier muss noch was geaendert werden!

  Future setFriend(String friendID, String friendName) async {
    return await userFriends.document(userID).setData(
      {friendID: friendName},

    );
  }

  Future deleteFriend(String friendID) async {
    return await userFriends
        .document(userID)
        .updateData({userID: FieldValue.delete()});
  }

  Future checkIfUserExists() async {
    if ((await userFriends.document(userID).get()).exists) {
      return true;
    } else {
      return false;
    }
  }
}
