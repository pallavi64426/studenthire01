// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  double _payRangeMin = 10;
  double _payRangeMax = 50;
  double _distanceRange = 5;

  final List<String> _jobCategories = [
    'Food Service',
    'Retail',
    'Tutoring',
    'Delivery',
    'Event Staff',
    'Admin',
    'Tech',
    'Creative',
  ];

  final List<String> _scheduleTypes = [
    'Flexible',
    'Part-time',
    'Weekends',
    'Evenings',
    'Remote',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _payRangeMin = (_filters['payRangeMin'] as double?) ?? 10;
    _payRangeMax = (_filters['payRangeMax'] as double?) ?? 50;
    _distanceRange = (_filters['distance'] as double?) ?? 5;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildJobCategorySection(context),
                  SizedBox(height: 3.h),
                  _buildPayRangeSection(context),
                  SizedBox(height: 3.h),
                  _buildDistanceSection(context),
                  SizedBox(height: 3.h),
                  _buildScheduleSection(context),
                  SizedBox(height: 3.h),
                  _buildKarmaSection(context),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter Jobs',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCategorySection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Category',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _jobCategories.map((category) {
            final isSelected =
                (_filters['categories'] as List?)?.contains(category) ?? false;
            return _buildFilterChip(context, category, isSelected, () {
              setState(() {
                final categories = (_filters['categories'] as List?) ?? [];
                if (isSelected) {
                  categories.remove(category);
                } else {
                  categories.add(category);
                }
                _filters['categories'] = categories;
              });
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPayRangeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Pay Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          '\$${_payRangeMin.round()} - \$${_payRangeMax.round()} per hour',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        RangeSlider(
          values: RangeValues(_payRangeMin, _payRangeMax),
          min: 10,
          max: 100,
          divisions: 18,
          labels: RangeLabels(
            '\$${_payRangeMin.round()}',
            '\$${_payRangeMax.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _payRangeMin = values.start;
              _payRangeMax = values.end;
              _filters['payRangeMin'] = _payRangeMin;
              _filters['payRangeMax'] = _payRangeMax;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDistanceSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Within ${_distanceRange.round()} miles',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          value: _distanceRange,
          min: 1,
          max: 25,
          divisions: 24,
          label: '${_distanceRange.round()} mi',
          onChanged: (value) {
            setState(() {
              _distanceRange = value;
              _filters['distance'] = _distanceRange;
            });
          },
        ),
      ],
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Type',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _scheduleTypes.map((schedule) {
            final isSelected =
                (_filters['schedules'] as List?)?.contains(schedule) ?? false;
            return _buildFilterChip(context, schedule, isSelected, () {
              setState(() {
                final schedules = (_filters['schedules'] as List?) ?? [];
                if (isSelected) {
                  schedules.remove(schedule);
                } else {
                  schedules.add(schedule);
                }
                _filters['schedules'] = schedules;
              });
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKarmaSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Karma Points Required',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildKarmaOption(context, 'Any', null),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildKarmaOption(context, '0-50', 50),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildKarmaOption(context, '50-100', 100),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildKarmaOption(context, '100+', 999),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKarmaOption(BuildContext context, String label, int? value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _filters['karmaMax'] == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filters['karmaMax'] = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color:
              isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
        decoration: BoxDecoration(
          color:
              isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _filters.clear();
                  _payRangeMin = 10;
                  _payRangeMax = 50;
                  _distanceRange = 5;
                });
              },
              child: const Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (widget.onFiltersChanged != null) {
                  widget.onFiltersChanged!(_filters);
                }
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
