import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/student_bottom_nav.dart';

class EnterQuizCodeScreen extends StatefulWidget {
  const EnterQuizCodeScreen({super.key});

  @override
  State<EnterQuizCodeScreen> createState() => _EnterQuizCodeScreenState();
}

class _EnterQuizCodeScreenState extends State<EnterQuizCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  void _handleCodeChange(String value) {
    // Force uppercase and limit to 6 chars
    String upperValue = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (upperValue.length <= 6) {
      _codeController.value = TextEditingValue(
        text: upperValue,
        selection: TextSelection.collapsed(offset: upperValue.length),
      );
    }
  }

  void _handleSubmit() {
    if (_codeController.text.length != 6) {
      Fluttertoast.showToast(msg: "Please enter a valid 6-character code", backgroundColor: Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API Validation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Mock success
        Fluttertoast.showToast(msg: "Quiz found! Starting...", backgroundColor: Colors.green);
        Navigator.pushReplacementNamed(context, '/student/take-quiz');
      }
    });
  }

  void _fillRecentCode(String code) {
    _codeController.text = code;
    Fluttertoast.showToast(msg: "Code filled. Tap 'Start Quiz' to continue.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text("Enter Quiz Code", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(LucideIcons.logIn, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text("Join a Quiz", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Enter the 6-character code shared by your teacher", textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey)),
                    const SizedBox(height: 32),
                    
                    TextField(
                      controller: _codeController,
                      onChanged: _handleCodeChange,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8),
                      decoration: InputDecoration(
                        hintText: "CODE",
                        hintStyle: GoogleFonts.inter(color: Colors.grey.shade300),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 24),
                        suffixIcon: const Padding(padding: EdgeInsets.only(right: 16), child: Icon(LucideIcons.keyboard, color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("${_codeController.text.length}/6 characters", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          disabledBackgroundColor: const Color(0xFF4F46E5).withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text("Start Quiz", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Align(alignment: Alignment.centerLeft, child: Text("Recent Quizzes", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800))),
            const SizedBox(height: 12),
            _buildRecentCode("ABC123", "Biology Quiz", "Dr. Smith", () => _fillRecentCode("ABC123")),
            const SizedBox(height: 12),
            _buildRecentCode("XYZ789", "Math Test", "Ms. Johnson", () => _fillRecentCode("XYZ789")),
          ],
        ),
      ),
      bottomNavigationBar: const StudentBottomNav(active: 'join'),
    );
  }

  Widget _buildRecentCode(String code, String title, String teacher, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
              child: Text(code, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(teacher, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}