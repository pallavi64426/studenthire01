import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/bottom_action_bar_widget.dart';
import './widgets/employer_rating_widget.dart';
import './widgets/job_description_widget.dart';
import './widgets/job_header_widget.dart';
import './widgets/job_info_cards_widget.dart';
import './widgets/similar_jobs_widget.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isApplied = false;
  bool _isLoading = false;

  // Mock data for the job detail
  final Map<String, dynamic> jobData = {
    "id": 1,
    "title": "Campus Event Photography Assistant",
    "companyName": "Creative Studios Inc",
    "companyLogo":
        "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=400&fit=crop",
    "companyBanner":
        "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&h=400&fit=crop",
    "hourlyRate": "\$18/hour",
    "location": "University Campus, Building A",
    "distance": "0.3 miles away",
    "schedule": "Weekends, 4-6 hours",
    "flexibility": "Flexible timing, event-based",
    "mapThumbnail":
        "https://images.unsplash.com/photo-1524661135-423995f22d0b?w=400&h=200&fit=crop",
    "skills": [
      "Photography",
      "Event Coverage",
      "Adobe Lightroom",
      "Communication"
    ],
    "karmaRequired": 50,
    "description":
        """Join our dynamic team as a Campus Event Photography Assistant! We're looking for a creative and reliable student to help capture memorable moments at various university events, including graduation ceremonies, sports events, club activities, and academic conferences.

This is a perfect opportunity for photography enthusiasts to build their portfolio while earning competitive wages. You'll work alongside experienced photographers and learn professional techniques in event photography, lighting, and post-processing.""",
    "responsibilities": [
      "Assist lead photographers during campus events",
      "Set up and manage photography equipment",
      "Capture candid moments and posed shots",
      "Basic photo editing and organization",
      "Maintain professional appearance and attitude"
    ],
    "requirements": [
      "Own DSLR or mirrorless camera",
      "Basic knowledge of photography principles",
      "Reliable transportation to various campus locations",
      "Weekend availability required",
      "Strong attention to detail"
    ],
    "status": "active", // active, expired, filled
    "postedDate": "2025-08-08",
    "applicationDeadline": "2025-08-20"
  };

  // Mock employer data
  final Map<String, dynamic> employerData = {
    "rating": 4.8,
    "reviewCount": 127,
    "reviews": [
      {
        "studentName": "Sarah Johnson",
        "rating": 5,
        "date": "2 weeks ago",
        "comment":
            "Amazing experience! The team was very professional and I learned so much about event photography. Great pay and flexible schedule."
      },
      {
        "studentName": "Mike Chen",
        "rating": 4,
        "date": "1 month ago",
        "comment":
            "Good opportunity for photography students. Equipment provided was top-notch. Only minor issue was occasional last-minute schedule changes."
      },
      {
        "studentName": "Emily Rodriguez",
        "rating": 5,
        "date": "2 months ago",
        "comment":
            "Perfect side gig for students! The lead photographer was very patient and taught me advanced techniques. Highly recommend!"
      }
    ]
  };

  // Mock similar jobs
  final List<Map<String, dynamic>> similarJobs = [
    {
      "id": 2,
      "title": "Social Media Content Creator",
      "companyName": "Digital Marketing Co",
      "companyLogo":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=400&fit=crop",
      "location": "Remote/Campus",
      "schedule": "Flexible hours",
      "hourlyRate": "\$15/hour",
      "distance": "0.5 miles away"
    },
    {
      "id": 3,
      "title": "Campus Tour Guide",
      "companyName": "University Admissions",
      "companyLogo":
          "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=400&fit=crop",
      "location": "Main Campus",
      "schedule": "Weekdays 2-4 PM",
      "hourlyRate": "\$14/hour",
      "distance": "0.1 miles away"
    },
    {
      "id": 4,
      "title": "Event Setup Assistant",
      "companyName": "Campus Events LLC",
      "companyLogo":
          "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=400&fit=crop",
      "location": "Student Center",
      "schedule": "Evenings & Weekends",
      "hourlyRate": "\$16/hour",
      "distance": "0.4 miles away"
    }
  ];

  // Mock user karma points
  final int userKarmaPoints = 75;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // Custom app bar with back button
              SliverAppBar(
                expandedHeight: 35.h,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'arrow_back_ios',
                      color: colorScheme.onSurface,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'more_vert',
                        color: colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () {
                        _showJobOptions(context);
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: JobHeaderWidget(jobData: jobData),
                ),
              ),

              // Job content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Job info cards
                    JobInfoCardsWidget(
                      jobData: jobData,
                      userKarmaPoints: userKarmaPoints,
                    ),

                    SizedBox(height: 3.h),

                    // Job description
                    JobDescriptionWidget(jobData: jobData),

                    SizedBox(height: 3.h),

                    // Company information
                    _buildCompanyInfoWidget(context),

                    SizedBox(height: 3.h),

                    // Safety guidelines
                    _buildSafetyGuidelinesWidget(context),

                    SizedBox(height: 3.h),

                    // Employer rating
                    EmployerRatingWidget(employerData: employerData),

                    SizedBox(height: 3.h),

                    // Similar jobs
                    SimilarJobsWidget(similarJobs: similarJobs),

                    // Bottom padding for action bar
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),

          // Bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomActionBarWidget(
              jobData: jobData,
              isApplied: _isApplied,
              onApply: _handleApply,
              onMessage: _handleMessage,
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Submitting Application...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoWidget(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'business',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'About ${jobData["companyName"]}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Creative Studios Inc is a leading photography and videography company specializing in event coverage and corporate communications. We work with universities, businesses, and organizations to capture their most important moments.',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildCompanyStatItem(
                context,
                icon: 'people',
                label: '50+ Students Hired',
              ),
              SizedBox(width: 4.w),
              _buildCompanyStatItem(
                context,
                icon: 'event',
                label: '200+ Events Covered',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyStatItem(
    BuildContext context, {
    required String icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: colorScheme.onPrimaryContainer,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyGuidelinesWidget(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: colorScheme.onTertiaryContainer,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Safety Guidelines',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '• Always work in well-lit, public areas\n• Keep emergency contacts readily available\n• Report any safety concerns immediately\n• Follow all campus safety protocols\n• Use provided safety equipment when required',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  void _handleApply() async {
    if (_isApplied) return;

    // Check karma points requirement
    if (userKarmaPoints < (jobData["karmaRequired"] as int)) {
      _showInsufficientKarmaDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isApplied = true;
    });

    _showApplicationSuccessDialog();
  }

  void _handleMessage() {
    Navigator.pushNamed(context, '/messages-screen');
  }

  void _showApplicationSuccessDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.onTertiaryContainer,
                  size: 32,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Application Sent!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Your application has been submitted successfully. The employer typically responds within 24 hours.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Great!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInsufficientKarmaDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'stars',
                  color: colorScheme.onErrorContainer,
                  size: 32,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Insufficient Karma Points',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'You need ${jobData["karmaRequired"]} Karma Points to apply for this job. You currently have $userKarmaPoints points.\n\nComplete more gigs to earn Karma Points!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showJobOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
              SizedBox(height: 3.h),
              _buildOptionItem(
                context,
                icon: 'report',
                title: 'Report Job',
                subtitle: 'Report inappropriate content',
                onTap: () {
                  Navigator.pop(context);
                  // Report functionality
                },
              ),
              _buildOptionItem(
                context,
                icon: 'block',
                title: 'Block Employer',
                subtitle: 'Hide jobs from this employer',
                onTap: () {
                  Navigator.pop(context);
                  // Block functionality
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: onTap,
    );
  }
}
