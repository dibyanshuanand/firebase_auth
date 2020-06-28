import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/screens/firstScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_test/utils/commons.dart';
import 'dart:developer' as developer;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  assert(await user.getIdToken() != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  final FirebaseUser currentUser = await _auth.currentUser();
  assert (user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await _auth.signOut();
  await googleSignIn.signOut();

  developer.log("User signed out", name: "Sign_In");
}

void signIn(BuildContext context, String email, String password) async {
  _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((res) async {
//    assert(res.user != null);
//    assert(await res.user.getIdToken() != null);
//
//    final FirebaseUser currentUser = await _auth.currentUser();
//    assert(res.user.uid != currentUser.uid);

    developer.log('User signed in : ${res.user.email}', name: "Sign_In");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirstScreen(
          name: res.user.displayName,
          email: res.user.email,
        ),
      ),
    );
  }).catchError((err) {
    Commons.showErrorDialog(context, err.message);
  });
}

void signUp(BuildContext context, String name, String email, String password) async {
  _auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((res) {
//    Commons.showSnackBar('User created: ${res.user.uid}');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              FirstScreen(name: name, email: res.user.email)
      ),
    );
  }).catchError((err) {
    Commons.showErrorDialog(context, err.message);
  });
}

Future<FirebaseUser> getCurrentUser() async {
  FirebaseUser currentUser = await _auth.currentUser();
  return currentUser;
}