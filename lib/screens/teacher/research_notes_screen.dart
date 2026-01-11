import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/teacher_bottom_nav.dart';

class ResearchNotesScreen extends StatefulWidget {
  const ResearchNotesScreen({super.key});

  @override
  State<ResearchNotesScreen> createState() => _ResearchNotesScreenState();
}

class _ResearchNotesScreenState extends State<ResearchNotesScreen> {
  // State to toggle views
  Map<String, dynamic>? selectedDoc;
  
  final List<Map<String, dynamic>> docs = [
    {'id': 1, 'name': 'Biology Chapter 5.pdf', 'type': 'PDF', 'size': '2.3 MB', 'pages': 15},
    {'id': 2, 'name': 'Physics Notes.pdf', 'type': 'PDF', 'size': '1.8 MB', 'pages': 22},
  ];

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
            if (selectedDoc != null) {
              setState(() => selectedDoc = null);
            } else {
              Navigator.pushReplacementNamed(context, '/teacher/dashboard');
            }
          },
        ),
        title: Text(selectedDoc == null ? "Research & Notes" : selectedDoc!['name'], style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          if (selectedDoc == null)
            IconButton(onPressed: () {}, icon: const Icon(LucideIcons.upload, color: Color(0xFF4F46E5)))
        ],
      ),
      body: selectedDoc == null ? _buildDocList() : _buildChatInterface(),
      bottomNavigationBar: const TeacherBottomNav(active: ''),
    );
  }

  Widget _buildDocList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Upload Card
        if (docs.isEmpty) 
          Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(LucideIcons.fileText, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text("No docs yet"),
                ElevatedButton(onPressed: () {}, child: const Text("Upload"))
              ],
            ),
          )
        else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(LucideIcons.bookOpen, color: Color(0xFF4F46E5)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("AI-Powered Research", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
                      Text("Upload docs and ask questions.", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4338CA))),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...docs.map((doc) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)), child: const Icon(LucideIcons.fileText, color: Colors.red)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc['name'], style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          Text("${doc['type']} • ${doc['size']} • ${doc['pages']} pages", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.trash2, size: 18, color: Colors.red)
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => selectedDoc = doc),
                        icon: const Icon(LucideIcons.messageSquare, size: 16, color: Colors.white),
                        label: const Text("Ask AI"),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(onPressed: () {}, child: const Text("View")),
                    )
                  ],
                )
              ],
            ),
          ))
        ]
      ],
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ChatBubble(role: 'ai', text: "I've loaded '${selectedDoc!['name']}'. What would you like to know?"),
              const SizedBox(height: 12),
              const _ChatBubble(role: 'user', text: "Summarize the key points."),
              const SizedBox(height: 12),
              const _ChatBubble(role: 'ai', text: "Based on the document, the key points are:\n1. Photosynthesis occurs in chloroplasts.\n2. Light-dependent reactions create ATP."),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Ask a question...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(backgroundColor: const Color(0xFF4F46E5), child: IconButton(onPressed: () {}, icon: const Icon(LucideIcons.send, color: Colors.white, size: 18)))
            ],
          ),
        )
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String role;
  final String text;
  const _ChatBubble({required this.role, required this.text});

  @override
  Widget build(BuildContext context) {
    final isUser = role == 'user';
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[const CircleAvatar(radius: 16, backgroundColor: Colors.purple, child: Icon(LucideIcons.sparkles, size: 14, color: Colors.white)), const SizedBox(width: 8)],
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF4F46E5) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isUser ? null : Border.all(color: Colors.grey.shade200),
            ),
            child: Text(text, style: GoogleFonts.inter(color: isUser ? Colors.white : Colors.black87)),
          ),
        ),
      ],
    );
  }
}