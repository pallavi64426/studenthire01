import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class SkillsShowcaseWidget extends StatelessWidget {
  final List<Map<String, dynamic>> skills;
  final bool isEditMode;
  final Function(List<Map<String, dynamic>>) onSkillsUpdate;

  const SkillsShowcaseWidget({
    super.key,
    required this.skills,
    required this.isEditMode,
    required this.onSkillsUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Skills Showcase',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isEditMode)
                  IconButton(
                    onPressed: () {
                      _showSkillsEditor(context);
                    },
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),

          // Skills list
          Padding(
            padding: EdgeInsets.all(4.w),
            child: skills.isEmpty
                ? _buildEmptySkills(context)
                : _buildSkillsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsList(BuildContext context) {
    return Column(
      children: skills.asMap().entries.map((entry) {
        final index = entry.key;
        final skill = entry.value;
        final isLast = index == skills.length - 1;

        return Column(
          children: [
            _buildSkillItem(context, skill),
            if (!isLast) SizedBox(height: 3.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSkillItem(BuildContext context, Map<String, dynamic> skill) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final level = skill['level'] as int;
    final isVerified = skill['verified'] as bool;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                skill['name'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isVerified)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'verified',
                      size: 12,
                      color: Colors.green,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Verified',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(width: 2.w),
            Text(
              '$level%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: _getSkillLevelColor(level),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: level / 100.0,
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(_getSkillLevelColor(level)),
        ),
      ],
    );
  }

  Widget _buildEmptySkills(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'psychology',
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Skills Added Yet',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add your skills to showcase your abilities to employers',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          OutlinedButton.icon(
            onPressed: () {
              _showSkillsEditor(context);
            },
            icon: CustomIconWidget(
              iconName: 'add',
              size: 18,
              color: colorScheme.primary,
            ),
            label: Text('Add Skills'),
          ),
        ],
      ),
    );
  }

  Color _getSkillLevelColor(int level) {
    if (level >= 90) return Colors.green;
    if (level >= 75) return Colors.blue;
    if (level >= 60) return Colors.orange;
    return Colors.red;
  }

  void _showSkillsEditor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
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
                      'Edit Skills',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Done'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  // Existing skills
                  ...skills
                      .map((skill) => _buildEditableSkillItem(context, skill)),
                  SizedBox(height: 2.h),
                  // Add skill button
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'add',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text('Add New Skill'),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _addNewSkill(context);
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableSkillItem(
      BuildContext context, Map<String, dynamic> skill) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
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
                child: Text(
                  skill['name'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _removeSkill(skill);
                },
                icon: CustomIconWidget(
                  iconName: 'delete',
                  color: colorScheme.error,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Proficiency: ${skill['level']}%',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Slider(
            value: (skill['level'] as int).toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: (value) {
              _updateSkillLevel(skill, value.round());
            },
          ),
        ],
      ),
    );
  }

  void _addNewSkill(BuildContext context) {
    // Add new skill logic
    final newSkill = {
      'name': 'New Skill',
      'level': 50,
      'verified': false,
    };

    skills.add(newSkill);
    onSkillsUpdate(skills);
    HapticFeedback.lightImpact();
  }

  void _removeSkill(Map<String, dynamic> skill) {
    skills.removeWhere((s) => s['name'] == skill['name']);
    onSkillsUpdate(skills);
    HapticFeedback.lightImpact();
  }

  void _updateSkillLevel(Map<String, dynamic> skill, int newLevel) {
    final index = skills.indexWhere((s) => s['name'] == skill['name']);
    if (index != -1) {
      skills[index]['level'] = newLevel;
      onSkillsUpdate(skills);
    }
  }
}
