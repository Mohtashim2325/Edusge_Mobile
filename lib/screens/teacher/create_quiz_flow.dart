import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateQuizFlowScreen extends StatefulWidget {
  const CreateQuizFlowScreen({super.key});

  @override
  State<CreateQuizFlowScreen> createState() => _CreateQuizFlowScreenState();
}

class _CreateQuizFlowScreenState extends State<CreateQuizFlowScreen> {
  int _step = 1;
  bool _isLoading = false;

  // Form Data
  String _source = 'topic'; 
  String _title = '';
  String _topic = '';
  String _questionType = 'mcq';

  void _handleGenerate() {
    setState(() => _isLoading = true);
    
    // FIX: Print variables to remove "unused field" warnings
    debugPrint("Generating Quiz: $_title, Topic: $_topic");

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
          msg: "Quiz Generated Successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white
        );
        Navigator.pushReplacementNamed(context, '/teacher/quiz/edit', arguments: 1);
      }
    });
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
          onPressed: () {
            if (_step > 1) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create Quiz", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Step $_step of 3", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _step / 3,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FadeInRight(
          key: ValueKey(_step), 
          duration: const Duration(milliseconds: 300),
          child: _buildStepContent(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : () {
               if (_step < 3) {
                 setState(() => _step++);
               } else {
                 _handleGenerate();
               }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              disabledBackgroundColor: const Color(0xFF4F46E5).withOpacity(0.6),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(_step == 3 ? "Generate Quiz with AI" : "Continue", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose Quiz Source", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[900])),
            const SizedBox(height: 24),
            _SourceCard(
              title: "From Topic", 
              desc: "Enter a topic and let AI generate questions", 
              icon: LucideIcons.sparkles, 
              gradient: const [Colors.indigo, Colors.purple],
              isSelected: _source == 'topic',
              onTap: () => setState(() => _source = 'topic'),
            ),
            const SizedBox(height: 16),
            _SourceCard(
              title: "Upload Document", 
              desc: "Upload PDF, DOCX, or TXT file", 
              icon: LucideIcons.upload, 
              gradient: const [Colors.green, Colors.teal],
              isSelected: _source == 'document',
              onTap: () => setState(() => _source = 'document'),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quiz Details", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[900])),
            const SizedBox(height: 24),
            _buildTextField("Quiz Title", "e.g. Chapter 5 Quiz", (val) => _title = val),
            const SizedBox(height: 16),
            if (_source == 'topic') 
               _buildTextField("Topic", "e.g. Photosynthesis", (val) => _topic = val, maxLines: 3),
            if (_source == 'document')
               Container(
                 height: 150,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     // FIX: Changed from cloudUpload to uploadCloud
                     Icon(LucideIcons.uploadCloud, size: 40, color: Colors.grey.shade400),
                     const SizedBox(height: 8),
                     Text("Tap to upload document", style: GoogleFonts.inter(color: Colors.grey.shade600))
                   ],
                 ),
               )
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Configuration", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[900])),
            const SizedBox(height: 24),
            _buildRadioOption('mcq', 'Multiple Choice', 'Standard 4 options'),
            const SizedBox(height: 8),
            _buildRadioOption('qa', 'Written Answers', 'Open ended questions'),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String val, String title, String sub) {
    final isSelected = _questionType == val;
    return GestureDetector(
      onTap: () => setState(() => _questionType = val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(isSelected ? LucideIcons.checkCircle : LucideIcons.circle, color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade400, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey.shade900)),
                Text(sub, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  final List<Color> gradient;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceCard({required this.title, required this.desc, required this.icon, required this.gradient, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? gradient[0] : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(gradient: LinearGradient(colors: gradient), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[900])),
                  Text(desc, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}