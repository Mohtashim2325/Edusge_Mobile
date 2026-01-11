//D:\flutterapps\edusage_mobile\lib\main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// --- General / Auth Screens ---
import 'screens/intro_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/role_selection_screen.dart';

// --- Shared Screens ---
import 'screens/settings_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/chatbot_screen.dart';

// --- Teacher Screens ---
import 'screens/teacher/teacher_dashboard_screen.dart';
import 'screens/teacher/quiz_list_screen.dart';
import 'screens/teacher/create_quiz_flow.dart';
import 'screens/teacher/edit_quiz_screen.dart';
import 'screens/teacher/share_quiz_screen.dart';
import 'screens/teacher/submissions_screen.dart';
import 'screens/teacher/grade_submission_screen.dart';
import 'screens/teacher/slide_workspace_screen.dart';
import 'screens/teacher/research_notes_screen.dart';
import 'screens/teacher/teacher_profile_screen.dart';

// --- Student Screens ---
import 'screens/student/student_dashboard_screen.dart';
import 'screens/student/enter_quiz_code_screen.dart';
import 'screens/student/take_quiz_screen.dart';
import 'screens/student/my_quizzes_screen.dart';
import 'screens/student/quiz_results_screen.dart';
import 'screens/student/student_profile_screen.dart';

// --- Providers ---
import 'providers/user_provider.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const EduSageApp(),
    ),
  );
}

class EduSageApp extends StatelessWidget {
  const EduSageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'EduSage',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF9FAFB),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F46E5),
            primary: const Color(0xFF4F46E5),
            secondary: const Color(0xFF9333EA),
            background: const Color(0xFFF9FAFB),
            surface: Colors.white,
          ),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),

        //  CORRECTED: Use StreamBuilder for real-time auth state
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // 1. Still loading Firebase auth state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4F46E5),
                  ),
                ),
              );
            }

            // 2. User is logged in
            if (snapshot.hasData && snapshot.data != null) {
              final user = snapshot.data!;
              
              // Fetch user role from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    );
                  }

                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    final role = userData['role'];

                    // Navigate to correct dashboard
                    if (role == 'teacher') {
                      return const TeacherDashboardScreen();
                    } else if (role == 'student') {
                      return const StudentDashboardScreen();
                    }
                  }

                  // User exists but no role - go to role selection
                  return const RoleSelectionScreen();
                },
              );
            }

            // 3. No user logged in - show intro screen
            return const IntroScreen();
          },
        ),

        routes: {
          '/intro': (context) => const IntroScreen(),
          '/onboarding': (context) => OnboardingScreen(
            onComplete: () {
              Navigator.pushReplacementNamed(context, '/role-selection');
            },
          ),
          '/role-selection': (context) => const RoleSelectionScreen(),
          '/auth': (context) => const AuthScreen(),

          // Dashboards
          '/teacher/dashboard': (context) => const TeacherDashboardScreen(),
          '/student/dashboard': (context) => const StudentDashboardScreen(),

          // Shared
          '/settings': (context) => const SettingsScreen(),
          '/help': (context) => const HelpSupportScreen(),
          '/chatbot': (context) => const ChatbotScreen(),

          // Teacher Routes
          '/teacher/quizzes': (context) => const QuizListScreen(),
          '/teacher/quiz/create': (context) => const CreateQuizFlowScreen(),
          '/teacher/quiz/edit': (context) => const EditQuizScreen(),
          '/teacher/quiz/share': (context) => const ShareQuizScreen(),
          '/teacher/submissions': (context) => const SubmissionsScreen(),
          '/teacher/grade': (context) => const GradeSubmissionScreen(),
          '/teacher/slides': (context) => const SlideWorkspaceScreen(),
          '/teacher/research': (context) => const ResearchNotesScreen(),
          '/teacher/profile': (context) => const TeacherProfileScreen(),

          // Student Routes
          '/student/enter-code': (context) => const EnterQuizCodeScreen(),
          '/student/take-quiz': (context) => const TakeQuizScreen(),
          '/student/my-quizzes': (context) => const MyQuizzesScreen(),
          '/student/quiz-results': (context) => const QuizResultsScreen(),
          '/student/profile': (context) => const StudentProfileScreen(),
        },
      ),
    );
  }
}