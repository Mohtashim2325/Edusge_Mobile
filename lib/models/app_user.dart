//D:\flutterapps\edusage_mobile\lib\models\app_user.dart
class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role; // 'teacher' or 'student'

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  // Factory constructor from Firestore document
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'student',
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
    };
  }
}