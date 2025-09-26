import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_dialog_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isInitializing = true;
  bool _hasError = false;
  String _loadingText = 'Initializing...';

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    "isAuthenticated": false,
    "userType": "student", // student, employer
    "hasCompletedOnboarding": false,
    "userId": "user_12345",
    "email": "student@university.edu",
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setSystemUIOverlay();
    _startInitialization();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _startInitialization() async {
    try {
      await _performInitializationTasks();

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitializing = false;
        });
        _showRetryDialog();
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    // Task 1: Check authentication status
    setState(() => _loadingText = 'Checking authentication...');
    await Future.delayed(const Duration(milliseconds: 800));

    // Task 2: Load user location permissions
    setState(() => _loadingText = 'Loading location services...');
    await Future.delayed(const Duration(milliseconds: 600));

    // Task 3: Fetch job categories
    setState(() => _loadingText = 'Fetching job categories...');
    await Future.delayed(const Duration(milliseconds: 700));

    // Task 4: Prepare cached data
    setState(() => _loadingText = 'Preparing cached data...');
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _loadingText = 'Almost ready...');
    await Future.delayed(const Duration(milliseconds: 400));
  }

  void _navigateToNextScreen() async {
    await _fadeController.forward();

    if (!mounted) return;

    // Navigation logic based on user state
    String nextRoute;

    if (_mockUserData["isAuthenticated"] == true) {
      // Authenticated users go to their respective dashboards
      if (_mockUserData["userType"] == "employer") {
        nextRoute = '/employer-dashboard';
      } else {
        nextRoute = '/student-job-feed';
      }
    } else if (_mockUserData["hasCompletedOnboarding"] == false) {
      // New users see onboarding (for now, redirect to job feed)
      nextRoute = '/student-job-feed';
    } else {
      // Returning non-authenticated users go to login (for now, redirect to job feed)
      nextRoute = '/student-job-feed';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RetryDialogWidget(
        title: 'Connection Error',
        message:
            'Unable to initialize the app. Please check your internet connection and try again.',
        onRetry: () {
          Navigator.of(context).pop();
          setState(() {
            _hasError = false;
            _isInitializing = true;
            _loadingText = 'Retrying...';
          });
          _startInitialization();
        },
        onCancel: () {
          Navigator.of(context).pop();
          SystemNavigator.pop();
        },
      ),
    );
  }

  void _onLogoAnimationComplete() {
    // Logo animation completed, continue with loading
    if (mounted && !_hasError) {
      setState(() {
        _isInitializing = true;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - _fadeAnimation.value,
            child: GradientBackgroundWidget(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: AnimatedLogoWidget(
                        onAnimationComplete: _onLogoAnimationComplete,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isInitializing && !_hasError) ...[
                          LoadingIndicatorWidget(
                            loadingText: _loadingText,
                            showProgress: true,
                          ),
                        ],
                        SizedBox(height: 8.h),
                        Text(
                          'Find Your Perfect Gig',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.8),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Connect • Apply • Earn',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.6),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}