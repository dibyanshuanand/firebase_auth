import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

Future<String> signIn(String email, String password) async {
  AuthResult result =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
  FirebaseUser user = result.user;

  assert(user != null);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert (user.uid == currentUser.uid);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl ?? 'assets/user_generic.png';
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  developer.log('User signed in : ${user.email}', name: "Sign_In");

  print('signInWithEmail succeeded: $user');

  return user.uid;
}

Future<String> signUp(String email, String password) async {
  AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);
  FirebaseUser user = result.user;
  return user.uid;
}

Future<FirebaseUser> getCurrentUser() async {
  FirebaseUser currentUser = await _auth.currentUser();
  return currentUser;
}