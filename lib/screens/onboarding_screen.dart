//D:\flutterapps\edusage_mobile\lib\screens\onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> slides = [
    {
      'icon': LucideIcons.brain,
      'title': 'AI-Powered Learning',
      'desc': 'Leverage advanced AI to create quizzes, slides, and study materials instantly.',
      'gradient': [Colors.blue, Colors.cyan],
    },
    {
      'icon': LucideIcons.fileText,
      'title': 'Smart Quizzes',
      'desc': 'Generate custom quizzes from any topic, chapter, or uploaded document.',
      'gradient': [Colors.purple, Colors.pink],
    },
    {
      'icon': LucideIcons.graduationCap,
      'title': 'Teachers & Students',
      'desc': 'Seamlessly connect classrooms with advanced grading and progress tracking.',
      'gradient': [Colors.orange, Colors.deepOrange],
    },
    {
      'icon': LucideIcons.messageSquare,
      'title': 'AI Assistant',
      'desc': 'Your personal tutor available 24/7 to answer any educational query.',
      'gradient': [Colors.green, Colors.teal],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return FadeInRight(
                    duration: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: slide['gradient'],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (slide['gradient'][0] as Color).withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                )
                              ],
                            ),
                            child: Icon(slide['icon'], size: 70, color: Colors.white),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            slide['title'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 28, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.grey[900]
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            slide['desc'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16, 
                              height: 1.5, 
                              color: Colors.grey[600]
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom Controls
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentIndex == index ? 32 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? const Color(0xFF4F46E5) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // Buttons
                  Row(
                    children: [
                      if (_currentIndex < slides.length - 1)
                        TextButton(
                          onPressed: widget.onComplete,
                          child: Text(
                            "Skip", 
                            style: GoogleFonts.inter(
                              color: Colors.grey[500], 
                              fontWeight: FontWeight.w600
                            )
                          ),
                        ),
                      if (_currentIndex < slides.length - 1) const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentIndex < slides.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300), 
                              curve: Curves.easeInOut
                            );
                          } else {
                            widget.onComplete();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: _currentIndex == slides.length - 1 ? 48 : 24, 
                            vertical: 16
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                          shadowColor: const Color(0xFF4F46E5).withOpacity(0.4),
                        ),
                        child: Text(
                          _currentIndex == slides.length - 1 ? "Get Started" : "Next",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

