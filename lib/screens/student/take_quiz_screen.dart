import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  // State
  int _currentIndex = 0;
  int _timeLeft = 1800; // 30 minutes
  Timer? _timer;

  // Stores answers: Key = Question ID, Value = Answer Index (int) or Text (String)
  final Map<int, dynamic> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'id': 1,
      'type': 'mcq',
      'question': 'What is the primary pigment involved in photosynthesis?',
      'options': ['Chlorophyll', 'Carotene', 'Xanthophyll', 'Anthocyanin'],
    },
    {
      'id': 2,
      'type': 'mcq',
      'question': 'In which part of the cell does photosynthesis occur?',
      'options': ['Mitochondria', 'Nucleus', 'Chloroplast', 'Ribosome'],
    },
    {
      'id': 3,
      'type': 'qa',
      'question':
          'Explain the difference between light-dependent and light-independent reactions.',
    },
    {
      'id': 4,
      'type': 'mcq',
      'question': 'Which gas is released as a byproduct of photosynthesis?',
      'options': ['Carbon Dioxide', 'Oxygen', 'Nitrogen', 'Hydrogen'],
    },
    {
      'id': 5,
      'type': 'mcq',
      'question': 'What is the main product of photosynthesis?',
      'options': ['Water', 'Glucose', 'Carbon Dioxide', 'ATP'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        timer.cancel();
        _handleSubmit(autoSubmit: true);
      }
    });
  }

  Future<bool> _onWillPop() async {
    // Show the exit dialog logic you already have
    _handleExit();
    // Return false to prevent immediate exit (we handle navigation in _handleExit)
    return false;
  }

  String _formatTime(int seconds) {
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _handleAnswer(dynamic answer) {
    setState(() {
      _answers[_questions[_currentIndex]['id']] = answer;
    });
  }

  void _handleNext() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _handleSubmit();
    }
  }

  void _handlePrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _handleSubmit({bool autoSubmit = false}) {
    if (!autoSubmit && _answers.length < _questions.length) {
      // Show warning dialog if incomplete
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Incomplete Quiz",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "You have answered ${_answers.length} of ${_questions.length} questions. Submit anyway?",
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _finalizeSubmission();
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: Color(0xFF4F46E5)),
              ),
            ),
          ],
        ),
      );
    } else {
      _finalizeSubmission();
    }
  }

  void _finalizeSubmission() {
    Fluttertoast.showToast(
      msg: "Quiz Submitted Successfully!",
      backgroundColor: Colors.green,
    );
    // Navigate to results or dashboard
    Navigator.pushReplacementNamed(context, '/student/my-quizzes');
  }

  void _handleExit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Exit Quiz?",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to exit? Your progress will be lost.",
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.of(context).pop(); // Actually exit the screen
            },
            child: const Text("Exit", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final isMCQ = question['type'] == 'mcq';
    final progress = (_currentIndex + 1) / _questions.length;
    final isAnswered = _answers.containsKey(question['id']);
    
    return PopScope(
      canPop: false, // Prevents default back button
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onWillPop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
            onPressed: _handleExit,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chapter 5: Photosynthesis",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "Question ${_currentIndex + 1} of ${_questions.length}",
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _timeLeft < 300
                    ? Colors.red.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    size: 14,
                    color: _timeLeft < 300 ? Colors.red : Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(_timeLeft),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft < 300
                          ? Colors.red
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Question ${_currentIndex + 1}",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isAnswered ? Colors.green : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Question Text
              FadeInRight(
                key: ValueKey(_currentIndex),
                duration: const Duration(milliseconds: 300),
                child: Text(
                  question['question'],
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Options / Input
              Expanded(
                child: isMCQ
                    ? ListView.separated(
                        itemCount: (question['options'] as List).length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final option = question['options'][index];
                          final isSelected = _answers[question['id']] == index;

                          return FadeInUp(
                            delay: Duration(milliseconds: index * 100),
                            child: GestureDetector(
                              onTap: () => _handleAnswer(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF4F46E5)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF4F46E5)
                                        : Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    if (!isSelected)
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.transparent,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade900,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : FadeInUp(
                        child: TextField(
                          maxLines: 8,
                          onChanged: (val) => _handleAnswer(val),
                          controller: TextEditingController(
                            text: _answers[question['id']] ?? '',
                          ),
                          decoration: InputDecoration(
                            hintText: "Type your answer here...",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),

              // Helper for Unanswered
              if (!isAnswered)
                FadeIn(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.alertCircle,
                          size: 18,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isMCQ
                                ? "Select one option to continue."
                                : "Write a detailed answer.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Navigation
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    if (_currentIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _handlePrevious,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            "Previous",
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (_currentIndex > 0) const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: isAnswered
                            ? _handleNext
                            : null, // Disable if not answered
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentIndex == _questions.length - 1
                              ? "Submit Quiz"
                              : "Next Question",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
