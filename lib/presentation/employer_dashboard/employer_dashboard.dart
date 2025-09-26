import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/analytics_card_widget.dart';
import './widgets/job_card_widget.dart';
import './widgets/recent_application_widget.dart';
import './widgets/stats_card_widget.dart';

class EmployerDashboard extends StatefulWidget {
  const EmployerDashboard({super.key});

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for employer dashboard
  final List<Map<String, dynamic>> _activeJobs = [
    {
      "id": 1,
      "title": "Campus Event Photography Assistant",
      "postedDate": "2 days ago",
      "applicantCount": 12,
      "viewCount": 45,
      "status": "active",
      "hasNewApplications": true,
    },
    {
      "id": 2,
      "title": "Social Media Content Creator",
      "postedDate": "5 days ago",
      "applicantCount": 8,
      "viewCount": 32,
      "status": "active",
      "hasNewApplications": false,
    },
    {
      "id": 3,
      "title": "Weekend Barista Position",
      "postedDate": "1 week ago",
      "applicantCount": 15,
      "viewCount": 67,
      "status": "paused",
      "hasNewApplications": false,
    },
  ];

  final List<Map<String, dynamic>> _recentApplications = [
    {
      "id": 1,
      "studentName": "Sarah Johnson",
      "jobTitle": "Campus Event Photography Assistant",
      "appliedTime": "2 hours ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "matchScore": 92.0,
      "skills": ["Photography", "Event Management", "Adobe Photoshop"],
      "status": "pending",
    },
    {
      "id": 2,
      "studentName": "Michael Chen",
      "jobTitle": "Social Media Content Creator",
      "appliedTime": "4 hours ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "matchScore": 87.0,
      "skills": ["Content Creation", "Instagram", "Video Editing"],
      "status": "pending",
    },
    {
      "id": 3,
      "studentName": "Emma Rodriguez",
      "jobTitle": "Weekend Barista Position",
      "appliedTime": "1 day ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "matchScore": 78.0,
      "skills": ["Customer Service", "Coffee Making", "POS Systems"],
      "status": "accepted",
    },
  ];

  final List<Map<String, dynamic>> _analyticsData = [
    {"label": "Mon", "value": 3},
    {"label": "Tue", "value": 5},
    {"label": "Wed", "value": 2},
    {"label": "Thu", "value": 7},
    {"label": "Fri", "value": 4},
    {"label": "Sat", "value": 6},
    {"label": "Sun", "value": 3},
  ];

  final List<Map<String, dynamic>> _pieChartData = [
    {"label": "Viewed", "value": 45},
    {"label": "Applied", "value": 25},
    {"label": "Interviewed", "value": 15},
    {"label": "Hired", "value": 15},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: "TechStart Solutions",
        variant: CustomAppBarVariant.profile,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'verified',
                  size: 16,
                  color: colorScheme.tertiary,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Verified',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications',
              size: 24,
              color: colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pushNamed(context, '/messages-screen'),
          ),
        ],
      ),
      body: Column(
        children: [
          CustomTabBar(
            tabs: const ['Dashboard', 'Post Job', 'Messages', 'Profile'],
            variant: CustomTabBarVariant.underline,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/post-job-screen');
              } else if (index == 2) {
                Navigator.pushNamed(context, '/messages-screen');
              }
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    _buildQuickStats(context),
                    SizedBox(height: 3.h),
                    _buildSectionHeader(
                        context, 'Active Job Postings', 'View All'),
                    SizedBox(height: 1.h),
                    _buildActiveJobsList(context),
                    SizedBox(height: 3.h),
                    _buildSectionHeader(
                        context, 'Recent Applications', 'View All'),
                    SizedBox(height: 1.h),
                    _buildRecentApplicationsList(context),
                    SizedBox(height: 3.h),
                    _buildSectionHeader(context, 'Hiring Analytics', ''),
                    SizedBox(height: 1.h),
                    _buildAnalyticsSection(context),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/post-job-screen'),
        icon: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: Colors.white,
        ),
        label: Text(
          'Post New Job',
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 1,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: StatsCardWidget(
              title: 'Active Jobs',
              value: '3',
              subtitle: '+1 this week',
              iconName: 'work',
              iconColor: colorScheme.primary,
              trend: '+25%',
              isPositiveTrend: true,
              onTap: () {},
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: StatsCardWidget(
              title: 'Applications',
              value: '35',
              subtitle: '12 new today',
              iconName: 'people',
              iconColor: colorScheme.tertiary,
              trend: '+18%',
              isPositiveTrend: true,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, String action) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          if (action.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: Text(
                action,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveJobsList(BuildContext context) {
    return Column(
      children: _activeJobs.map((job) {
        return JobCardWidget(
          jobData: job,
          onTap: () => Navigator.pushNamed(context, '/job-detail-screen'),
          onEdit: () => _handleJobAction('edit', job),
          onPause: () => _handleJobAction('pause', job),
          onViewApplications: () => _handleJobAction('applications', job),
          onDuplicate: () => _handleJobAction('duplicate', job),
        );
      }).toList(),
    );
  }

  Widget _buildRecentApplicationsList(BuildContext context) {
    return Column(
      children: _recentApplications.take(2).map((application) {
        return RecentApplicationWidget(
          applicationData: application,
          onViewProfile: () => _handleApplicationAction('profile', application),
          onMessage: () => Navigator.pushNamed(context, '/messages-screen'),
          onAccept: () => _handleApplicationAction('accept', application),
          onDecline: () => _handleApplicationAction('decline', application),
        );
      }).toList(),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return Column(
      children: [
        AnalyticsCardWidget(
          title: 'Weekly Applications',
          chartData: _analyticsData,
          chartType: 'line',
          onTap: () {},
        ),
        SizedBox(height: 2.h),
        AnalyticsCardWidget(
          title: 'Hiring Funnel',
          chartData: _pieChartData,
          chartType: 'pie',
          onTap: () {},
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Update application counts and metrics
      for (var job in _activeJobs) {
        if (job['hasNewApplications'] == true) {
          job['applicantCount'] = (job['applicantCount'] as int) + 1;
        }
      }
    });
  }

  void _handleJobAction(String action, Map<String, dynamic> job) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (action) {
      case 'edit':
        Navigator.pushNamed(context, '/post-job-screen');
        break;
      case 'pause':
        setState(() {
          job['status'] = job['status'] == 'active' ? 'paused' : 'active';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Job ${job['status'] == 'active' ? 'resumed' : 'paused'} successfully'),
            backgroundColor: colorScheme.tertiary,
          ),
        );
        break;
      case 'applications':
        Navigator.pushNamed(context, '/student-job-feed');
        break;
      case 'duplicate':
        Navigator.pushNamed(context, '/post-job-screen');
        break;
    }
  }

  void _handleApplicationAction(
      String action, Map<String, dynamic> application) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (action) {
      case 'profile':
        Navigator.pushNamed(context, '/student-job-feed');
        break;
      case 'accept':
        setState(() {
          application['status'] = 'accepted';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application accepted successfully'),
            backgroundColor: colorScheme.tertiary,
          ),
        );
        break;
      case 'decline':
        setState(() {
          application['status'] = 'declined';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application declined'),
            backgroundColor: colorScheme.error,
          ),
        );
        break;
    }
  }
}
