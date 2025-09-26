import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class ApplicationFilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final List<Map<String, dynamic>> applications;

  const ApplicationFilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.applications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filterOptions = _getFilterOptions();

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = selectedFilter == filter['key'];

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter['label'] as String,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (filter['count'] != null && filter['count'] > 0) ...[
                    SizedBox(width: 1.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.onPrimary.withValues(alpha: 0.2)
                            : colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        filter['count'].toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              onSelected: (selected) {
                HapticFeedback.selectionClick();
                onFilterChanged(filter['key'] as String);
              },
              selectedColor: colorScheme.primary,
              checkmarkColor: colorScheme.onPrimary,
              backgroundColor: colorScheme.surface,
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getFilterOptions() {
    // Count applications by status
    final statusCounts = <String, int>{};
    for (final app in applications) {
      final status = (app['status'] as String).toLowerCase();
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    return [
      {
        'key': 'all',
        'label': 'All',
        'count': applications.length,
      },
      {
        'key': 'applied',
        'label': 'Applied',
        'count': statusCounts['applied'] ?? 0,
      },
      {
        'key': 'under review',
        'label': 'Under Review',
        'count': statusCounts['under review'] ?? 0,
      },
      {
        'key': 'interview scheduled',
        'label': 'Interviews',
        'count': statusCounts['interview scheduled'] ?? 0,
      },
      {
        'key': 'offer',
        'label': 'Offers',
        'count': statusCounts['offer'] ?? 0,
      },
      {
        'key': 'rejected',
        'label': 'Rejected',
        'count': statusCounts['rejected'] ?? 0,
      },
    ];
  }
}
