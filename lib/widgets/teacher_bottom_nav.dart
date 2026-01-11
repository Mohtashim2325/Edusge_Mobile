import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherBottomNav extends StatelessWidget {
  final String active;
  const TeacherBottomNav({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      child: SafeArea(
        child: Row(
          children: [
            // 1. Home / Dashboard
            Expanded(
              child: _NavItem(
                icon: LucideIcons.layoutDashboard, 
                label: "Home", 
                isActive: active == 'dashboard',
                onTap: () => Navigator.pushReplacementNamed(context, '/teacher/dashboard'),
              ),
            ),
            
            // 2. My Quizzes
            Expanded(
              child: _NavItem(
                icon: LucideIcons.fileText, 
                label: "Quizzes", 
                isActive: active == 'quizzes',
                onTap: () => Navigator.pushReplacementNamed(context, '/teacher/quizzes'),
              ),
            ),
            
            // 3. Grading / Submissions (Assuming you have this route)
            Expanded(
              child: _NavItem(
                icon: LucideIcons.checkSquare, 
                label: "Grading", 
                isActive: active == 'grading',
                // If you don't have a grading screen yet, you can point to dashboard or keep it null
                onTap: () => Navigator.pushReplacementNamed(context, '/teacher/submissions'),
              ),
            ),
            
            // 4. Profile
            Expanded(
              child: _NavItem(
                icon: LucideIcons.user, 
                label: "Profile", 
                isActive: active == 'profile',
                onTap: () => Navigator.pushReplacementNamed(context, '/teacher/profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? const Color(0xFF4F46E5) : Colors.grey.shade400, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10, 
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? const Color(0xFF4F46E5) : Colors.grey.shade400
              ),
            )
          ],
        ),
      ),
    );
  }
}