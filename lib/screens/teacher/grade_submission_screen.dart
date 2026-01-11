import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GradeSubmissionScreen extends StatefulWidget {
  final int? submissionId;
  const GradeSubmissionScreen({super.key, this.submissionId});

  @override
  State<GradeSubmissionScreen> createState() => _GradeSubmissionScreenState();
}

class _GradeSubmissionScreenState extends State<GradeSubmissionScreen> {
  // Mock Data
  final String studentName = 'Sarah Johnson';
  final String quizTitle = 'Chapter 5: Photosynthesis';
  
  List<Map<String, dynamic>> grades = [
    {
      'id': 1,
      'question': 'What is the primary pigment involved in photosynthesis?',
      'studentAnswer': 'Chlorophyll',
      'correctAnswer': 'Chlorophyll',
      'aiSuggestion': 'correct',
      'aiScore': 1.0,
      'maxScore': 1.0,
      'teacherScore': null,
      'aiFeedback': 'Perfect match.',
    },
    {
      'id': 3,
      'question': 'Explain light-dependent reactions.',
      'studentAnswer': 'Light reactions happen in thylakoid...',
      'correctAnswer': 'Light-dependent reactions occur in...',
      'aiSuggestion': 'partial',
      'aiScore': 3.0,
      'maxScore': 5.0,
      'teacherScore': null,
      'aiFeedback': 'Good concept, missing NADPH mention.',
    }
  ];

  void _acceptAiSuggestion(int index) {
    setState(() {
      grades[index]['teacherScore'] = grades[index]['aiScore'];
    });
    Fluttertoast.showToast(msg: "AI suggestion accepted");
  }

  void _updateScore(int index, double score) {
    setState(() {
      grades[index]['teacherScore'] = score;
    });
  }

  double get _totalScore {
    return grades.fold(0.0, (sum, g) => sum + (g['teacherScore'] ?? g['aiScore']));
  }

  double get _maxTotal {
    return grades.fold(0.0, (sum, g) => sum + g['maxScore']);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ((_totalScore / _maxTotal) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(LucideIcons.arrowLeft, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Grade Submission", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(studentName, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Fluttertoast.showToast(msg: "Grades Published!", backgroundColor: Colors.green);
                Navigator.pop(context);
              },
              icon: const Icon(LucideIcons.save, size: 16, color: Colors.white),
              label: Text("Publish", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Student Score Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: const Color(0xFF6366F1), child: Text("SJ", style: GoogleFonts.inter(color: Colors.white))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(studentName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(quizTitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("$_totalScore / $_maxTotal", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
                      Text("$percentage%", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: percentage >= 80 ? Colors.green : Colors.orange)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Questions List
            ...List.generate(grades.length, (index) {
              final g = grades[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 12, backgroundColor: const Color(0xFFEEF2FF), child: Text("${index + 1}", style: const TextStyle(fontSize: 12, color: Color(0xFF4F46E5)))),
                          const SizedBox(width: 8),
                          Expanded(child: Text(g['question'], style: GoogleFonts.inter(fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAnswerBlock("Student Answer", g['studentAnswer'], Colors.blue.shade50),
                          const SizedBox(height: 12),
                          _buildAnswerBlock("Correct Answer", g['correctAnswer'], Colors.green.shade50),
                          const SizedBox(height: 12),
                          
                          // AI Section
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purple.shade100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(LucideIcons.sparkles, size: 16, color: Colors.purple),
                                    const SizedBox(width: 8),
                                    Text("AI Suggestion", style: GoogleFonts.inter(color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    _buildBadge(g['aiSuggestion']),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(g['aiFeedback'], style: GoogleFonts.inter(fontSize: 13, color: Colors.purple.shade800)),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Score: ${g['aiScore']}/${g['maxScore']}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                                    TextButton.icon(
                                      onPressed: () => _acceptAiSuggestion(index),
                                      icon: const Icon(LucideIcons.thumbsUp, size: 14),
                                      label: const Text("Accept"),
                                      style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.purple, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text("Your Score:", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 12),
                              Container(
                                width: 60,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(text: (g['teacherScore'] ?? '').toString()),
                                  onChanged: (val) {
                                    if(val.isNotEmpty) _updateScore(index, double.parse(val));
                                  },
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(" / ${g['maxScore']}", style: GoogleFonts.inter(color: Colors.grey)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerBlock(String label, String content, Color bg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Text(content, style: GoogleFonts.inter(fontSize: 14)),
        )
      ],
    );
  }

  Widget _buildBadge(String type) {
    Color color;
    switch(type) {
      case 'correct': color = Colors.green; break;
      case 'partial': color = Colors.orange; break;
      default: color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(type.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}