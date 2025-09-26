import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class JobInfoCardsWidget extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final int userKarmaPoints;

  const JobInfoCardsWidget({
    super.key,
    required this.jobData,
    required this.userKarmaPoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Location card
          _buildInfoCard(
            context,
            icon: 'location_on',
            title: 'Location',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobData["location"] as String,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.w),
                    child: CustomImageWidget(
                      imageUrl: jobData["mapThumbnail"] as String,
                      width: double.infinity,
                      height: 12.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  jobData["distance"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Schedule card
          _buildInfoCard(
            context,
            icon: 'schedule',
            title: 'Schedule',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobData["schedule"] as String,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  jobData["flexibility"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Skills card
          _buildInfoCard(
            context,
            icon: 'psychology',
            title: 'Required Skills',
            content: Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: (jobData["skills"] as List).map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(5.w),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    skill as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 3.h),

          // Karma Points card
          _buildInfoCard(
            context,
            icon: 'stars',
            title: 'Karma Points Required',
            content: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${jobData["karmaRequired"]} points needed',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Your points: $userKarmaPoints',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: userKarmaPoints >=
                                  (jobData["karmaRequired"] as int)
                              ? colorScheme.tertiary
                              : colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: userKarmaPoints >= (jobData["karmaRequired"] as int)
                        ? colorScheme.tertiaryContainer
                        : colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName:
                        userKarmaPoints >= (jobData["karmaRequired"] as int)
                            ? 'check'
                            : 'close',
                    color: userKarmaPoints >= (jobData["karmaRequired"] as int)
                        ? colorScheme.onTertiaryContainer
                        : colorScheme.onErrorContainer,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String icon,
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
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
                iconName: icon,
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          content,
        ],
      ),
    );
  }
}
