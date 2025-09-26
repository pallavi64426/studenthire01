import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class JobCardWidget extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onPause;
  final VoidCallback? onViewApplications;
  final VoidCallback? onDuplicate;

  const JobCardWidget({
    super.key,
    required this.jobData,
    this.onTap,
    this.onEdit,
    this.onPause,
    this.onViewApplications,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String title = jobData['title'] ?? 'Job Title';
    final String postedDate = jobData['postedDate'] ?? '2 days ago';
    final int applicantCount = jobData['applicantCount'] ?? 0;
    final String status = jobData['status'] ?? 'active';
    final int viewCount = jobData['viewCount'] ?? 0;
    final bool hasNewApplications = jobData['hasNewApplications'] ?? false;

    return Dismissible(
      key: Key('job_${jobData['id']}'),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
        } else {
          onViewApplications?.call();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  _buildStatusBadge(context, status),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Posted $postedDate',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricItem(
                      context,
                      icon: 'visibility',
                      label: 'Views',
                      value: viewCount.toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildMetricItem(
                      context,
                      icon: 'people',
                      label: 'Applications',
                      value: applicantCount.toString(),
                      hasNotification: hasNewApplications,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _buildQuickActions(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'active':
        badgeColor = colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = colorScheme.tertiary;
        displayText = 'Active';
        break;
      case 'paused':
        badgeColor = colorScheme.secondary.withValues(alpha: 0.1);
        textColor = colorScheme.secondary;
        displayText = 'Paused';
        break;
      case 'filled':
        badgeColor = colorScheme.primary.withValues(alpha: 0.1);
        textColor = colorScheme.primary;
        displayText = 'Filled';
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

  Widget _buildMetricItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
    bool hasNotification = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            if (hasNotification)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      icon: CustomIconWidget(
        iconName: 'more_vert',
        size: 20,
        color: colorScheme.onSurfaceVariant,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'pause':
            onPause?.call();
            break;
          case 'applications':
            onViewApplications?.call();
            break;
          case 'duplicate':
            onDuplicate?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'edit',
                size: 18,
                color: colorScheme.onSurface,
              ),
              SizedBox(width: 2.w),
              Text('Edit Job'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pause',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'pause',
                size: 18,
                color: colorScheme.onSurface,
              ),
              SizedBox(width: 2.w),
              Text('Pause/Resume'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'applications',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'people',
                size: 18,
                color: colorScheme.onSurface,
              ),
              SizedBox(width: 2.w),
              Text('View Applications'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'content_copy',
                size: 18,
                color: colorScheme.onSurface,
              ),
              SizedBox(width: 2.w),
              Text('Duplicate'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? colorScheme.primary : colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'edit' : 'people',
                size: 24,
                color: Colors.white,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Edit' : 'Applications',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
