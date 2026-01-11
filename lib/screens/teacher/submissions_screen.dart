import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/teacher_bottom_nav.dart';

class SubmissionsScreen extends StatefulWidget {
  const SubmissionsScreen({super.key});

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  String filterStatus = 'all';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> submissions = [
    {
      'id': 1,
      'studentName': 'Sarah Johnson',
      'avatar': 'SJ',
      'quizTitle': 'Chapter 5: Photosynthesis',
      'status': 'pending',
      'submittedAt': '2h ago',
      'aiScore': 12,
      'questions': 15
    },
    {
      'id': 2,
      'studentName': 'Michael Chen',
      'avatar': 'MC',
      'quizTitle': 'Chapter 5: Photosynthesis',
      'status': 'pending',
      'submittedAt': '3h ago',
      'aiScore': 14,
      'questions': 15
    },
    {
      'id': 3,
      'studentName': 'Emma Williams',
      'avatar': 'EW',
      'quizTitle': 'World War II Quiz',
      'status': 'graded',
      'submittedAt': '1d ago',
      'finalScore': 18,
      'percentage': 90,
      'questions': 20
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = submissions.where((s) {
      final matchesSearch = s['studentName'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                            s['quizTitle'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = filterStatus == 'all' || s['status'] == filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Using BottomNav instead
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Submissions", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            Text("${submissions.where((s) => s['status'] == 'pending').length} pending grading", 
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search student or quiz...",
                    prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Tabs
                Row(
                  children: ['all', 'pending', 'graded'].map((status) {
                    final isSelected = filterStatus == status;
                    return GestureDetector(
                      onTap: () => setState(() => filterStatus = status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 11, 
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey.shade600
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sub = filteredList[index];
                final isPending = sub['status'] == 'pending';

                return FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/teacher/grade', arguments: sub['id']),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                        border: isPending ? Border.all(color: Colors.orange.withOpacity(0.3)) : null,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.2), blurRadius: 8)],
                                ),
                                alignment: Alignment.center,
                                child: Text(sub['avatar'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(sub['studentName'], style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                                        _buildStatusBadge(isPending),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(sub['quizTitle'], style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(LucideIcons.clock, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(sub['submittedAt'], style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              if (isPending)
                                Text("AI Score: ${sub['aiScore']}/${sub['questions']}", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800))
                              else
                                Text("${sub['percentage']}% (${sub['finalScore']}/${sub['questions']})", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          if (isPending) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/teacher/grade', arguments: sub['id']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                ),
                                child: const Text("Grade Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const TeacherBottomNav(active: 'grading'),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isPending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPending ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isPending ? Colors.orange.shade200 : Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(isPending ? LucideIcons.alertCircle : LucideIcons.checkCircle, size: 12, color: isPending ? Colors.orange.shade800 : Colors.green.shade800),
          const SizedBox(width: 4),
          Text(isPending ? "Pending" : "Graded", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: isPending ? Colors.orange.shade800 : Colors.green.shade800)),
        ],
      ),
    );
  }
}