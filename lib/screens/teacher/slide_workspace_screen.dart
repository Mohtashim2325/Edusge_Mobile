import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/teacher_bottom_nav.dart';

class SlideWorkspaceScreen extends StatelessWidget {
  const SlideWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(LucideIcons.arrowLeft, color: Colors.black), onPressed: () => Navigator.pushReplacementNamed(context, '/teacher/dashboard')),
        title: Text("Slide Workspace", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () => _showCreateDialog(context), icon: const Icon(LucideIcons.plus, color: Color(0xFF4F46E5)))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _PresentationCard(title: "Intro to Photosynthesis", subject: "Biology", count: 12, gradient: [Colors.blue, Colors.cyan]),
          SizedBox(height: 16),
          _PresentationCard(title: "World War II Timeline", subject: "History", count: 18, gradient: [Colors.purple, Colors.pink]),
        ],
      ),
      bottomNavigationBar: const TeacherBottomNav(active: ''),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("New Presentation", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(hintText: "Title", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 16),
            TextField(decoration: InputDecoration(hintText: "Topic", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Generating slides...");
            }, 
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), foregroundColor: Colors.white),
            child: const Text("Generate")
          )
        ],
      ),
    );
  }
}

class _PresentationCard extends StatelessWidget {
  final String title;
  final String subject;
  final int count;
  final List<Color> gradient;

  const _PresentationCard({required this.title, required this.subject, required this.count, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Icon(LucideIcons.presentation, size: 48, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("$subject • $count slides", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(LucideIcons.edit2, size: 18, color: Colors.grey))
              ],
            ),
          )
        ],
      ),
    );
  }
}