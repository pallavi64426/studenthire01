import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_options_section.dart';
import './widgets/bottom_action_bar.dart';
import './widgets/job_description_section.dart';
import './widgets/job_form_header.dart';
import './widgets/job_title_section.dart';
import './widgets/location_picker_section.dart';
import './widgets/pay_rate_section.dart';
import './widgets/photo_upload_section.dart';
import './widgets/schedule_section.dart';
import './widgets/skills_section.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 1;
  final int _totalSteps = 6;

  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _payRateController = TextEditingController();

  // Form State
  String? _selectedCategory;
  double _selectedRadius = 10.0;
  String _selectedScheduleType = 'Fixed Schedule';
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<String> _selectedDays = [];
  String _selectedPayType = 'Hourly';
  List<String> _selectedSkills = [];
  double _karmaPointsRequirement = 0.0;
  List<XFile> _selectedImages = [];
  DateTime? _applicationDeadline;
  List<String> _screeningQuestions = [];
  bool _autoResponse = true;
  String _autoResponseMessage =
      'Thank you for your application! We will review it and get back to you soon.';

  final List<String> _stepTitles = [
    'Job Details',
    'Description',
    'Location',
    'Schedule',
    'Pay & Skills',
    'Final Details'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _payRateController.dispose();
    super.dispose();
  }

  bool get _isCurrentStepValid {
    switch (_currentStep) {
      case 1:
        return _selectedCategory != null &&
            _titleController.text.trim().isNotEmpty;
      case 2:
        return _descriptionController.text.trim().isNotEmpty;
      case 3:
        return _locationController.text.trim().isNotEmpty;
      case 4:
        return _selectedScheduleType.isNotEmpty;
      case 5:
        return _payRateController.text.trim().isNotEmpty;
      case 6:
        return true;
      default:
        return false;
    }
  }

  bool get _isFormValid {
    return _selectedCategory != null &&
        _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        _selectedScheduleType.isNotEmpty &&
        _payRateController.text.trim().isNotEmpty;
  }

  double get _estimatedCost {
    // Mock cost calculation - in real app this would be based on job type, duration, etc.
    return 0.0; // Free for students
  }

  void _nextStep() {
    if (_currentStep < _totalSteps && _isCurrentStepValid) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveDraft() {
    // Save draft logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft saved successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _previewJob() {
    if (!_isFormValid) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildJobPreview(),
    );
  }

  void _publishJob() {
    if (!_isFormValid) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Publish Job'),
        content: Text(
            'Are you sure you want to publish this job? It will be visible to students immediately.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Job published successfully!'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
            child: Text('Publish'),
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
        title: 'Post a Job',
        variant: CustomAppBarVariant.back,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: Text(
              'Save',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          JobFormHeader(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            stepTitle: _stepTitles[_currentStep - 1],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index + 1;
                });
              },
              children: [
                // Step 1: Job Details
                SingleChildScrollView(
                  child: JobTitleSection(
                    titleController: _titleController,
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                ),
                // Step 2: Description
                SingleChildScrollView(
                  child: JobDescriptionSection(
                    descriptionController: _descriptionController,
                  ),
                ),
                // Step 3: Location
                SingleChildScrollView(
                  child: LocationPickerSection(
                    locationController: _locationController,
                    selectedRadius: _selectedRadius,
                    onRadiusChanged: (radius) {
                      setState(() {
                        _selectedRadius = radius;
                      });
                    },
                  ),
                ),
                // Step 4: Schedule
                SingleChildScrollView(
                  child: ScheduleSection(
                    selectedScheduleType: _selectedScheduleType,
                    onScheduleTypeChanged: (type) {
                      setState(() {
                        _selectedScheduleType = type;
                      });
                    },
                    startTime: _startTime,
                    endTime: _endTime,
                    onStartTimeChanged: (time) {
                      setState(() {
                        _startTime = time;
                      });
                    },
                    onEndTimeChanged: (time) {
                      setState(() {
                        _endTime = time;
                      });
                    },
                    selectedDays: _selectedDays,
                    onDaysChanged: (days) {
                      setState(() {
                        _selectedDays = days;
                      });
                    },
                  ),
                ),
                // Step 5: Pay & Skills
                SingleChildScrollView(
                  child: Column(
                    children: [
                      PayRateSection(
                        payRateController: _payRateController,
                        selectedPayType: _selectedPayType,
                        onPayTypeChanged: (type) {
                          setState(() {
                            _selectedPayType = type;
                          });
                        },
                      ),
                      SkillsSection(
                        selectedSkills: _selectedSkills,
                        onSkillsChanged: (skills) {
                          setState(() {
                            _selectedSkills = skills;
                          });
                        },
                        karmaPointsRequirement: _karmaPointsRequirement,
                        onKarmaPointsChanged: (points) {
                          setState(() {
                            _karmaPointsRequirement = points;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Step 6: Final Details
                SingleChildScrollView(
                  child: Column(
                    children: [
                      PhotoUploadSection(
                        selectedImages: _selectedImages,
                        onImagesChanged: (images) {
                          setState(() {
                            _selectedImages = images;
                          });
                        },
                      ),
                      AdvancedOptionsSection(
                        applicationDeadline: _applicationDeadline,
                        onDeadlineChanged: (deadline) {
                          setState(() {
                            _applicationDeadline = deadline;
                          });
                        },
                        screeningQuestions: _screeningQuestions,
                        onScreeningQuestionsChanged: (questions) {
                          setState(() {
                            _screeningQuestions = questions;
                          });
                        },
                        autoResponse: _autoResponse,
                        onAutoResponseChanged: (enabled) {
                          setState(() {
                            _autoResponse = enabled;
                          });
                        },
                        autoResponseMessage: _autoResponseMessage,
                        onAutoResponseMessageChanged: (message) {
                          setState(() {
                            _autoResponseMessage = message;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Navigation buttons
          if (_currentStep < _totalSteps) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  if (_currentStep > 1) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Previous'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Expanded(
                    flex: _currentStep > 1 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _isCurrentStepValid ? _nextStep : null,
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            BottomActionBar(
              onPreview: _previewJob,
              onPublish: _publishJob,
              onSaveDraft: _saveDraft,
              isFormValid: _isFormValid,
              estimatedCost: _estimatedCost,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJobPreview() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Job Preview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Title and Category
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color:
                          colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titleController.text,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _selectedCategory ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _descriptionController.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Pay Rate
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'attach_money',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '\$${_payRateController.text}${_selectedPayType == 'Hourly' ? '/hour' : _selectedPayType == 'Commission' ? '%' : ''}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Location
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          _locationController.text,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedSkills.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Required Skills',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _selectedSkills.map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            skill,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _publishJob();
                      },
                      child: Text('Looks Good - Publish Job'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
