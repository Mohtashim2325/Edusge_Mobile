import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentBottomNav extends StatelessWidget {
  final String active;
  const StudentBottomNav({super.key, required this.active});

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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), // Reduced horizontal padding
      child: SafeArea(
        child: Row(
          // FIX: Removed MainAxisAlignment.spaceAround
          children: [
            // FIX: Wrapped each item in Expanded to ensure equal width (25% each)
            Expanded(
              child: _NavItem(
                icon: LucideIcons.layoutDashboard, 
                label: "Home", 
                isActive: active == 'dashboard',
                onTap: () => Navigator.pushReplacementNamed(context, '/student/dashboard'),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: LucideIcons.fileInput, 
                label: "Join", 
                isActive: active == 'join',
                onTap: () => Navigator.pushReplacementNamed(context, '/student/enter-code'),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: LucideIcons.bookOpen, 
                label: "My Quizzes", 
                isActive: active == 'quizzes',
                onTap: () => Navigator.pushReplacementNamed(context, '/student/my-quizzes'),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: LucideIcons.user, 
                label: "Profile", 
                isActive: active == 'profile',
                onTap: () => Navigator.pushReplacementNamed(context, '/student/profile'),
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
      // FIX: Added Container with alignment to center content within the Expanded width
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