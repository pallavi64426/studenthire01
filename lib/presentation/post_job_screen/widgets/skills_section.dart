import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SkillsSection extends StatefulWidget {
  final List<String> selectedSkills;
  final Function(List<String>) onSkillsChanged;
  final double karmaPointsRequirement;
  final Function(double) onKarmaPointsChanged;

  const SkillsSection({
    super.key,
    required this.selectedSkills,
    required this.onSkillsChanged,
    required this.karmaPointsRequirement,
    required this.onKarmaPointsChanged,
  });

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final TextEditingController _skillController = TextEditingController();
  bool showSkillSearch = false;

  final List<String> popularSkills = [
    'Customer Service',
    'Communication',
    'Time Management',
    'Microsoft Office',
    'Social Media',
    'Data Entry',
    'Sales',
    'Problem Solving',
    'Teamwork',
    'Organization',
    'Cash Handling',
    'Food Safety',
    'Photography',
    'Writing',
    'Research',
    'Tutoring',
    'Event Planning',
    'Marketing',
    'Design',
    'Programming'
  ];

  List<String> get filteredSkills {
    if (_skillController.text.isEmpty) return popularSkills;
    return popularSkills
        .where((skill) =>
            skill.toLowerCase().contains(_skillController.text.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

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
            'Required Skills',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              setState(() {
                showSkillSearch = !showSkillSearch;
              });
            },
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Search and add skills...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: showSkillSearch ? 'expand_less' : 'expand_more',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (showSkillSearch) ...[
            SizedBox(height: 1.h),
            TextFormField(
              controller: _skillController,
              decoration: InputDecoration(
                hintText: 'Type to search skills...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                suffixIcon: _skillController.text.isNotEmpty
                    ? IconButton(
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: () {
                          _skillController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 2.h),
            Container(
              constraints: BoxConstraints(maxHeight: 30.h),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: filteredSkills.map((skill) {
                    final isSelected = widget.selectedSkills.contains(skill);
                    return GestureDetector(
                      onTap: () {
                        List<String> newSkills =
                            List.from(widget.selectedSkills);
                        if (isSelected) {
                          newSkills.remove(skill);
                        } else {
                          newSkills.add(skill);
                        }
                        widget.onSkillsChanged(newSkills);
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              skill,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(width: 1.w),
                              CustomIconWidget(
                                iconName: 'check',
                                color: colorScheme.onPrimary,
                                size: 14,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          if (widget.selectedSkills.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              'Selected Skills (${widget.selectedSkills.length})',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: widget.selectedSkills.map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      GestureDetector(
                        onTap: () {
                          List<String> newSkills =
                              List.from(widget.selectedSkills);
                          newSkills.remove(skill);
                          widget.onSkillsChanged(newSkills);
                        },
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: colorScheme.onPrimaryContainer,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 3.h),
          Text(
            'Karma Points Requirement',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Minimum Karma Points:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: colorScheme.tertiary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.karmaPointsRequirement.toInt()}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: colorScheme.tertiary,
                    inactiveTrackColor:
                        colorScheme.outline.withValues(alpha: 0.3),
                    thumbColor: colorScheme.tertiary,
                    overlayColor: colorScheme.tertiary.withValues(alpha: 0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: widget.karmaPointsRequirement,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: widget.onKarmaPointsChanged,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'No requirement',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'High requirement',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: colorScheme.tertiary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          widget.karmaPointsRequirement == 0
                              ? 'Open to all students regardless of their Karma Points'
                              : widget.karmaPointsRequirement <= 25
                                  ? 'Suitable for new students with basic experience'
                                  : widget.karmaPointsRequirement <= 50
                                      ? 'Requires students with some proven track record'
                                      : widget.karmaPointsRequirement <= 75
                                          ? 'For experienced students with good ratings'
                                          : 'Only for top-rated students with excellent history',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
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
