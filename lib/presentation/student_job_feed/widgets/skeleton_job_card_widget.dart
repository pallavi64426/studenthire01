import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SkeletonJobCardWidget extends StatefulWidget {
  const SkeletonJobCardWidget({super.key});

  @override
  State<SkeletonJobCardWidget> createState() => _SkeletonJobCardWidgetState();
}

class _SkeletonJobCardWidgetState extends State<SkeletonJobCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
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
                _buildSkeletonHeader(colorScheme),
                SizedBox(height: 1.h),
                _buildSkeletonTitle(colorScheme),
                SizedBox(height: 0.5.h),
                _buildSkeletonCompany(colorScheme),
                SizedBox(height: 1.h),
                _buildSkeletonPayDistance(colorScheme),
                SizedBox(height: 1.h),
                _buildSkeletonSkills(colorScheme),
                SizedBox(height: 1.h),
                _buildSkeletonKarma(colorScheme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonHeader(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const Spacer(),
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonTitle(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          width: 40.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonCompany(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 25.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 3.w),
        Container(
          width: 20.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonPayDistance(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        SizedBox(width: 3.w),
        Container(
          width: 12.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Spacer(),
        Container(
          width: 10.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonSkills(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 2.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        SizedBox(width: 2.w),
        Container(
          width: 18.w,
          height: 2.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        SizedBox(width: 2.w),
        Container(
          width: 12.w,
          height: 2.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonKarma(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const Spacer(),
        Container(
          width: 12.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
