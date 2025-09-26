import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class JobTitleSection extends StatefulWidget {
  final TextEditingController titleController;
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;

  const JobTitleSection({
    super.key,
    required this.titleController,
    this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<JobTitleSection> createState() => _JobTitleSectionState();
}

class _JobTitleSectionState extends State<JobTitleSection> {
  final List<String> jobCategories = [
    'Food Service',
    'Retail',
    'Tutoring',
    'Event Staff',
    'Delivery',
    'Administrative',
    'Creative',
    'Tech Support',
    'Marketing',
    'Other'
  ];

  final List<String> popularTitles = [
    'Barista',
    'Sales Associate',
    'Math Tutor',
    'Event Assistant',
    'Delivery Driver',
    'Data Entry Clerk',
    'Graphic Designer',
    'Social Media Assistant'
  ];

  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Category',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          DropdownButtonFormField<String>(
            value: widget.selectedCategory,
            decoration: InputDecoration(
              hintText: 'Select a category',
              prefixIcon: CustomIconWidget(
                iconName: 'category',
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            items: jobCategories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: widget.onCategoryChanged,
          ),
          SizedBox(height: 3.h),
          Text(
            'Job Title',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.titleController,
            decoration: InputDecoration(
              hintText: 'e.g., Part-time Barista',
              prefixIcon: CustomIconWidget(
                iconName: 'work',
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: widget.titleController.text.isNotEmpty
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'auto_awesome',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          showSuggestions = !showSuggestions;
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          if (showSuggestions) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color: colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Popular job titles',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: popularTitles.map((title) {
                      return GestureDetector(
                        onTap: () {
                          widget.titleController.text = title;
                          setState(() {
                            showSuggestions = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
