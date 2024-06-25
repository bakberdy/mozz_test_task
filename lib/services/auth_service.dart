import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/custom_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CustomUser? _userFromFirebaseUser(User? user, String firstName, String lastName, String email) {
    return user != null ? CustomUser(uid: user.uid, name: firstName, lastName: lastName, email: email) : null;
  }

 Stream<CustomUser?> get user {
  return _auth.authStateChanges().asyncMap((User? firebaseUser) async {
    if (firebaseUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null) {
            return CustomUser(uid: firebaseUser.uid, name: userData['firstName'], lastName: userData['lastName'], email: userData['email'],);
          }
        }
      } catch (e) {
        print("Error getting user data: $e");
        return null;
      }
    }
    return null;
  });
}


  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return userCredential;
    } catch (e) {
      print("Error signing in: $e");
      rethrow;
    }
  }

  Future<void> changePassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error sending password reset email: $e");
      rethrow;
    }
  }

  Future<CustomUser?> signUpWithEmailAndPassword(String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      await _firestore.collection('users').doc(user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });

      return _userFromFirebaseUser(user, firstName, lastName, email);
    } catch (e) {
      print("Error signing up: $e");
      rethrow;
    }
  }

}
