



import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e.toString());
      return Future.error(_parseFirebaseAuthErrorMessage(e.toString()));
    }
    
  }

  String _parseFirebaseAuthErrorMessage(String firebaseError) {
  RegExp regExp = RegExp(r'\[.*\](.*)');
  var match = regExp.firstMatch(firebaseError);
  return match?.group(1)?.trim() ?? firebaseError; // rteturns the descriptive part or the whole error if the pattern is not matched
}

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(_parseFirebaseAuthErrorMessage(e.toString()));
      return Future.error(_parseFirebaseAuthErrorMessage(e.toString()));
    }
    
  }




}