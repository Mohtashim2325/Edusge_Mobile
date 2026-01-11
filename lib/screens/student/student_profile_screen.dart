import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/student_bottom_nav.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

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
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              children: [
                const CircleAvatar(radius: 40, backgroundColor: Color(0xFF4F46E5), child: Icon(LucideIcons.user, size: 40, color: Colors.white)),
                const SizedBox(height: 16),
                Text("Alex Student", style: GoogleFonts.inter(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Grade 10 • Lincoln High", style: GoogleFonts.inter(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildMenuItem(LucideIcons.settings, "Settings"),
                _buildMenuItem(LucideIcons.helpCircle, "Help & Support"),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false),
                  icon: const Icon(LucideIcons.logOut, size: 18),
                  label: const Text("Logout"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const StudentBottomNav(active: 'profile')
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700, size: 20),
        title: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}