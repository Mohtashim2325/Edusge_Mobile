import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsScreen extends StatefulWidget {
  final String userRole; 
  const SettingsScreen({super.key, this.userRole = 'teacher'});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _quizReminders = true;
  bool _gradeUpdates = true;
  bool _darkMode = false;
  bool _showProfile = true; // FIX: Now used
  String _language = 'en';

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Account?", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: const Text("This action cannot be undone. Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Check your email for verification.", backgroundColor: Colors.red);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Settings", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Notifications", LucideIcons.bell),
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: _buildCard([
                _buildSwitch("Quiz Reminders", _quizReminders, (v) => setState(() => _quizReminders = v)),
                _buildDivider(),
                _buildSwitch("Grade Updates", _gradeUpdates, (v) => setState(() => _gradeUpdates = v)),
              ]),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader("Appearance & Privacy", LucideIcons.settings), // Combined header
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 100),
              child: _buildCard([
                _buildSwitch("Dark Mode", _darkMode, (v) => setState(() => _darkMode = v)),
                _buildDivider(),
                // FIX: Added switch for _showProfile
                _buildSwitch("Show Public Profile", _showProfile, (v) => setState(() => _showProfile = v)),
                _buildDivider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Language", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
                      DropdownButton<String>(
                        value: _language,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text("English")),
                          DropdownMenuItem(value: 'es', child: Text("Español")),
                          DropdownMenuItem(value: 'fr', child: Text("Français")),
                        ],
                        onChanged: (val) {
                          setState(() => _language = val!);
                          Fluttertoast.showToast(msg: "Language updated");
                        },
                      )
                    ],
                  ),
                )
              ]),
            ),

            // ... (Rest of the file remains same, Data & Storage, Account sections)
            const SizedBox(height: 32),
            _buildSectionHeader("Data & Storage", LucideIcons.download),
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 200),
              child: _buildCard([
                _buildAction("Clear Cache", LucideIcons.refreshCw, () {
                  Fluttertoast.showToast(msg: "Cache cleared successfully");
                }, subtitle: "Free up 45 MB"),
                _buildDivider(),
                _buildAction("Download My Data", LucideIcons.download, () {
                  Fluttertoast.showToast(msg: "Download started...");
                }, subtitle: "Export all your data"),
              ]),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader("Account", LucideIcons.user),
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              delay: const Duration(milliseconds: 300),
              child: _buildCard([
                _buildAction("Switch Role", LucideIcons.arrowRightLeft, () {
                  Navigator.pushNamed(context, '/role-selection');
                }, subtitle: "Change between teacher and student"),
                _buildDivider(),
                _buildAction("Delete Account", LucideIcons.trash2, _handleDeleteAccount, isDestructive: true),
              ]),
            ),
            
            const SizedBox(height: 40),
            Center(
              child: Text("EduSage v1.0.0", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Helper widgets _buildSectionHeader, _buildCard, _buildSwitch, _buildAction, _buildDivider remain same)
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
          Switch.adaptive(
            value: value, 
            onChanged: onChanged,
            activeColor: const Color(0xFF4F46E5),
          )
        ],
      ),
    );
  }

  Widget _buildAction(String title, IconData icon, VoidCallback onTap, {String? subtitle, bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDestructive ? Colors.red : Colors.grey.shade600),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: isDestructive ? Colors.red : Colors.black)),
                  if (subtitle != null)
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (!isDestructive) Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey.shade400)
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16);
}