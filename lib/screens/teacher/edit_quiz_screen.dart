import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditQuizScreen extends StatefulWidget {
  final int? quizId;
  const EditQuizScreen({super.key, this.quizId});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final TextEditingController _titleController = TextEditingController(text: "Chapter 5: Photosynthesis");
  
  // Mock Data Structure
  List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'type': 'mcq',
      'question': 'What is the primary pigment involved in photosynthesis?',
      'options': ['Chlorophyll', 'Carotene', 'Xanthophyll', 'Anthocyanin'],
      'correctIndex': 0,
      'aiExplanation': 'Chlorophyll is the main pigment that absorbs light energy.',
      'sourceRef': 'Bio Textbook, Ch 5, Pg 87',
      'expanded': false
    },
    {
      'id': 2,
      'type': 'qa',
      'question': 'Explain the difference between light-dependent and independent reactions.',
      'answer': 'Light-dependent reactions occur in thylakoids...',
      'aiExplanation': 'Tests understanding of photosynthesis stages.',
      'sourceRef': 'Bio Textbook, Ch 5, Pg 90',
      'expanded': false
    }
  ];

  void _toggleExpand(int index) {
    setState(() {
      questions[index]['expanded'] = !questions[index]['expanded'];
    });
  }

  void _addNewQuestion() {
    setState(() {
      questions.add({
        'id': questions.length + 1,
        'type': 'mcq',
        'question': '',
        'options': ['', '', '', ''],
        'correctIndex': 0,
        'aiExplanation': '',
        'sourceRef': '',
        'expanded': true
      });
    });
    Fluttertoast.showToast(msg: "New question added");
  }

  void _deleteQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
    Fluttertoast.showToast(msg: "Question deleted");
  }

  void _saveQuiz() {
    if (questions.any((q) => (q['question'] as String).isEmpty)) {
      Fluttertoast.showToast(msg: "Please fill in all questions", backgroundColor: Colors.red);
      return;
    }
    Fluttertoast.showToast(msg: "Quiz saved successfully!", backgroundColor: Colors.green);
    Navigator.pop(context);
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
        title: TextField(
          controller: _titleController,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Quiz Title",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: _saveQuiz,
              icon: const Icon(LucideIcons.save, size: 16, color: Colors.white),
              label: Text("Save", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length + 1, // +1 for Add Button
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == questions.length) {
            return GestureDetector(
              onTap: _addNewQuestion,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.plus, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Add New Question", style: GoogleFonts.inter(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          }

          final q = questions[index];
          final isMCQ = q['type'] == 'mcq';

          return FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                              child: Text("${index + 1}", style: GoogleFonts.inter(color: const Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isMCQ ? Colors.blue.shade50 : Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(4)
                                        ),
                                        child: Text(
                                          isMCQ ? 'Multiple Choice' : 'Written Answer',
                                          style: GoogleFonts.inter(fontSize: 10, color: isMCQ ? Colors.blue.shade700 : Colors.green.shade700, fontWeight: FontWeight.w600)
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => _deleteQuestion(index),
                                        child: const Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: TextEditingController(text: q['question']),
                                    onChanged: (val) => q['question'] = val,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      hintText: "Enter question...",
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                                      contentPadding: const EdgeInsets.all(12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isMCQ) ...[
                          const SizedBox(height: 16),
                          ...List.generate(4, (optIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => q['correctIndex'] = optIndex),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: q['correctIndex'] == optIndex ? Colors.green : Colors.grey.shade300, width: 2),
                                        color: q['correctIndex'] == optIndex ? Colors.green : Colors.transparent,
                                      ),
                                      child: q['correctIndex'] == optIndex ? const Icon(LucideIcons.check, size: 14, color: Colors.white) : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(text: (q['options'] as List)[optIndex]),
                                      decoration: InputDecoration(
                                        hintText: "Option ${String.fromCharCode(65 + optIndex)}",
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                        ],
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _toggleExpand(index),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(q['expanded'] ? LucideIcons.chevronUp : LucideIcons.chevronDown, size: 16, color: const Color(0xFF4F46E5)),
                              const SizedBox(width: 4),
                              Text(
                                q['expanded'] ? "Hide Details" : "Show AI Explanation",
                                style: GoogleFonts.inter(color: const Color(0xFF4F46E5), fontWeight: FontWeight.w600, fontSize: 12)
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  if (q['expanded'])
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey.shade50,
                      child: Column(
                        children: [
                          _buildDetailInput("AI Explanation", q['aiExplanation']),
                          const SizedBox(height: 12),
                          _buildDetailInput("Source Reference", q['sourceRef'], icon: LucideIcons.bookOpen),
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailInput(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: Colors.grey), const SizedBox(width: 4)],
            Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          maxLines: null,
          style: GoogleFonts.inter(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            contentPadding: const EdgeInsets.all(12),
          ),
        )
      ],
    );
  }
}