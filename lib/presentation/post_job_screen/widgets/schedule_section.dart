import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ScheduleSection extends StatefulWidget {
  final String selectedScheduleType;
  final Function(String) onScheduleTypeChanged;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(TimeOfDay?) onStartTimeChanged;
  final Function(TimeOfDay?) onEndTimeChanged;
  final List<String> selectedDays;
  final Function(List<String>) onDaysChanged;

  const ScheduleSection({
    super.key,
    required this.selectedScheduleType,
    required this.onScheduleTypeChanged,
    this.startTime,
    this.endTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.selectedDays,
    required this.onDaysChanged,
  });

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  final List<String> scheduleTypes = [
    'Fixed Schedule',
    'Flexible Hours',
    'One-time Gig',
    'Project Based'
  ];

  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  bool showCalendarPreview = false;

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
            'Schedule & Timing',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Schedule Type',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: scheduleTypes.map((type) {
              final isSelected = type == widget.selectedScheduleType;
              return GestureDetector(
                onTap: () => widget.onScheduleTypeChanged(type),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    type,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (widget.selectedScheduleType == 'Fixed Schedule') ...[
            SizedBox(height: 3.h),
            Text(
              'Working Days',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) {
                final isSelected = widget.selectedDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    List<String> newDays = List.from(widget.selectedDays);
                    if (isSelected) {
                      newDays.remove(day);
                    } else {
                      newDays.add(day);
                    }
                    widget.onDaysChanged(newDays);
                  },
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: widget.startTime ?? TimeOfDay.now(),
                          );
                          widget.onStartTimeChanged(time);
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
                                iconName: 'access_time',
                                color: colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                widget.startTime?.format(context) ?? 'Select',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: widget.startTime != null
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Time',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: widget.endTime ?? TimeOfDay.now(),
                          );
                          widget.onEndTimeChanged(time);
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
                                iconName: 'access_time',
                                color: colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                widget.endTime?.format(context) ?? 'Select',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: widget.endTime != null
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  showCalendarPreview = !showCalendarPreview;
                });
              },
              icon: CustomIconWidget(
                iconName: 'calendar_month',
                color: colorScheme.primary,
                size: 16,
              ),
              label: Text(
                showCalendarPreview ? 'Hide Preview' : 'Preview Schedule',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showCalendarPreview) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Schedule Preview',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if (widget.selectedDays.isNotEmpty &&
                        widget.startTime != null &&
                        widget.endTime != null) ...[
                      Text(
                        '${widget.selectedDays.join(', ')}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${widget.startTime!.format(context)} - ${widget.endTime!.format(context)}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Complete the schedule details to see preview',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
