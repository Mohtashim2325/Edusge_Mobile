import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/teacher_bottom_nav.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _error = "No user logged in";
          _isLoading = false;
        });
        return;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      
      if (doc.exists) {
        setState(() {
          _userData = doc.data();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "User data not found";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to load user data: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/intro', (route) => false);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Logout failed: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9FAFB),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4F46E5),
          ),
        ),
      );
    }

    if (_error != null || _userData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _error ?? "Failed to load profile",
                style: GoogleFonts.inter(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserData,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final name = _userData!['name'] ?? 'Teacher';
    final email = _userData!['email'] ?? '';
    final initials = _getInitials(name);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: GoogleFonts.inter(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderStat("0", "Quizzes"),
                    _buildHeaderStat("0", "Students"),
                    _buildHeaderStat("--", "Rating"),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildSectionTitle("Account"),
                _buildMenuItem(
                  LucideIcons.user,
                  "Edit Profile",
                  onTap: () => _showEditProfileDialog(),
                ),
                _buildMenuItem(LucideIcons.mail, "Email Preferences"),
                const SizedBox(height: 24),
                _buildSectionTitle("Support"),
                _buildMenuItem(
                  LucideIcons.helpCircle,
                  "Help & Support",
                  onTap: () => Navigator.pushNamed(context, '/help'),
                ),
                _buildMenuItem(
                  LucideIcons.settings,
                  "Settings",
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(LucideIcons.logOut),
                    label: const Text("Logout"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "EduSage v1.0.0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const TeacherBottomNav(active: 'profile')
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700, size: 20),
        title: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          LucideIcons.chevronRight,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userData!['name']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isEmpty) {
                Fluttertoast.showToast(msg: "Name cannot be empty");
                return;
              }

              try {
                await _firestore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({'name': newName});

                setState(() {
                  _userData!['name'] = newName;
                });

                if (context.mounted) Navigator.pop(context);
                
                Fluttertoast.showToast(
                  msg: "Profile updated successfully",
                  backgroundColor: Colors.green,
                );
              } catch (e) {
                Fluttertoast.showToast(
                  msg: "Failed to update: $e",
                  backgroundColor: Colors.red,
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}