import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class Auth{
  Future<FirebaseUser>  signup(String email, String password) async {
    final authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return authResult;


  }

  Future<FirebaseUser>  signin(String email, String password) async {
    final authResult = await auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;

  }
  Future<FirebaseUser> getUser() async {
    return await auth.currentUser();
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

}