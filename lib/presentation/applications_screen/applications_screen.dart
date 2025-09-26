import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/application_card_widget.dart';
import './widgets/application_stats_widget.dart';
import './widgets/application_filter_chips_widget.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  String _selectedFilter = 'all';
  List<Map<String, dynamic>> _applications = [];
  List<Map<String, dynamic>> _filteredApplications = [];

  final List<String> _tabs = ['Feed', 'Applications', 'Profile', 'More'];

  // Mock application data
  final List<Map<String, dynamic>> _mockApplications = [
    {
      "id": 1,
      "jobTitle": "Barista - Morning Shift",
      "company": "Campus Coffee Co.",
      "companyLogo":
          "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=100&h=100&fit=crop",
      "appliedDate": "2025-01-12",
      "status": "Under Review",
      "statusColor": Colors.orange,
      "location": "University District",
      "hourlyRate": "\$16/hr",
      "estimatedResponse": "2-3 days",
      "lastUpdate": "Updated 4 hours ago",
      "applicationScore": 85,
      "hasMessage": true,
      "canWithdraw": true,
      "timeline": [
        {"status": "Applied", "date": "Jan 12, 2025", "completed": true},
        {"status": "Under Review", "date": "Jan 13, 2025", "completed": true},
        {
          "status": "Interview Scheduled",
          "date": "Pending",
          "completed": false
        },
        {"status": "Decision", "date": "Pending", "completed": false},
      ]
    },
    {
      "id": 2,
      "jobTitle": "Math Tutor - Calculus",
      "company": "StudyBuddy Tutoring",
      "companyLogo":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=100&h=100&fit=crop",
      "appliedDate": "2025-01-11",
      "status": "Interview Scheduled",
      "statusColor": Colors.blue,
      "location": "Library Commons",
      "hourlyRate": "\$22/hr",
      "estimatedResponse": "Scheduled for Jan 15",
      "lastUpdate": "Interview scheduled yesterday",
      "applicationScore": 92,
      "hasMessage": true,
      "canWithdraw": false,
      "interviewDate": "Jan 15, 2025 at 2:00 PM",
      "timeline": [
        {"status": "Applied", "date": "Jan 11, 2025", "completed": true},
        {"status": "Under Review", "date": "Jan 11, 2025", "completed": true},
        {
          "status": "Interview Scheduled",
          "date": "Jan 12, 2025",
          "completed": true
        },
        {"status": "Decision", "date": "Pending", "completed": false},
      ]
    },
    {
      "id": 3,
      "jobTitle": "Social Media Assistant",
      "company": "Local Marketing Co.",
      "companyLogo":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=100&h=100&fit=crop",
      "appliedDate": "2025-01-10",
      "status": "Offer",
      "statusColor": Colors.green,
      "location": "Downtown",
      "hourlyRate": "\$20/hr",
      "estimatedResponse": "Response received",
      "lastUpdate": "Offer received 2 days ago",
      "applicationScore": 96,
      "hasMessage": true,
      "canWithdraw": false,
      "offerDetails": "Start date: Jan 20, 2025",
      "timeline": [
        {"status": "Applied", "date": "Jan 10, 2025", "completed": true},
        {"status": "Under Review", "date": "Jan 10, 2025", "completed": true},
        {
          "status": "Interview Scheduled",
          "date": "Jan 11, 2025",
          "completed": true
        },
        {"status": "Decision", "date": "Jan 12, 2025", "completed": true},
      ]
    },
    {
      "id": 4,
      "jobTitle": "Event Setup Assistant",
      "company": "Campus Events LLC",
      "companyLogo":
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=100&h=100&fit=crop",
      "appliedDate": "2025-01-09",
      "status": "Rejected",
      "statusColor": Colors.red,
      "location": "Student Center",
      "hourlyRate": "\$18/hr",
      "estimatedResponse": "Response received",
      "lastUpdate": "Response received 3 days ago",
      "applicationScore": 65,
      "hasMessage": false,
      "canWithdraw": false,
      "rejectionReason": "Position filled",
      "timeline": [
        {"status": "Applied", "date": "Jan 09, 2025", "completed": true},
        {"status": "Under Review", "date": "Jan 09, 2025", "completed": true},
        {
          "status": "Interview Scheduled",
          "date": "Not reached",
          "completed": false
        },
        {"status": "Decision", "date": "Jan 12, 2025", "completed": true},
      ]
    },
    {
      "id": 5,
      "jobTitle": "Research Assistant",
      "company": "Psychology Department",
      "companyLogo":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop",
      "appliedDate": "2025-01-13",
      "status": "Applied",
      "statusColor": Colors.grey,
      "location": "Science Building",
      "hourlyRate": "\$17/hr",
      "estimatedResponse": "3-5 days",
      "lastUpdate": "Application submitted today",
      "applicationScore": 88,
      "hasMessage": false,
      "canWithdraw": true,
      "timeline": [
        {"status": "Applied", "date": "Jan 13, 2025", "completed": true},
        {"status": "Under Review", "date": "Pending", "completed": false},
        {
          "status": "Interview Scheduled",
          "date": "Pending",
          "completed": false
        },
        {"status": "Decision", "date": "Pending", "completed": false},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _applications = List.from(_mockApplications);
      _filteredApplications = List.from(_applications);
      _isLoading = false;
    });
  }

  Future<void> _refreshApplications() async {
    HapticFeedback.mediumImpact();
    await _loadApplications();
  }

  void _filterApplications(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'all') {
        _filteredApplications = List.from(_applications);
      } else {
        _filteredApplications = _applications
            .where((app) =>
                (app['status'] as String).toLowerCase() == filter.toLowerCase())
            .toList();
      }
    });
  }

  void _showApplicationDetails(Map<String, dynamic> application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildApplicationDetailsSheet(application),
    );
  }

  void _withdrawApplication(int applicationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Withdraw Application'),
        content: Text(
            'Are you sure you want to withdraw this application? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _applications.removeWhere((app) => app['id'] == applicationId);
                _filteredApplications
                    .removeWhere((app) => app['id'] == applicationId);
              });
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Application withdrawn successfully')),
              );
            },
            child: Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Applications',
        variant: CustomAppBarVariant.back,
      ),
      body: Column(
        children: [
          CustomTabBar(
            tabs: _tabs,
            variant: CustomTabBarVariant.underline,
            initialIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/student-job-feed');
                  break;
                case 1:
                  // Already on Applications
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/profile-screen');
                  break;
                case 3:
                  // Navigate to More tab
                  break;
              }
            },
          ),
          ApplicationStatsWidget(
            applications: _applications,
          ),
          ApplicationFilterChipsWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: _filterApplications,
            applications: _applications,
          ),
          Expanded(
            child: _buildApplicationsList(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 1,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildApplicationsList() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => _buildSkeletonCard(),
      );
    }

    if (_filteredApplications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshApplications,
      child: ListView.builder(
        itemCount: _filteredApplications.length,
        itemBuilder: (context, index) {
          final application = _filteredApplications[index];
          return ApplicationCardWidget(
            applicationData: application,
            onTap: () => _showApplicationDetails(application),
            onWithdraw: application['canWithdraw'] as bool
                ? () => _withdrawApplication(application['id'] as int)
                : null,
            onMessage: application['hasMessage'] as bool
                ? () {
                    Navigator.pushNamed(context, '/messages-screen');
                  }
                : null,
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 2.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 1.5.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'work_outline',
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 3.h),
          Text(
            _selectedFilter == 'all'
                ? 'No Applications Yet'
                : 'No ${_selectedFilter.toLowerCase()} applications',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _selectedFilter == 'all'
                ? 'Start applying to jobs to track your progress here'
                : 'Try selecting a different filter to see more applications',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/student-job-feed');
            },
            icon: CustomIconWidget(
              iconName: 'work',
              size: 20,
              color: colorScheme.onPrimary,
            ),
            label: Text('Browse Jobs'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationDetailsSheet(Map<String, dynamic> application) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Application Details',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job info header
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color:
                          colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            application['companyLogo'] as String,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 12.w,
                              height: 12.w,
                              color: colorScheme.primaryContainer,
                              child: CustomIconWidget(
                                iconName: 'business',
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                application['jobTitle'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                application['company'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${application['location']} • ${application['hourlyRate']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Timeline
                  Text(
                    'Application Timeline',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...((application['timeline'] as List)
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final step = entry.value as Map<String, dynamic>;
                    final isCompleted = step['completed'] as bool;
                    final isLast =
                        index == (application['timeline'] as List).length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? colorScheme.primary
                                    : colorScheme.outline,
                                shape: BoxShape.circle,
                              ),
                              child: isCompleted
                                  ? Icon(
                                      Icons.check,
                                      color: colorScheme.onPrimary,
                                      size: 14,
                                    )
                                  : null,
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 4.h,
                                color: isCompleted
                                    ? colorScheme.primary
                                    : colorScheme.outline,
                                margin: EdgeInsets.symmetric(vertical: 1.h),
                              ),
                          ],
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['status'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isCompleted
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                step['date'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (!isLast) SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList()),
                  SizedBox(height: 4.h),
                  // Additional details based on status
                  if (application.containsKey('interviewDate')) ...[
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: Colors.blue,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Interview Scheduled',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  application['interviewDate'] as String,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  if (application.containsKey('offerDetails')) ...[
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'celebration',
                            color: Colors.green,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Offer Received!',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  application['offerDetails'] as String,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  if (application.containsKey('rejectionReason')) ...[
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: Colors.red,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Application Status',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Reason: ${application['rejectionReason']}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
