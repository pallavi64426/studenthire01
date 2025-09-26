import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class JobDescriptionSection extends StatefulWidget {
  final TextEditingController descriptionController;

  const JobDescriptionSection({
    super.key,
    required this.descriptionController,
  });

  @override
  State<JobDescriptionSection> createState() => _JobDescriptionSectionState();
}

class _JobDescriptionSectionState extends State<JobDescriptionSection> {
  bool showAIAssistant = false;
  String selectedTone = 'Professional';

  final List<String> toneOptions = [
    'Professional',
    'Friendly',
    'Casual',
    'Energetic'
  ];

  final List<String> promptSuggestions = [
    'Looking for a reliable student to help with...',
    'We need an enthusiastic team member who can...',
    'Perfect opportunity for students interested in...',
    'Join our team and gain experience in...'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Job Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    showAIAssistant = !showAIAssistant;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'auto_awesome',
                  color: colorScheme.primary,
                  size: 16,
                ),
                label: Text(
                  'AI Help',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.descriptionController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText:
                  'Describe the job responsibilities, requirements, and what makes this opportunity great for students...',
              alignLabelWithHint: true,
            ),
          ),
          if (showAIAssistant) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'psychology',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'AI Writing Assistant',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Tone',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    children: toneOptions.map((tone) {
                      final isSelected = tone == selectedTone;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTone = tone;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            tone,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Quick Starters',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...promptSuggestions.map((prompt) {
                    return GestureDetector(
                      onTap: () {
                        widget.descriptionController.text = prompt;
                        setState(() {
                          showAIAssistant = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 1.h),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          prompt,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 1.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // AI enhancement logic would go here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('AI enhancement applied!'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'auto_fix_high',
                        color: colorScheme.onPrimary,
                        size: 16,
                      ),
                      label: Text('Enhance with AI'),
                    ),
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
