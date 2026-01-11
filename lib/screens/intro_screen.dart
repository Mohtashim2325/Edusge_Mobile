//D:\flutterapps\edusage_mobile\lib\screens\intro_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';

class IntroScreen extends StatelessWidget {
  // Removed unused callback parameter
  const IntroScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEEF2FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.graduationCap, size: 64, color: Color(0xFF4F46E5)),
                  ),
                ),
                const SizedBox(height: 48),
                FadeInUp(
                  child: Text(
                    "EduSage",
                    style: GoogleFonts.inter(
                      fontSize: 40, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                const Spacer(),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // FIX: Navigate to Role Selection first
                      onPressed: () => Navigator.pushReplacementNamed(context, '/role-selection'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text("Get Started", style: GoogleFonts.inter(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}