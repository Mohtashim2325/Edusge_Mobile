  //D:\flutterapps\edusage_mobile\lib\screens\role_selection_screen.dart
  import 'package:flutter/material.dart';
  import 'package:animate_do/animate_do.dart';
  import 'package:lucide_icons/lucide_icons.dart';
  import 'package:google_fonts/google_fonts.dart';

  class RoleSelectionScreen extends StatelessWidget {
    // Removed callback parameter
    const RoleSelectionScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                FadeInDown(
                  child: Text("Who are you?", style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                
                // Teacher Option
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _RoleCard(
                    title: "Teacher",
                    description: "Create quizzes, track progress, and grade assignments.",
                    icon: LucideIcons.userCheck,
                    color: const Color(0xFF4F46E5),
                    onTap: () {
                      // FIX: Pass 'teacher' to Auth Screen
                      Navigator.pushNamed(context, '/auth', arguments: 'teacher');
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Student Option
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: _RoleCard(
                    title: "Student",
                    description: "Join quizzes, view results, and track your learning.",
                    icon: LucideIcons.graduationCap,
                    color: const Color(0xFF0EA5E9),
                    onTap: () {
                      // FIX: Pass 'student' to Auth Screen
                      Navigator.pushNamed(context, '/auth', arguments: 'student');
                    },
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      );
    }
  }

  class _RoleCard extends StatelessWidget {
    final String title;
    final String description;
    final IconData icon;
    final Color color;
    final VoidCallback onTap;

    const _RoleCard({required this.title, required this.description, required this.icon, required this.color, required this.onTap});

    @override
    Widget build(BuildContext context) {
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(description, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      );
    }
  }