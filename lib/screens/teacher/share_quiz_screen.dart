import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShareQuizScreen extends StatelessWidget {
  final String quizCode = "X7Y2P9"; // Mock code

  const ShareQuizScreen({super.key});

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: quizCode));
    Fluttertoast.showToast(msg: "Quiz code copied!", backgroundColor: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Gradient bg in React -> Solid/Subtle here for cleanliness
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(LucideIcons.arrowLeft, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Text("Share Quiz", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
              ),
              child: const Icon(LucideIcons.share2, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text("Quiz Code", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Students can enter this code to access the quiz", style: GoogleFonts.inter(color: Colors.grey)),
            
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
              child: Column(
                children: [
                  Text(
                    quizCode,
                    style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5), letterSpacing: 8),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _copyCode,
                    icon: const Icon(LucideIcons.copy, size: 18),
                    label: const Text("Copy Code"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Align(alignment: Alignment.centerLeft, child: Text("Share Via", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16))),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildShareButton(LucideIcons.mail, "Email", Colors.red),
                const SizedBox(width: 12),
                _buildShareButton(LucideIcons.messageSquare, "SMS", Colors.green),
                const SizedBox(width: 12),
                _buildShareButton(LucideIcons.qrCode, "QR Code", Colors.purple, onTap: () => Fluttertoast.showToast(msg: "Coming soon!")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap ?? () => Fluttertoast.showToast(msg: "Sharing via $label..."),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13))
            ],
          ),
        ),
      ),
    );
  }
}