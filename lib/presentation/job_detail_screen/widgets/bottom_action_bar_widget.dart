import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BottomActionBarWidget extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final bool isApplied;
  final VoidCallback onApply;
  final VoidCallback onMessage;

  const BottomActionBarWidget({
    super.key,
    required this.jobData,
    required this.isApplied,
    required this.onApply,
    required this.onMessage,
  });

  @override
  State<BottomActionBarWidget> createState() => _BottomActionBarWidgetState();
}

class _BottomActionBarWidgetState extends State<BottomActionBarWidget> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Action buttons row
            Row(
              children: [
                // Bookmark button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isBookmarked = !_isBookmarked;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: _isBookmarked
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: _isBookmarked
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
                      color: _isBookmarked
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Share button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showShareOptions(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'share',
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Message button
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onMessage();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'message',
                            color: colorScheme.onSurfaceVariant,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Message',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Apply button
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (!widget.isApplied) {
                        widget.onApply();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.w),
                      decoration: BoxDecoration(
                        color: widget.isApplied
                            ? colorScheme.surfaceContainerHighest
                            : colorScheme.primary,
                        borderRadius: BorderRadius.circular(2.w),
                        border: widget.isApplied
                            ? Border.all(
                                color:
                                    colorScheme.outline.withValues(alpha: 0.3),
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName:
                                widget.isApplied ? 'check_circle' : 'send',
                            color: widget.isApplied
                                ? colorScheme.tertiary
                                : colorScheme.onPrimary,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            widget.isApplied ? 'Applied' : 'Apply Now',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: widget.isApplied
                                  ? colorScheme.tertiary
                                  : colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Application status or estimated response time
            if (widget.isApplied) ...[
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: colorScheme.onTertiaryContainer,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Application sent successfully. You\'ll hear back within 24 hours.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                'Share Job',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 3.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    context,
                    icon: 'link',
                    label: 'Copy Link',
                    onTap: () {
                      Navigator.pop(context);
                      // Copy link functionality
                    },
                  ),
                  _buildShareOption(
                    context,
                    icon: 'message',
                    label: 'Message',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/messages-screen');
                    },
                  ),
                  _buildShareOption(
                    context,
                    icon: 'share',
                    label: 'More',
                    onTap: () {
                      Navigator.pop(context);
                      // System share functionality
                    },
                  ),
                ],
              ),

              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
