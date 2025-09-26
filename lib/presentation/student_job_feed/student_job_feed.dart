import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/job_card_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/skeleton_job_card_widget.dart';

class StudentJobFeed extends StatefulWidget {
  const StudentJobFeed({super.key});

  @override
  State<StudentJobFeed> createState() => _StudentJobFeedState();
}

class _StudentJobFeedState extends State<StudentJobFeed>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreJobs = true;
  String _currentLocation = "Within 5 miles of Campus";
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _jobs = [];
  List<Map<String, dynamic>> _filteredJobs = [];

  final List<String> _tabs = ['Feed', 'Applications', 'Profile', 'More'];

  // Mock job data
  final List<Map<String, dynamic>> _mockJobs = [
    {
      "id": 1,
      "title": "Barista - Morning Shift",
      "company": "Campus Coffee Co.",
      "location": "University District",
      "hourlyRate": "\$16/hr",
      "distance": "0.3",
      "postedTime": "2h ago",
      "companyLogo":
          "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=100&h=100&fit=crop",
      "skills": ["Customer Service", "Cash Handling", "Food Safety"],
      "karmaRequired": 25,
      "isBookmarked": false,
      "isUrgent": true,
      "category": "Food Service",
      "schedule": "Part-time",
      "description":
          "Join our energetic team serving premium coffee to students and faculty. Perfect for early risers who love creating the perfect cup!"
    },
    {
      "id": 2,
      "title": "Math Tutor - Calculus",
      "company": "StudyBuddy Tutoring",
      "location": "Library Commons",
      "hourlyRate": "\$22/hr",
      "distance": "0.1",
      "postedTime": "4h ago",
      "companyLogo":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=100&h=100&fit=crop",
      "skills": ["Mathematics", "Teaching", "Communication"],
      "karmaRequired": 75,
      "isBookmarked": true,
      "isUrgent": false,
      "category": "Tutoring",
      "schedule": "Flexible",
      "description":
          "Help fellow students excel in calculus. Flexible scheduling around your class times. Great for math majors!"
    },
    {
      "id": 3,
      "title": "Event Setup Assistant",
      "company": "Campus Events LLC",
      "location": "Student Center",
      "hourlyRate": "\$18/hr",
      "distance": "0.5",
      "postedTime": "6h ago",
      "companyLogo":
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=100&h=100&fit=crop",
      "skills": ["Physical Work", "Teamwork", "Time Management"],
      "karmaRequired": 10,
      "isBookmarked": false,
      "isUrgent": false,
      "category": "Event Staff",
      "schedule": "Weekends",
      "description":
          "Help set up and break down events on campus. Great workout and flexible weekend hours!"
    },
    {
      "id": 4,
      "title": "Social Media Assistant",
      "company": "Local Marketing Co.",
      "location": "Downtown",
      "hourlyRate": "\$20/hr",
      "distance": "1.2",
      "postedTime": "8h ago",
      "companyLogo":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=100&h=100&fit=crop",
      "skills": ["Social Media", "Content Creation", "Photography"],
      "karmaRequired": 50,
      "isBookmarked": false,
      "isUrgent": false,
      "category": "Creative",
      "schedule": "Remote",
      "description":
          "Create engaging content for local businesses. Perfect for marketing or communications students!"
    },
    {
      "id": 5,
      "title": "Delivery Driver",
      "company": "QuickEats Delivery",
      "location": "Campus Area",
      "hourlyRate": "\$15/hr + tips",
      "distance": "0.8",
      "postedTime": "1d ago",
      "companyLogo":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100&h=100&fit=crop",
      "skills": ["Driving", "Customer Service", "Navigation"],
      "karmaRequired": 30,
      "isBookmarked": false,
      "isUrgent": true,
      "category": "Delivery",
      "schedule": "Evenings",
      "description":
          "Deliver food to hungry students! Flexible evening hours and keep 100% of your tips."
    },
    {
      "id": 6,
      "title": "Research Assistant",
      "company": "Psychology Department",
      "location": "Science Building",
      "hourlyRate": "\$17/hr",
      "distance": "0.2",
      "postedTime": "1d ago",
      "companyLogo":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop",
      "skills": ["Research", "Data Entry", "Analysis"],
      "karmaRequired": 60,
      "isBookmarked": true,
      "isUrgent": false,
      "category": "Admin",
      "schedule": "Part-time",
      "description":
          "Assist with psychology research studies. Great experience for pre-grad students!"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    _scrollController.addListener(_onScroll);
    _loadInitialJobs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreJobs();
    }
  }

  Future<void> _loadInitialJobs() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _jobs = List.from(_mockJobs);
      _filteredJobs = List.from(_jobs);
      _isLoading = false;
    });
  }

  Future<void> _loadMoreJobs() async {
    if (_isLoadingMore || !_hasMoreJobs) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      // Add more mock jobs (simulate pagination)
      final moreJobs = _mockJobs.map((job) {
        final newJob = Map<String, dynamic>.from(job);
        newJob['id'] = job['id'] + _jobs.length;
        newJob['postedTime'] = '${(_jobs.length ~/ 3) + 1}d ago';
        return newJob;
      }).toList();

      _jobs.addAll(moreJobs);
      _applyFilters();
      _isLoadingMore = false;
      _hasMoreJobs = _jobs.length < 50; // Limit to 50 jobs for demo
    });
  }

  Future<void> _refreshJobs() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _jobs.clear();
      _filteredJobs.clear();
      _hasMoreJobs = true;
    });
    await _loadInitialJobs();
  }

  void _applyFilters() {
    setState(() {
      _filteredJobs = _jobs.where((job) {
        // Search filter
        if (_searchController.text.isNotEmpty) {
          final searchTerm = _searchController.text.toLowerCase();
          final title = (job['title'] as String).toLowerCase();
          final company = (job['company'] as String).toLowerCase();
          if (!title.contains(searchTerm) && !company.contains(searchTerm)) {
            return false;
          }
        }

        // Category filter
        if (_activeFilters['categories'] != null &&
            (_activeFilters['categories'] as List).isNotEmpty) {
          if (!(_activeFilters['categories'] as List)
              .contains(job['category'])) {
            return false;
          }
        }

        // Pay range filter
        if (_activeFilters['payRangeMin'] != null &&
            _activeFilters['payRangeMax'] != null) {
          final hourlyRate =
              (job['hourlyRate'] as String).replaceAll(RegExp(r'[^\d.]'), '');
          final rate = double.tryParse(hourlyRate) ?? 0;
          if (rate < (_activeFilters['payRangeMin'] as double) ||
              rate > (_activeFilters['payRangeMax'] as double)) {
            return false;
          }
        }

        // Distance filter
        if (_activeFilters['distance'] != null) {
          final distance = double.tryParse(job['distance'] as String) ?? 0;
          if (distance > (_activeFilters['distance'] as double)) {
            return false;
          }
        }

        // Karma filter
        if (_activeFilters['karmaMax'] != null) {
          final karma = job['karmaRequired'] as int;
          if (karma > (_activeFilters['karmaMax'] as int)) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _toggleBookmark(int jobId) {
    setState(() {
      final jobIndex = _jobs.indexWhere((job) => job['id'] == jobId);
      if (jobIndex != -1) {
        _jobs[jobIndex]['isBookmarked'] =
            !(_jobs[jobIndex]['isBookmarked'] as bool);
      }
      _applyFilters();
    });
    HapticFeedback.lightImpact();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _activeFilters.remove(filterKey);
    });
    _applyFilters();
    HapticFeedback.selectionClick();
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];

    if (_activeFilters['categories'] != null &&
        (_activeFilters['categories'] as List).isNotEmpty) {
      for (String category in (_activeFilters['categories'] as List)) {
        chips.add(
          FilterChipWidget(
            label: category,
            isSelected: true,
            onRemove: () {
              setState(() {
                (_activeFilters['categories'] as List).remove(category);
                if ((_activeFilters['categories'] as List).isEmpty) {
                  _activeFilters.remove('categories');
                }
              });
              _applyFilters();
            },
          ),
        );
      }
    }

    if (_activeFilters['payRangeMin'] != null &&
        _activeFilters['payRangeMax'] != null) {
      chips.add(
        FilterChipWidget(
          label:
              '\$${(_activeFilters['payRangeMin'] as double).round()}-\$${(_activeFilters['payRangeMax'] as double).round()}',
          isSelected: true,
          onRemove: () => _removeFilter('payRangeMin'),
        ),
      );
    }

    if (_activeFilters['distance'] != null) {
      chips.add(
        FilterChipWidget(
          label: '${(_activeFilters['distance'] as double).round()} mi',
          isSelected: true,
          onRemove: () => _removeFilter('distance'),
        ),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'StudentHire',
        variant: CustomAppBarVariant.profile,
        onProfileTap: () {
          // Navigate to profile
        },
      ),
      body: Column(
        children: [
          CustomTabBar(
            tabs: _tabs,
            variant: CustomTabBarVariant.underline,
            initialIndex: 0,
            onTap: (index) {
              if (index != 0) {
                // Navigate to other tabs
                switch (index) {
                  case 1:
                    // Applications tab
                    break;
                  case 2:
                    // Profile tab
                    break;
                  case 3:
                    // More tab
                    break;
                }
              }
            },
          ),
          SearchHeaderWidget(
            searchController: _searchController,
            locationText: _currentLocation,
            onFilterTap: _showFilterBottomSheet,
            onLocationTap: () {
              // Show location picker
            },
            onSearchChanged: (value) {
              _applyFilters();
            },
          ),
          if (_buildActiveFilterChips().isNotEmpty)
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _buildActiveFilterChips(),
              ),
            ),
          Expanded(
            child: _buildJobsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open map view
          Navigator.pushNamed(context, '/job-detail-screen');
        },
        child: CustomIconWidget(
          iconName: 'map',
          color: colorScheme.onPrimary,
          size: 24,
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildJobsList() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => const SkeletonJobCardWidget(),
      );
    }

    if (_filteredJobs.isEmpty) {
      return EmptyStateWidget(
        title: 'No Jobs Found',
        subtitle:
            'Try adjusting your filters or expanding your search radius to find more opportunities.',
        actionText: 'Expand Search Radius',
        onActionTap: () {
          setState(() {
            _currentLocation = "Within 10 miles of Campus";
            _activeFilters['distance'] = 10.0;
          });
          _applyFilters();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshJobs,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _filteredJobs.length + (_isLoadingMore ? 3 : 0),
        itemBuilder: (context, index) {
          if (index >= _filteredJobs.length) {
            return const SkeletonJobCardWidget();
          }

          final job = _filteredJobs[index];
          return Dismissible(
            key: Key('job_${job['id']}'),
            direction: DismissDirection.startToEnd,
            background: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'bookmark',
                    color: Colors.green,
                    size: 24,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Bookmark',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              _toggleBookmark(job['id'] as int);
              return false; // Don't actually dismiss
            },
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                _showJobContextMenu(context, job);
              },
              child: JobCardWidget(
                jobData: job,
                onTap: () {
                  Navigator.pushNamed(context, '/job-detail-screen');
                },
                onBookmark: () => _toggleBookmark(job['id'] as int),
                onShare: () {
                  // Share job
                  HapticFeedback.lightImpact();
                },
                onSimilarJobs: () {
                  // Show similar jobs
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showJobContextMenu(BuildContext context, Map<String, dynamic> job) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildContextMenuItem(
                context,
                'Not Interested',
                'thumb_down',
                () {
                  Navigator.pop(context);
                  // Remove from feed
                },
              ),
              _buildContextMenuItem(
                context,
                'Save for Later',
                'bookmark_border',
                () {
                  Navigator.pop(context);
                  _toggleBookmark(job['id'] as int);
                },
              ),
              _buildContextMenuItem(
                context,
                'Report Job',
                'flag',
                () {
                  Navigator.pop(context);
                  // Report job
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }
}
