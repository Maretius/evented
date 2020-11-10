import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final Firestore firestore = Firestore();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

class DatabaseService {
  final String userID;
  DatabaseService(this.userID);
  
  final CollectionReference userFriends = Firestore.instance.collection('users'); //TODO hier muss noch was geaendert werden!

  Future setFriend(String friendID, String friendName) async {
    return await userFriends.document(userID).setData(
      {friendID: friendName}, merge: true,
    );
  }
  Future deleteFriend(String friendID) async {
    return await userFriends.document(userID).updateData(
        {userID: FieldValue.delete()});
  }
  Future checkIfUserExists() async {
    if ((await userFriends.document(userID).get()).exists) {
      return true;
    } else {
      return false;
    }
  }

}