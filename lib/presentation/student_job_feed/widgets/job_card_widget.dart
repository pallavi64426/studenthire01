import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class JobCardWidget extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final VoidCallback? onSimilarJobs;

  const JobCardWidget({
    super.key,
    required this.jobData,
    this.onTap,
    this.onBookmark,
    this.onShare,
    this.onSimilarJobs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 1.h),
              _buildJobTitle(context),
              SizedBox(height: 0.5.h),
              _buildCompanyInfo(context),
              SizedBox(height: 1.h),
              _buildPayAndDistance(context),
              SizedBox(height: 1.h),
              _buildSkillsChips(context),
              SizedBox(height: 1.h),
              _buildKarmaPoints(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Hero(
          tag: 'company_logo_${jobData["id"]}',
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.primaryContainer,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: jobData["companyLogo"] as String? ??
                    "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100&h=100&fit=crop",
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onBookmark,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: CustomIconWidget(
              iconName: jobData["isBookmarked"] == true
                  ? 'bookmark'
                  : 'bookmark_border',
              color: jobData["isBookmarked"] == true
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      jobData["title"] as String? ?? "Job Title",
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Text(
          jobData["company"] as String? ?? "Company Name",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(width: 2.w),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          jobData["location"] as String? ?? "Location",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPayAndDistance(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            jobData["hourlyRate"] as String? ?? "\$15/hr",
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        CustomIconWidget(
          iconName: 'location_on',
          color: colorScheme.onSurfaceVariant,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          "${jobData["distance"] ?? "0.5"} mi",
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          jobData["postedTime"] as String? ?? "2h ago",
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsChips(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final skills = (jobData["skills"] as List?)?.cast<String>() ?? [];

    if (skills.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.w,
      children: skills.take(3).map((skill) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.w),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            skill,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKarmaPoints(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'star',
          color: Colors.amber,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          "Karma: ${jobData["karmaRequired"] ?? "50"}+",
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (jobData["isUrgent"] == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "URGENT",
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
              ),
            ),
          ),
      ],
    );
  }
}
