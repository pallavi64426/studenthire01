import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback onPreview;
  final VoidCallback onPublish;
  final VoidCallback onSaveDraft;
  final bool isFormValid;
  final double estimatedCost;

  const BottomActionBar({
    super.key,
    required this.onPreview,
    required this.onPublish,
    required this.onSaveDraft,
    required this.isFormValid,
    required this.estimatedCost,
  });

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
            if (estimatedCost > 0) ...[
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'account_balance_wallet',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Estimated posting cost: \$${estimatedCost.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'FREE',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: onSaveDraft,
                    icon: CustomIconWidget(
                      iconName: 'save',
                      color: colorScheme.primary,
                      size: 18,
                    ),
                    label: Text('Save Draft'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: isFormValid ? onPreview : null,
                    icon: CustomIconWidget(
                      iconName: 'preview',
                      color: isFormValid
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    label: Text('Preview'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: isFormValid ? onPublish : null,
                    icon: CustomIconWidget(
                      iconName: 'publish',
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
                    label: Text('Publish Job'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      backgroundColor: isFormValid
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      foregroundColor: isFormValid
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            if (!isFormValid) ...[
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Please complete all required fields to publish',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
