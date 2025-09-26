import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchHeaderWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String locationText;
  final VoidCallback? onFilterTap;
  final VoidCallback? onLocationTap;
  final ValueChanged<String>? onSearchChanged;

  const SearchHeaderWidget({
    super.key,
    required this.searchController,
    required this.locationText,
    this.onFilterTap,
    this.onLocationTap,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchBar(context),
          SizedBox(height: 1.h),
          _buildLocationIndicator(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search jobs, companies...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'tune',
                color: colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onLocationTap,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'location_on',
            color: colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            locationText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 1.w),
          CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: colorScheme.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }
}
