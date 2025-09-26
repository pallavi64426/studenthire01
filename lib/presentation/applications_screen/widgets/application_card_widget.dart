import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../widgets/custom_icon_widget.dart';

class ApplicationCardWidget extends StatelessWidget {
  final Map<String, dynamic> applicationData;
  final VoidCallback? onTap;
  final VoidCallback? onWithdraw;
  final VoidCallback? onMessage;

  const ApplicationCardWidget({
    super.key,
    required this.applicationData,
    this.onTap,
    this.onWithdraw,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final status = applicationData['status'] as String;
    final statusColor = applicationData['statusColor'] as Color;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with company logo and basic info
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: applicationData['companyLogo'] as String,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 12.w,
                            height: 12.w,
                            color: colorScheme.primaryContainer,
                            child: CustomIconWidget(
                              iconName: 'business',
                              color: colorScheme.primary,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 12.w,
                            height: 12.w,
                            color: colorScheme.primaryContainer,
                            child: CustomIconWidget(
                              iconName: 'business',
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              applicationData['jobTitle'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              applicationData['company'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          status,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Application details
                  Row(
                    children: [
                      _buildDetailChip(
                        context,
                        'location_on',
                        applicationData['location'] as String,
                      ),
                      SizedBox(width: 2.w),
                      _buildDetailChip(
                        context,
                        'payments',
                        applicationData['hourlyRate'] as String,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Application metrics
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Applied',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              _formatDate(
                                  applicationData['appliedDate'] as String),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Response Time',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              applicationData['estimatedResponse'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (applicationData['applicationScore'] != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _getScoreColor(
                                    applicationData['applicationScore'] as int)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'trending_up',
                                size: 16,
                                color: _getScoreColor(
                                    applicationData['applicationScore'] as int),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${applicationData['applicationScore']}%',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _getScoreColor(
                                      applicationData['applicationScore']
                                          as int),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Last update
                  Text(
                    applicationData['lastUpdate'] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            if (onWithdraw != null || onMessage != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    if (onMessage != null) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            onMessage?.call();
                          },
                          icon: CustomIconWidget(
                            iconName: applicationData['hasMessage'] as bool
                                ? 'mark_chat_unread'
                                : 'chat',
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          label: Text(
                            applicationData['hasMessage'] as bool
                                ? 'New Message'
                                : 'Message',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                        ),
                      ),
                      if (onWithdraw != null) SizedBox(width: 2.w),
                    ],
                    if (onWithdraw != null)
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            onWithdraw?.call();
                          },
                          icon: CustomIconWidget(
                            iconName: 'remove_circle_outline',
                            size: 18,
                            color: colorScheme.error,
                          ),
                          label: Text('Withdraw'),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, String iconName, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.blue;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '$difference days ago';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
