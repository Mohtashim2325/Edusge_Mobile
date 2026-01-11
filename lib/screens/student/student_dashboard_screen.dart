import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/student_bottom_nav.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero, // Important for header flush
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(child: _buildJoinQuizCard(context)),
                        const SizedBox(height: 32),
                        
                        Text("Quick Actions", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[900])),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildActionCard(LucideIcons.messageSquare, "AI Assistant", Colors.blue, () => Navigator.pushNamed(context, '/chatbot'))),
                            const SizedBox(width: 16),
                            Expanded(child: _buildActionCard(LucideIcons.bookOpen, "My Quizzes", Colors.green, () => Navigator.pushNamed(context, '/student/my-quizzes'))),
                          ],
                        ),

                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Recent Results", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[900])),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/student/my-quizzes'), 
                              child: Text("View All", style: GoogleFonts.inter(fontWeight: FontWeight.bold))
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildRecentItem("Biology: Ch 5", "85%", "2d ago", Colors.green),
                        const SizedBox(height: 12),
                        _buildRecentItem("History: WWII", "92%", "5d ago", Colors.green),
                        const SizedBox(height: 12),
                        _buildRecentItem("Math: Algebra", "Pending", "1w ago", Colors.orange),
                        
                        const SizedBox(height: 32),
                        _buildStreakBanner(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const StudentBottomNav(active: 'dashboard'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)], // Blue to Cyan
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back!", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Ready to learn something new?", style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: const Icon(LucideIcons.settings, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2)),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStat("24", "Quizzes", LucideIcons.fileText),
              const SizedBox(width: 12),
              _buildStat("87%", "Avg Score", LucideIcons.trendingUp),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.2))),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                Text(label, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildJoinQuizCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/student/enter-code'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), // Indigo/Purple
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(LucideIcons.logIn, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter Quiz Code", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Have a code? Start now!", style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.white)
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String label, MaterialColor color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color.shade700, size: 32),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: color.shade900))
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItem(String title, String score, String date, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
              Text(date, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: score == "Pending" ? Colors.orange.shade50 : color.shade50, borderRadius: BorderRadius.circular(8)),
            child: Text(score, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: score == "Pending" ? Colors.orange.shade700 : color.shade700, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildStreakBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text("🔥", style: TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("7 Day Streak!", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Keep it up to earn a badge", style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}