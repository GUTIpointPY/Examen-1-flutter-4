import 'package:flutter/material.dart';
import '../widgets/custom_logo.dart';
import '../widgets/custom_text_field.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Control structure for animation
  late final AnimationController _entranceController;
  
  // Staggered animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _formOpacity;
  late final Animation<Offset> _formSlide;
  late final Animation<double> _buttonOpacity;
  late final Animation<double> _footerOpacity;

  bool _isSignIn = true;
  bool _isLoading = false;
  double _buttonScale = 1.0;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Staggered sequence configurations
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeIn),
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    // Kick off entrance animation sequence
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleFormMode() {
    setState(() {
      _isSignIn = !_isSignIn;
      // Reset form validations
      _formKey.currentState?.reset();
      // Clear inputs
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Secure transition with Hero logo
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: const DashboardPage(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // soft grey background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Subtle top title to match screen tag if necessary
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Text(
                                'login L\'amor',
                                style: TextStyle(
                                  color: const Color(0xFF1E293B).withValues(alpha: 0.25),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          // Logo (staggered scale & opacity)
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _logoOpacity.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: Hero(
                                    tag: 'login-logo',
                                    child: const CustomLogo(size: 110),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),

                          // Header titles (staggered slide & opacity)
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _titleOpacity.value,
                                child: Transform.translate(
                                  offset: _titleSlide.value * 100, // amplify motion
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Column(
                                      key: ValueKey<bool>(_isSignIn),
                                      children: [
                                        Text(
                                          _isSignIn ? 'Welcome Back' : 'Create Account',
                                          style: const TextStyle(
                                            color: Color(0xFF1E293B),
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _isSignIn
                                              ? 'Sign in to your private account'
                                              : 'Sign up to start your private account',
                                          style: const TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 36),

                          // Form Container Card
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _formOpacity.value,
                                child: Transform.translate(
                                  offset: _formSlide.value * 100,
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 350),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  transitionBuilder: (child, animation) {
                                    final isSignInWidget = child.key == const ValueKey('signin_form');
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(isSignInWidget ? -0.06 : 0.06, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: _isSignIn ? _buildSignInForm() : _buildSignUpForm(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Submit Button (staggered fade & custom scale action)
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _buttonOpacity.value,
                                child: child,
                              );
                            },
                            child: GestureDetector(
                              onTapDown: (_) {
                                if (!_isLoading) {
                                  setState(() => _buttonScale = 0.97);
                                }
                              },
                              onTapUp: (_) {
                                if (!_isLoading) {
                                  setState(() => _buttonScale = 1.0);
                                }
                              },
                              onTapCancel: () {
                                setState(() => _buttonScale = 1.0);
                              },
                              onTap: _isLoading ? null : _handleSubmit,
                              child: AnimatedScale(
                                scale: _buttonScale,
                                duration: const Duration(milliseconds: 120),
                                curve: Curves.easeOutBack,
                                child: Container(
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE91E63), // hot pink
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFE91E63).withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 200),
                                            child: Text(
                                              _isSignIn ? 'Sign In' : 'Sign Up',
                                              key: ValueKey<bool>(_isSignIn),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Alternative option navigation (Create Account / Sign In)
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _buttonOpacity.value,
                                child: child,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isSignIn ? "Don't have an account? " : "Already have an account? ",
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _toggleFormMode,
                                  child: const Text(
                                    'Create one',
                                    style: TextStyle(
                                      color: Color(0xFFE91E63),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Footer guaranteed billing (staggered fade)
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _footerOpacity.value,
                                child: child,
                              );
                            },
                            child: const Text(
                              'DISCRETE BILLING & SECURE CONNECTION\nGUARANTEED',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF94A3B8), // slate-400
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      key: const ValueKey('signin_form'),
      children: [
        CustomTextField(
          label: 'Email Address',
          placeholder: 'name@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please enter your email';
            if (!val.contains('@')) return 'Please enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Password',
          placeholder: '........',
          controller: _passwordController,
          obscureText: true,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please enter your password';
            if (val.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      key: const ValueKey('signup_form'),
      children: [
        CustomTextField(
          label: 'Email Address',
          placeholder: 'name@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please enter your email';
            if (!val.contains('@')) return 'Please enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Password',
          placeholder: '........',
          controller: _passwordController,
          obscureText: true,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please enter your password';
            if (val.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Confirm Password',
          placeholder: '........',
          controller: _confirmPasswordController,
          obscureText: true,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please confirm your password';
            if (val != _passwordController.text) return 'Passwords do not match';
            return null;
          },
        ),
      ],
    );
  }
}
