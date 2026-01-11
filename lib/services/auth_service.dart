//D:\flutterapps\edusage_mobile\lib\services\auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// =========================
  /// SIGN UP (STEP 1: NO ROLE)
  /// =========================
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': null, // 👈 Step 2 will update this
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Signup failed');
    }
  }

  /// =========================
  /// LOGIN
  /// =========================
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  /// =========================
  /// STEP 2: SAVE ROLE
  /// =========================
  Future<void> saveUserRole(String role) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _firestore.collection('users').doc(user.uid).update({
      'role': role,
    });
  }

  /// =========================
  /// GET USER DATA
  /// =========================
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    return doc.data();
  }

  /// =========================
  /// CURRENT USER
  /// =========================
  User? get currentUser => _auth.currentUser;

  /// =========================
  /// LOGOUT
  /// =========================
  Future<void> logout() async {
    await _auth.signOut();
  }
}
