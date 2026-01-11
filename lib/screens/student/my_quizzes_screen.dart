import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/student_bottom_nav.dart';

class MyQuizzesScreen extends StatefulWidget {
  const MyQuizzesScreen({super.key});

  @override
  State<MyQuizzesScreen> createState() => _MyQuizzesScreenState();
}

class _MyQuizzesScreenState extends State<MyQuizzesScreen> {
  String _filter = 'all';
  String _search = '';

  final List<Map<String, dynamic>> quizzes = [
    {
      'id': 1,
      'title': 'Chapter 5: Photosynthesis',
      'subject': 'Biology',
      'teacher': 'Dr. Smith',
      'status': 'graded',
      'score': 85,
      'maxScore': 100,
      'submittedAt': '2 days ago',
      'feedback': 'Great work!'
    },
    {
      'id': 3,
      'title': 'Algebra Basics',
      'subject': 'Math',
      'teacher': 'Mr. Williams',
      'status': 'pending',
      'submittedAt': '1 week ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = quizzes.where((q) {
      final matchesSearch = q['title'].toLowerCase().contains(_search.toLowerCase());
      final matchesFilter = _filter == 'all' || q['status'] == _filter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("My Quizzes", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _search = val),
                  decoration: InputDecoration(
                    hintText: "Search quizzes...",
                    prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: ['all', 'graded', 'pending'].map((filter) {
                    final isSelected = _filter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _filter = filter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          filter.toUpperCase(), 
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade600)
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final quiz = filteredList[index];
                final isGraded = quiz['status'] == 'graded';
                return FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () {
                      if (isGraded) Navigator.pushNamed(context, '/student/quiz-results', arguments: quiz['id']);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isGraded ? Colors.green.shade50 : Colors.orange.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isGraded ? LucideIcons.checkCircle : LucideIcons.clock, 
                                  size: 20, 
                                  color: isGraded ? Colors.green : Colors.orange
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(quiz['title'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text("${quiz['subject']} • ${quiz['teacher']}", style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(quiz['submittedAt'], style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade400)),
                                  ],
                                ),
                              ),
                              if (isGraded)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("${quiz['score']}%", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                                    Text("${quiz['score']}/${quiz['maxScore']}", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                                  ],
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                                  child: Text("Pending", style: GoogleFonts.inter(fontSize: 12, color: Colors.orange.shade800, fontWeight: FontWeight.w600)),
                                )
                            ],
                          ),
                          if (isGraded && quiz['feedback'] != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade100)),
                              child: Text("Teacher: ${quiz['feedback']}", style: GoogleFonts.inter(fontSize: 13, color: Colors.green.shade800)),
                            )
                          ],
                          if (isGraded) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pushNamed(context, '/student/quiz-results', arguments: quiz['id']),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF4F46E5)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text("View Detailed Results", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const StudentBottomNav(active: 'quizzes'),
        ],
      ),
    );
  }
}