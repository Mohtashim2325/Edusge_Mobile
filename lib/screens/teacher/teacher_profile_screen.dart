import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/teacher_bottom_nav.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF9333EA)]),
            ),
            child: Column(
              children: [
                const CircleAvatar(radius: 40, backgroundColor: Colors.white24, child: Text("EA", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                Text("Dr. Emily Anderson", style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("emily.anderson@school.edu", style: GoogleFonts.inter(color: Colors.white70)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderStat("48", "Quizzes"),
                    _buildHeaderStat("248", "Students"),
                    _buildHeaderStat("4.8", "Rating"),
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
                _buildMenuItem(LucideIcons.user, "Edit Profile", onTap: () => Fluttertoast.showToast(msg: "Coming soon")),
                _buildMenuItem(LucideIcons.mail, "Email Preferences"),
                const SizedBox(height: 24),
                _buildSectionTitle("Support"),
                _buildMenuItem(LucideIcons.helpCircle, "Help & Support"),
                _buildMenuItem(LucideIcons.settings, "Settings"),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate back to auth
                      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                    },
                    icon: const Icon(LucideIcons.logOut),
                    label: const Text("Logout"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12)
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(child: Text("EduSage v1.0.0", style: TextStyle(color: Colors.grey)))
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
        Text(val, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700, size: 20),
        title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
        onTap: onTap ?? () {},
      ),
    );
  }
}