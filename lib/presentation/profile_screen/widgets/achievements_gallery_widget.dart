import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class AchievementsGalleryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementsGalleryWidget({
    super.key,
    required this.achievements,
  });

  @override
  State<AchievementsGalleryWidget> createState() =>
      _AchievementsGalleryWidgetState();
}

class _AchievementsGalleryWidgetState extends State<AchievementsGalleryWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = [];
    _scaleAnimations = [];

    for (int i = 0; i < widget.achievements.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 300 + (i * 100)),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));

      _animationControllers.add(controller);
      _scaleAnimations.add(animation);
    }

    // Start animations after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      for (var controller in _animationControllers) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'emoji_events',
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Achievements',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_getUnlockedCount()}/${widget.achievements.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Achievements grid
          Padding(
            padding: EdgeInsets.all(4.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.w,
                childAspectRatio: 1.1,
              ),
              itemCount: widget.achievements.length,
              itemBuilder: (context, index) {
                final achievement = widget.achievements[index];
                return AnimatedBuilder(
                  animation: _scaleAnimations[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: _buildAchievementCard(context, achievement, index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      BuildContext context, Map<String, dynamic> achievement, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isUnlocked = achievement['unlocked'] as bool;
    final achievementColor = achievement['color'] as Color;
    final progress = achievement['progress'] as int?;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showAchievementDetails(context, achievement);
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isUnlocked
              ? achievementColor.withValues(alpha: 0.1)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? achievementColor.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: achievementColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Achievement icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? achievementColor.withValues(alpha: 0.2)
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: achievement['icon'] as String,
                    color: isUnlocked
                        ? achievementColor
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 32,
                  ),
                ),
                if (!isUnlocked)
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'lock',
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),

            // Achievement title
            Text(
              achievement['title'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isUnlocked
                    ? achievementColor
                    : colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Progress indicator for locked achievements
            if (!isUnlocked && progress != null) ...[
              SizedBox(height: 1.h),
              LinearProgressIndicator(
                value: progress / 100.0,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(achievementColor),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '$progress%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: achievementColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            // Unlock date for unlocked achievements
            if (isUnlocked && achievement.containsKey('unlockedDate')) ...[
              SizedBox(height: 1.h),
              Text(
                'Unlocked ${_formatDate(achievement['unlockedDate'] as String)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final achievementColor = achievement['color'] as Color;
    final isUnlocked = achievement['unlocked'] as bool;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Achievement icon
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: achievementColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: achievement['icon'] as String,
                  color: achievementColor,
                  size: 48,
                ),
              ),
              SizedBox(height: 3.h),

              // Title and status
              Text(
                achievement['title'] as String,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: achievementColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isUnlocked ? 'UNLOCKED' : 'LOCKED',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isUnlocked ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Description
              Text(
                achievement['description'] as String,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              // Progress or unlock date
              if (!isUnlocked && achievement.containsKey('progress')) ...[
                SizedBox(height: 3.h),
                LinearProgressIndicator(
                  value: (achievement['progress'] as int) / 100.0,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(achievementColor),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${achievement['progress']}% Complete',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: achievementColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else if (isUnlocked) ...[
                SizedBox(height: 2.h),
                Text(
                  'Unlocked on ${_formatDate(achievement['unlockedDate'] as String)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],

              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getUnlockedCount() {
    return widget.achievements
        .where((achievement) => achievement['unlocked'] as bool)
        .length;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
