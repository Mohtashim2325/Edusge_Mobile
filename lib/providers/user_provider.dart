//D:\flutterapps\edusage_mobile\lib\providers\user_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? user;
  bool isLoading = false;

  // -------------------------
  // SIGN UP (ROLE FIRST)
  // -------------------------
  Future<String?> signUp(
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1. Create auth account
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // 2. Create Firestore profile
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'role': role, // 👈 STORED AT CREATION
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Set local user
      user = AppUser(
        uid: uid,
        email: email,
        name: name,
        role: role,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------
  // SIGN IN
  // -------------------------
  Future<String?> signIn(
    String email,
    String password,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1. Verify credentials
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // 2. Fetch Firestore profile
      final snap = await _firestore.collection('users').doc(uid).get();

      if (!snap.exists) {
        return 'User profile not found';
      }

      final data = snap.data()!;

      // 3. Set local user
      user = AppUser(
        uid: uid,
        email: data['email'],
        name: data['name'],
        role: data['role'],
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------
  // LOGOUT (LATER USE)
  // -------------------------
  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}
