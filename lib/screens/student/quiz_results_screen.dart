import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // FIX: Now actively used below
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuizResultsScreen extends StatefulWidget {
  final int? quizId;
  const QuizResultsScreen({super.key, this.quizId});

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  // Mock Data
  final String quizTitle = "Chapter 5: Photosynthesis";
  final int score = 85;
  final int maxScore = 100;
  
  final List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'q': 'Primary pigment in photosynthesis?',
      'studentAns': 'Chlorophyll',
      'correctAns': 'Chlorophyll',
      'isCorrect': true,
      'score': 1,
      'explanation': 'Chlorophyll absorbs light energy.'
    },
    {
      'id': 3,
      'q': 'Explain light-dependent reactions.',
      'studentAns': 'Happens in thylakoid...',
      'correctAns': 'Occurs in thylakoid membranes...',
      'isCorrect': false,
      'score': 3,
      'maxScore': 5,
      'feedback': 'Good start, but missing details.',
      'explanation': 'Needs more on NADPH.'
    }
  ];

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black), 
          onPressed: () => Navigator.pop(context)
        ),
        title: Text("Results", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Fluttertoast.showToast(msg: "Shared!"), 
            icon: const Icon(LucideIcons.share2, color: Colors.black)
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FIX: Using ZoomIn triggers the animate_do package
            ZoomIn(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    const Icon(LucideIcons.trophy, color: Colors.white, size: 48),
                    const SizedBox(height: 16),
                    Text(quizTitle, style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderStat("$score%", "Score"),
                        _buildHeaderStat("A", "Grade"),
                        _buildHeaderStat("12/15", "Correct"),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            FadeInLeft(
              child: Align(alignment: Alignment.centerLeft, child: Text("Question Breakdown", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 12),
            
            ...List.generate(questions.length, (index) {
              final q = questions[index];
              final isExpanded = _expandedIndex == index;
              
              // FIX: Using FadeInUp wraps list items in animation
              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _expandedIndex = isExpanded ? -1 : index),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                q['isCorrect'] ? LucideIcons.checkCircle : LucideIcons.xCircle, 
                                color: q['isCorrect'] ? Colors.green : Colors.red,
                                size: 24
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Question ${index + 1}", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                                    Text(q['q'], style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Text("${q['score']}/${q['maxScore'] ?? 1}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: q['isCorrect'] ? Colors.green : Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeedbackBlock("Your Answer", q['studentAns'], q['isCorrect'] ? Colors.green.shade50 : Colors.red.shade50),
                              if (!q['isCorrect']) ...[
                                const SizedBox(height: 12),
                                _buildFeedbackBlock("Correct Answer", q['correctAns'], Colors.green.shade50),
                              ],
                              if (q['feedback'] != null) ...[
                                const SizedBox(height: 12),
                                _buildFeedbackBlock("Teacher Feedback", q['feedback'], Colors.indigo.shade50, icon: LucideIcons.messageSquare),
                              ],
                              const SizedBox(height: 12),
                              _buildFeedbackBlock("Explanation", q['explanation'], Colors.purple.shade50, icon: LucideIcons.alertCircle),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/chatbot'),
                icon: const Icon(LucideIcons.messageSquare, size: 18),
                label: const Text("Ask AI for Help"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Back to List"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildFeedbackBlock(String label, String content, Color bg, {IconData? icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 14, color: Colors.black54), const SizedBox(width: 6)],
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 4),
          Text(content, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}