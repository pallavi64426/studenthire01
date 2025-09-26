import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentApplicationWidget extends StatelessWidget {
  final Map<String, dynamic> applicationData;
  final VoidCallback? onViewProfile;
  final VoidCallback? onMessage;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const RecentApplicationWidget({
    super.key,
    required this.applicationData,
    this.onViewProfile,
    this.onMessage,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String studentName = applicationData['studentName'] ?? 'Student Name';
    final String jobTitle = applicationData['jobTitle'] ?? 'Job Title';
    final String appliedTime = applicationData['appliedTime'] ?? '2 hours ago';
    final String profileImage = applicationData['profileImage'] ?? '';
    final double matchScore =
        (applicationData['matchScore'] ?? 85.0).toDouble();
    final List<String> skills =
        (applicationData['skills'] as List?)?.cast<String>() ?? [];
    final String status = applicationData['status'] ?? 'pending';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
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
              _buildProfileImage(context, profileImage),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Applied for $jobTitle',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildMatchScore(context, matchScore),
            ],
          ),
          SizedBox(height: 2.h),
          if (skills.isNotEmpty) ...[
            _buildSkillsSection(context, skills),
            SizedBox(height: 2.h),
          ],
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 1.w),
              Text(
                appliedTime,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              _buildStatusBadge(context, status),
            ],
          ),
          SizedBox(height: 2.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, String imageUrl) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? CustomImageWidget(
                imageUrl: imageUrl,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              )
            : Container(
                color: colorScheme.primary.withValues(alpha: 0.1),
                child: CustomIconWidget(
                  iconName: 'person',
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),
      ),
    );
  }

  Widget _buildMatchScore(BuildContext context, double score) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color scoreColor;
    if (score >= 80) {
      scoreColor = colorScheme.tertiary;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = colorScheme.error;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: scoreColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'star',
            size: 14,
            color: scoreColor,
          ),
          SizedBox(width: 1.w),
          Text(
            '${score.toInt()}%',
            style: theme.textTheme.labelSmall?.copyWith(
              color: scoreColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context, List<String> skills) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: skills.take(3).map((skill) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            skill,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'pending':
        badgeColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        displayText = 'Pending';
        break;
      case 'accepted':
        badgeColor = colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = colorScheme.tertiary;
        displayText = 'Accepted';
        break;
      case 'declined':
        badgeColor = colorScheme.error.withValues(alpha: 0.1);
        textColor = colorScheme.error;
        displayText = 'Declined';
        break;
      default:
        badgeColor = colorScheme.outline.withValues(alpha: 0.1);
        textColor = colorScheme.onSurfaceVariant;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onViewProfile,
            icon: CustomIconWidget(
              iconName: 'person',
              size: 16,
              color: colorScheme.primary,
            ),
            label: Text('Profile'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onMessage,
            icon: CustomIconWidget(
              iconName: 'chat',
              size: 16,
              color: colorScheme.primary,
            ),
            label: Text('Message'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAccept,
            icon: CustomIconWidget(
              iconName: 'check',
              size: 16,
              color: Colors.white,
            ),
            label: Text('Accept'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
