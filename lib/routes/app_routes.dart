import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/job_detail_screen/job_detail_screen.dart';
import '../presentation/messages_screen/messages_screen.dart';
import '../presentation/employer_dashboard/employer_dashboard.dart';
import '../presentation/post_job_screen/post_job_screen.dart';
import '../presentation/student_job_feed/student_job_feed.dart';
import '../presentation/applications_screen/applications_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String jobDetail = '/job-detail-screen';
  static const String messages = '/messages-screen';
  static const String employerDashboard = '/employer-dashboard';
  static const String postJob = '/post-job-screen';
  static const String studentJobFeed = '/student-job-feed';
  static const String applicationsScreen = '/applications-screen';
  static const String profileScreen = '/profile-screen';
  static const String settingsScreen = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    jobDetail: (context) => const JobDetailScreen(),
    messages: (context) => const MessagesScreen(),
    employerDashboard: (context) => const EmployerDashboard(),
    postJob: (context) => const PostJobScreen(),
    studentJobFeed: (context) => const StudentJobFeed(),
    applicationsScreen: (context) => const ApplicationsScreen(),
    profileScreen: (context) => const ProfileScreen(),
    settingsScreen: (context) => const SettingsScreen(),
  };
}
