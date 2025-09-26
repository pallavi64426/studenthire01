import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../widgets/custom_icon_widget.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final bool isEditMode;
  final Function(Map<String, dynamic>) onProfileUpdate;

  const ProfileHeaderWidget({
    super.key,
    required this.profileData,
    required this.isEditMode,
    required this.onProfileUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.secondaryContainer.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          // Profile photo and edit overlay
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 15.w,
                backgroundColor: colorScheme.primaryContainer,
                child: CircleAvatar(
                  radius: 14.5.w,
                  backgroundImage: CachedNetworkImageProvider(
                    profileData['profileImage'] as String,
                  ),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle error
                  },
                  child: (profileData['profileImage'] as String).isEmpty
                      ? CustomIconWidget(
                          iconName: 'person',
                          size: 20.w,
                          color: colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
              ),
              if (isEditMode)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showPhotoOptions(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        size: 20,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              if (profileData['verified'] as bool)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'verified',
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),

          // Name and university
          Text(
            profileData['name'] as String,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'school',
                size: 16,
                color: colorScheme.primary,
              ),
              SizedBox(width: 1.w),
              Text(
                '${profileData['university']} • ${profileData['year']}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            profileData['major'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Karma points and level
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'stars',
                      size: 24,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${profileData['karmaPoints']} Karma Points',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  profileData['karmaLevel'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),

                // Progress bar to next level
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Next Level Progress',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${profileData['nextLevelPoints'] - profileData['karmaPoints']} points to go',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: (profileData['karmaPoints'] as int) /
                          (profileData['nextLevelPoints'] as int),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildPhotoOption(
                context,
                'Camera',
                'camera_alt',
                () {
                  Navigator.pop(context);
                  // Open camera
                },
              ),
              _buildPhotoOption(
                context,
                'Photo Library',
                'photo_library',
                () {
                  Navigator.pop(context);
                  // Open gallery
                },
              ),
              if ((profileData['profileImage'] as String).isNotEmpty)
                _buildPhotoOption(
                  context,
                  'Remove Photo',
                  'delete',
                  () {
                    Navigator.pop(context);
                    onProfileUpdate({'profileImage': ''});
                  },
                  isDestructive: true,
                ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoOption(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isDestructive ? colorScheme.error : null,
        ),
      ),
      onTap: onTap,
    );
  }
}
