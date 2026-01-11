import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';


class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, String>> faqs = [
    {
      'q': 'How do I create a quiz?',
      'a': 'Go to the dashboard, tap "Create Quiz", choose your source (topic, chapter, or document), and let AI generate it.'
    },
    {
      'q': 'How do students join?',
      'a': 'Share the 6-character quiz code. Students enter this code in the "Join" tab of their app.'
    },
    {
      'q': 'Is my data secure?',
      'a': 'Yes, we use industry-standard encryption to protect your data.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = faqs.where((f) => 
      f['q']!.toLowerCase().contains(_query.toLowerCase()) || 
      f['a']!.toLowerCase().contains(_query.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Help & Support", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _query = val),
                decoration: const InputDecoration(
                  hintText: "Search for help...",
                  prefixIcon: Icon(LucideIcons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_query.isEmpty) ...[
              Text("Browse Topics", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
              const SizedBox(height: 12),
              _buildTopicCard(LucideIcons.bookOpen, "Getting Started", "Learn the basics", () {}),
              const SizedBox(height: 12),
              _buildTopicCard(LucideIcons.messageCircle, "AI Assistant", "Tips for using AI", () => Navigator.pushNamed(context, '/chatbot')),
              const SizedBox(height: 12),
              _buildTopicCard(LucideIcons.helpCircle, "Troubleshooting", "Common fixes", () {}),
              const SizedBox(height: 32),
            ],

            Text(_query.isEmpty ? "Frequently Asked Questions" : "Search Results", 
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800)
            ),
            const SizedBox(height: 12),
            
            if (filteredFaqs.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No results found"))),

            ...filteredFaqs.map((faq) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(faq['q']!, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(faq['a']!, style: GoogleFonts.inter(color: Colors.grey.shade700, height: 1.5)),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 32),
            if (_query.isEmpty) ...[
              Text("Contact Support", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildContactBtn(LucideIcons.mail, "Email", Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildContactBtn(LucideIcons.phone, "Phone", Colors.green)),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(IconData icon, String title, String sub, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF4F46E5), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(sub, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: Colors.grey.shade400, size: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildContactBtn(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}