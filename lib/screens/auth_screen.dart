//D:\flutterapps\edusage_mobile\lib\screens\auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/user_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool isLogin = true;
  bool showPassword = false;
  String? selectedRole; // ✅ Now nullable - safer
  bool _hasCheckedRole = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Only check once to avoid rebuild loops
    if (_hasCheckedRole) return;
    _hasCheckedRole = true;

    final args = ModalRoute.of(context)?.settings.arguments;

    // ✅ CRITICAL: Validate role argument
    if (args == null || args is! String || (args != 'teacher' && args != 'student')) {
      // Invalid or missing role - redirect immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/role-selection');
        }
      });
      return;
    }

    // ✅ Valid role received
    setState(() {
      selectedRole = args;
    });
  }

  Future<void> _handleSubmit() async {
    // ✅ Extra safety check
    if (selectedRole == null) {
      _toast("Please select a role first");
      Navigator.pushReplacementNamed(context, '/role-selection');
      return;
    }

    // Validation
    if (!isLogin && _nameController.text.trim().isEmpty) {
      _toast("Please enter your name");
      return;
    }
    if (_emailController.text.trim().isEmpty ||
        _passController.text.trim().isEmpty) {
      _toast("Please fill in all fields");
      return;
    }
    if (_passController.text.length < 6) {
      _toast("Password must be at least 6 characters");
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? error;

    // Auth
    if (isLogin) {
      error = await userProvider.signIn(
        _emailController.text.trim(),
        _passController.text.trim(),
      );
    } else {
      error = await userProvider.signUp(
        _emailController.text.trim(),
        _passController.text.trim(),
        _nameController.text.trim(),
        selectedRole!, // ✅ Safe now
      );
    }

    // Navigation
    if (!mounted) return;

    if (error == null && userProvider.user != null) {
      final role = userProvider.user!.role;

      if (role == 'teacher') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/teacher/dashboard',
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student/dashboard',
          (route) => false,
        );
      }
    } else if (error != null) {
      _toast(error);
    }
  }

  void _toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Don't render UI until role is validated
    if (selectedRole == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final roleLabel = selectedRole![0].toUpperCase() + selectedRole!.substring(1);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF2FF), Colors.white, Color(0xFFF5F3FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  child: Icon(
                    selectedRole == 'teacher'
                        ? LucideIcons.userCheck
                        : LucideIcons.graduationCap,
                    size: 64,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  child: Text(
                    isLogin
                        ? "$roleLabel Login"
                        : "Create $roleLabel Account",
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                if (!isLogin) ...[
                  _field(
                    _nameController,
                    "Full Name",
                    LucideIcons.user,
                    false,
                  ),
                  const SizedBox(height: 16),
                ],
                _field(
                  _emailController,
                  "Email",
                  LucideIcons.mail,
                  false,
                ),
                const SizedBox(height: 16),
                _field(
                  _passController,
                  "Password",
                  LucideIcons.lock,
                  true,
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Consumer<UserProvider>(
                      builder: (_, provider, __) {
                        return provider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isLogin ? "Sign In" : "Sign Up",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(
                    isLogin ? "Create Account" : "Sign In",
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/role-selection'),
                  child: Text(
                    "Change Role",
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    IconData icon,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                ),
                onPressed: () =>
                    setState(() => showPassword = !showPassword),
              )
            : null,
      ),
    );
  }
}