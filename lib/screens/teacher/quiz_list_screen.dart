import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/teacher_bottom_nav.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  String filterTab = 'all';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> quizzes = [
    {'id': 1, 'title': 'Chapter 5: Photosynthesis', 'subject': 'Biology', 'students': 45, 'status': 'active', 'date': '2h ago', 'questions': 15},
    {'id': 2, 'title': 'World War II Quiz', 'subject': 'History', 'students': 38, 'status': 'active', 'date': '1d ago', 'questions': 20},
    {'id': 3, 'title': 'Algebra Basics', 'subject': 'Mathematics', 'students': 52, 'status': 'active', 'date': '2d ago', 'questions': 12},
    {'id': 4, 'title': 'Shakespeare Analysis', 'subject': 'English', 'students': 0, 'status': 'draft', 'date': '3d ago', 'questions': 10},
  ];

  void _showActionMenu(BuildContext context, Map<String, dynamic> quiz) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(quiz['title'], style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildActionItem(LucideIcons.edit, "Edit Quiz", () {
               Navigator.pop(context);
               Navigator.pushNamed(context, '/teacher/quiz/edit', arguments: quiz['id']);
            }),
            _buildActionItem(LucideIcons.share2, "Share Quiz", () {
              Navigator.pop(context);
              // Share logic
            }),
            _buildActionItem(LucideIcons.trash2, "Delete", () {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Quiz deleted successfully", backgroundColor: Colors.red);
            }, isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isDestructive ? Colors.red.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: isDestructive ? Colors.red : Colors.grey.shade700, size: 20),
      ),
      title: Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : Colors.grey.shade900)),
      onTap: onTap,
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/teacher/dashboard'),
        ),
        title: Text("My Quizzes", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              icon: const Icon(LucideIcons.plus, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/teacher/quiz/create'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search quizzes...",
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                    prefixIcon: Icon(LucideIcons.search, color: Colors.grey.shade400, size: 20),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Tabs
                Row(
                  children: ['all', 'active', 'draft'].map((tab) {
                    final isSelected = filterTab == tab;
                    return GestureDetector(
                      onTap: () => setState(() => filterTab = tab),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tab.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey.shade600
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: quizzes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                if (filterTab != 'all' && quiz['status'] != filterTab) return const SizedBox.shrink();

                return FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(child: Text(quiz['title'], style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold))),
                                        if (quiz['status'] == 'draft')
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                                            child: Text("Draft", style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                                          )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(quiz['subject'], style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(LucideIcons.moreVertical, size: 20),
                                color: Colors.grey.shade400,
                                onPressed: () => _showActionMenu(context, quiz),
                              )
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMeta(LucideIcons.users, "${quiz['students']} students"),
                              _buildMeta(LucideIcons.fileText, "${quiz['questions']} Qs"),
                              _buildMeta(LucideIcons.clock, quiz['date']),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {}, // Share logic
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF4F46E5)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text("Share", style: GoogleFonts.inter(color: const Color(0xFF4F46E5), fontWeight: FontWeight.w600)),
                                ),
                              ),
                              if (quiz['students'] > 0) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(context, '/teacher/submissions'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4F46E5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      elevation: 0,
                                    ),
                                    child: Text("Results", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ]
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const TeacherBottomNav(active: 'quizzes'),
        ],
      ),
    );
  }

  Widget _buildMeta(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}