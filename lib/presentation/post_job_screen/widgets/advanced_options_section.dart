import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdvancedOptionsSection extends StatefulWidget {
  final DateTime? applicationDeadline;
  final Function(DateTime?) onDeadlineChanged;
  final List<String> screeningQuestions;
  final Function(List<String>) onScreeningQuestionsChanged;
  final bool autoResponse;
  final Function(bool) onAutoResponseChanged;
  final String autoResponseMessage;
  final Function(String) onAutoResponseMessageChanged;

  const AdvancedOptionsSection({
    super.key,
    this.applicationDeadline,
    required this.onDeadlineChanged,
    required this.screeningQuestions,
    required this.onScreeningQuestionsChanged,
    required this.autoResponse,
    required this.onAutoResponseChanged,
    required this.autoResponseMessage,
    required this.onAutoResponseMessageChanged,
  });

  @override
  State<AdvancedOptionsSection> createState() => _AdvancedOptionsSectionState();
}

class _AdvancedOptionsSectionState extends State<AdvancedOptionsSection> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _autoResponseController = TextEditingController();
  bool _isExpanded = false;

  final List<String> commonQuestions = [
    'What is your availability for this position?',
    'Do you have any relevant experience?',
    'Why are you interested in this role?',
    'What are your salary expectations?',
    'Can you provide references?',
    'Do you have reliable transportation?',
    'Are you comfortable working weekends?',
  ];

  @override
  void initState() {
    super.initState();
    _autoResponseController.text = widget.autoResponseMessage;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _autoResponseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Advanced Options',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            SizedBox(height: 2.h),
            // Application Deadline
            Text(
              'Application Deadline',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: widget.applicationDeadline ??
                      DateTime.now().add(Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                widget.onDeadlineChanged(date);
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
                      iconName: 'calendar_today',
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        widget.applicationDeadline != null
                            ? '${widget.applicationDeadline!.day}/${widget.applicationDeadline!.month}/${widget.applicationDeadline!.year}'
                            : 'No deadline (recommended)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: widget.applicationDeadline != null
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (widget.applicationDeadline != null)
                      GestureDetector(
                        onTap: () => widget.onDeadlineChanged(null),
                        child: CustomIconWidget(
                          iconName: 'clear',
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
            // Screening Questions
            Text(
              'Screening Questions',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Add a custom question...',
                suffixIcon: IconButton(
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: () {
                    if (_questionController.text.trim().isNotEmpty) {
                      List<String> newQuestions =
                          List.from(widget.screeningQuestions);
                      newQuestions.add(_questionController.text.trim());
                      widget.onScreeningQuestionsChanged(newQuestions);
                      _questionController.clear();
                    }
                  },
                ),
              ),
            ),
            if (widget.screeningQuestions.isNotEmpty) ...[
              SizedBox(height: 1.h),
              ...widget.screeningQuestions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          List<String> newQuestions =
                              List.from(widget.screeningQuestions);
                          newQuestions.removeAt(index);
                          widget.onScreeningQuestionsChanged(newQuestions);
                        },
                        child: CustomIconWidget(
                          iconName: 'delete',
                          color: colorScheme.error,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
            SizedBox(height: 1.h),
            Text(
              'Common Questions',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: commonQuestions.map((question) {
                final isAdded = widget.screeningQuestions.contains(question);
                return GestureDetector(
                  onTap: isAdded
                      ? null
                      : () {
                          List<String> newQuestions =
                              List.from(widget.screeningQuestions);
                          newQuestions.add(question);
                          widget.onScreeningQuestionsChanged(newQuestions);
                        },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: isAdded
                          ? colorScheme.surfaceContainerHighest
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isAdded
                            ? colorScheme.outline.withValues(alpha: 0.3)
                            : colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      question,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isAdded
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
            // Auto Response
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Automatic Response',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: widget.autoResponse,
                  onChanged: widget.onAutoResponseChanged,
                ),
              ],
            ),
            if (widget.autoResponse) ...[
              SizedBox(height: 1.h),
              TextFormField(
                controller: _autoResponseController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Thank you for your application! We will review it and get back to you soon.',
                  labelText: 'Auto-response message',
                ),
                onChanged: widget.onAutoResponseMessageChanged,
              ),
            ],
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Auto-responses help maintain good communication with applicants',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
