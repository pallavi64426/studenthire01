import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_stats_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/skills_showcase_widget.dart';
import './widgets/achievements_gallery_widget.dart';
import './widgets/reviews_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isEditMode = false;
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _tabs = ['Feed', 'Applications', 'Profile', 'More'];

  // Mock profile data
  Map<String, dynamic> _profileData = {
    "userId": "student_123",
    "name": "Sarah Johnson",
    "university": "State University",
    "major": "Computer Science",
    "year": "Junior",
    "gpa": "3.8",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "karmaPoints": 245,
    "karmaLevel": "Rising Star",
    "nextLevelPoints": 255,
    "email": "sarah.johnson@university.edu",
    "phone": "+1 (555) 123-4567",
    "location": "Campus Area",
    "joinedDate": "2024-09-15",
    "verified": true,
    "quickStats": {
      "totalJobsCompleted": 12,
      "averageRating": 4.8,
      "totalEarnings": 2840,
      "hoursWorked": 156
    },
    "skills": [
      {"name": "Customer Service", "level": 90, "verified": true},
      {"name": "Data Entry", "level": 85, "verified": true},
      {"name": "Social Media", "level": 88, "verified": false},
      {"name": "Tutoring", "level": 92, "verified": true},
      {"name": "Event Planning", "level": 75, "verified": false},
      {"name": "Photography", "level": 80, "verified": false}
    ],
    "education": {
      "university": "State University",
      "major": "Computer Science",
      "year": "Junior",
      "gpa": "3.8",
      "graduationYear": "2026",
      "relevantCourses": [
        "Data Structures & Algorithms",
        "Database Management",
        "Web Development",
        "Business Communications"
      ]
    },
    "workExperience": [
      {
        "jobTitle": "Campus Tour Guide",
        "company": "University Admissions",
        "duration": "Sep 2024 - Present",
        "rating": 4.9,
        "description":
            "Lead prospective students and families on campus tours, providing information about academic programs and student life."
      },
      {
        "jobTitle": "Math Tutor",
        "company": "StudyBuddy Tutoring",
        "duration": "Feb 2024 - Aug 2024",
        "rating": 4.8,
        "description":
            "Provided one-on-one tutoring for calculus and statistics students, helping improve grades by an average of 15%."
      },
      {
        "jobTitle": "Social Media Assistant",
        "company": "Local Coffee Shop",
        "duration": "Jun 2024 - Aug 2024",
        "rating": 4.7,
        "description":
            "Managed Instagram and TikTok accounts, creating engaging content that increased follower count by 40%."
      }
    ],
    "achievements": [
      {
        "id": "first_job",
        "title": "First Job Complete",
        "description": "Successfully completed your first StudentHire gig",
        "icon": "work",
        "color": Colors.blue,
        "unlocked": true,
        "unlockedDate": "2024-02-20"
      },
      {
        "id": "top_performer",
        "title": "Top Performer",
        "description": "Maintained a 4.8+ rating for 10+ jobs",
        "icon": "star",
        "color": Colors.orange,
        "unlocked": true,
        "unlockedDate": "2024-07-15"
      },
      {
        "id": "reliable_worker",
        "title": "Reliable Worker",
        "description": "Perfect attendance for 5 consecutive jobs",
        "icon": "schedule",
        "color": Colors.green,
        "unlocked": true,
        "unlockedDate": "2024-09-10"
      },
      {
        "id": "karma_master",
        "title": "Karma Master",
        "description": "Reach 500 karma points",
        "icon": "trending_up",
        "color": Colors.purple,
        "unlocked": false,
        "progress": 49 // 245/500 = 49%
      },
      {
        "id": "mentor",
        "title": "Mentor",
        "description": "Help 10 new students get their first job",
        "icon": "school",
        "color": Colors.teal,
        "unlocked": false,
        "progress": 30
      }
    ],
    "reviews": [
      {
        "id": 1,
        "employerName": "Campus Coffee Co.",
        "employerAvatar":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face",
        "rating": 5,
        "jobTitle": "Barista",
        "date": "2025-01-10",
        "comment":
            "Sarah was exceptional! Always on time, great with customers, and learned our menu quickly. Would definitely hire again.",
        "helpful": 8
      },
      {
        "id": 2,
        "employerName": "StudyBuddy Tutoring",
        "employerAvatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face",
        "rating": 5,
        "jobTitle": "Math Tutor",
        "date": "2024-12-15",
        "comment":
            "Outstanding tutoring skills. Student grades improved significantly under Sarah's guidance. Professional and patient.",
        "helpful": 12
      },
      {
        "id": 3,
        "employerName": "Campus Events LLC",
        "employerAvatar":
            "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100&h=100&fit=crop&crop=face",
        "rating": 4,
        "jobTitle": "Event Assistant",
        "date": "2024-11-20",
        "comment":
            "Hardworking and reliable. Great team player during our busy event season. Minor communication could be improved.",
        "helpful": 5
      }
    ],
    "portfolio": [
      {
        "id": 1,
        "title": "Social Media Campaign",
        "image":
            "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=300&fit=crop",
        "description": "Increased Instagram engagement by 40%"
      },
      {
        "id": 2,
        "title": "Tutoring Materials",
        "image":
            "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop",
        "description": "Custom study guides for calculus students"
      }
    ],
    "availability": {
      "weekdays": "After 3 PM",
      "weekends": "Flexible",
      "preferredHours": "15-20 hours/week"
    },
    "settings": {
      "profileVisibility": "employers",
      "emailNotifications": true,
      "pushNotifications": true,
      "jobAlerts": true,
      "messageNotifications": true
    }
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadProfile();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _isLoading = false;
    });

    _animationController.forward();
  }

  Future<void> _refreshProfile() async {
    HapticFeedback.mediumImpact();
    await _loadProfile();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
    HapticFeedback.lightImpact();
  }

  void _updateProfile(Map<String, dynamic> updates) {
    setState(() {
      _profileData = {..._profileData, ...updates};
    });
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'qr_code',
                  size: 120,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Share this QR code for quick profile access during networking events',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Share QR code functionality
              HapticFeedback.lightImpact();
            },
            child: Text('Share'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: colorScheme.primary),
              SizedBox(height: 2.h),
              Text(
                'Loading Profile...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Profile',
        variant: CustomAppBarVariant.standard,
        actions: [
          IconButton(
            onPressed: _showQRCode,
            icon: CustomIconWidget(
              iconName: 'qr_code',
              color: colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Share QR Code',
          ),
          IconButton(
            onPressed: _toggleEditMode,
            icon: CustomIconWidget(
              iconName: _isEditMode ? 'check' : 'edit',
              color: _isEditMode
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            tooltip: _isEditMode ? 'Save Changes' : 'Edit Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          CustomTabBar(
            tabs: _tabs,
            variant: CustomTabBarVariant.underline,
            initialIndex: 2,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/student-job-feed');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(
                      context, '/applications-screen');
                  break;
                case 2:
                  // Already on Profile
                  break;
                case 3:
                  // Navigate to More/Settings
                  break;
              }
            },
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: _refreshProfile,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      ProfileHeaderWidget(
                        profileData: _profileData,
                        isEditMode: _isEditMode,
                        onProfileUpdate: _updateProfile,
                      ),

                      // Quick Stats
                      ProfileStatsWidget(
                        stats:
                            _profileData['quickStats'] as Map<String, dynamic>,
                      ),

                      // Skills Showcase
                      SkillsShowcaseWidget(
                        skills: List<Map<String, dynamic>>.from(
                            _profileData['skills']),
                        isEditMode: _isEditMode,
                        onSkillsUpdate: (skills) {
                          _updateProfile({'skills': skills});
                        },
                      ),

                      // Education Section
                      ProfileSectionWidget(
                        title: 'Education',
                        icon: 'school',
                        child: _buildEducationContent(),
                        isEditMode: _isEditMode,
                      ),

                      // Work Experience
                      ProfileSectionWidget(
                        title: 'Work Experience',
                        icon: 'work',
                        child: _buildWorkExperienceContent(),
                        isEditMode: _isEditMode,
                      ),

                      // Achievements Gallery
                      AchievementsGalleryWidget(
                        achievements: List<Map<String, dynamic>>.from(
                            _profileData['achievements']),
                      ),

                      // Portfolio Section
                      ProfileSectionWidget(
                        title: 'Portfolio',
                        icon: 'photo_library',
                        child: _buildPortfolioContent(),
                        isEditMode: _isEditMode,
                      ),

                      // Reviews Section
                      ReviewsWidget(
                        reviews: List<Map<String, dynamic>>.from(
                            _profileData['reviews']),
                        averageRating: _profileData['quickStats']
                            ['averageRating'] as double,
                      ),

                      // Availability Section
                      ProfileSectionWidget(
                        title: 'Availability',
                        icon: 'schedule',
                        child: _buildAvailabilityContent(),
                        isEditMode: _isEditMode,
                      ),

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 2,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildEducationContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final education = _profileData['education'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
            'University', education['university'] as String, 'school'),
        _buildInfoRow('Major', education['major'] as String, 'book'),
        _buildInfoRow('Year', education['year'] as String, 'event'),
        _buildInfoRow('GPA', education['gpa'] as String, 'star'),
        SizedBox(height: 2.h),
        Text(
          'Relevant Coursework',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children:
              (education['relevantCourses'] as List<String>).map((course) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                course,
                style: theme.textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWorkExperienceContent() {
    final workExperience =
        _profileData['workExperience'] as List<Map<String, dynamic>>;

    return Column(
      children: workExperience.asMap().entries.map((entry) {
        final index = entry.key;
        final job = entry.value;
        final isLast = index == workExperience.length - 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkExperienceCard(job),
            if (!isLast) SizedBox(height: 2.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildWorkExperienceCard(Map<String, dynamic> job) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['jobTitle'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      job['company'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      job['duration'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      size: 16,
                      color: Colors.green,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      job['rating'].toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            job['description'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioContent() {
    final portfolio = _profileData['portfolio'] as List<Map<String, dynamic>>;

    if (portfolio.isEmpty) {
      return _buildEmptyPortfolio();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        childAspectRatio: 1.2,
      ),
      itemCount: portfolio.length,
      itemBuilder: (context, index) {
        final item = portfolio[index];
        return _buildPortfolioItem(item);
      },
    );
  }

  Widget _buildPortfolioItem(Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                item['image'] as String,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'photo',
                      color: colorScheme.onSurfaceVariant,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(2.w),
              color: colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item['description'] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPortfolio() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'add_photo_alternate',
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Portfolio Items Yet',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add photos to showcase your work quality',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          OutlinedButton.icon(
            onPressed: () {
              // Add portfolio item
              HapticFeedback.lightImpact();
            },
            icon: CustomIconWidget(
              iconName: 'add',
              size: 18,
              color: colorScheme.primary,
            ),
            label: Text('Add Photos'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityContent() {
    final availability = _profileData['availability'] as Map<String, dynamic>;

    return Column(
      children: [
        _buildInfoRow('Weekdays', availability['weekdays'] as String, 'today'),
        _buildInfoRow(
            'Weekends', availability['weekends'] as String, 'weekend'),
        _buildInfoRow('Preferred Hours',
            availability['preferredHours'] as String, 'schedule'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
