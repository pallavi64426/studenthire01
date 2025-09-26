import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConversationItemWidget extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkUnread;
  final VoidCallback? onBlock;

  const ConversationItemWidget({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onArchive,
    this.onDelete,
    this.onMarkUnread,
    this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isUnread = conversation['isUnread'] ?? false;
    final int unreadCount = conversation['unreadCount'] ?? 0;
    final String jobStatus = conversation['jobStatus'] ?? 'active';
    final bool isTyping = conversation['isTyping'] ?? false;

    return Dismissible(
      key: Key(conversation['id'].toString()),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onArchive?.call();
        } else {
          onDelete?.call();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isUnread
              ? colorScheme.primary.withValues(alpha: 0.05)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? colorScheme.primary.withValues(alpha: 0.2)
                : colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  _buildProfileImage(colorScheme),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                conversation['name'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: isUnread
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildJobStatusBadge(colorScheme, jobStatus),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          conversation['jobTitle'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Expanded(
                              child: isTyping
                                  ? _buildTypingIndicator(colorScheme)
                                  : Text(
                                      conversation['lastMessage'] as String,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: isUnread
                                            ? colorScheme.onSurface
                                            : colorScheme.onSurfaceVariant,
                                        fontWeight: isUnread
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                            ),
                            SizedBox(width: 2.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  conversation['timestamp'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isUnread
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: isUnread
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                                if (unreadCount > 0) ...[
                                  SizedBox(height: 0.5.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(minWidth: 5.w),
                                    child: Text(
                                      unreadCount > 99
                                          ? '99+'
                                          : unreadCount.toString(),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(ColorScheme colorScheme) {
    return Stack(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: conversation['avatar'] as String,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (conversation['isOnline'] == true)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildJobStatusBadge(ColorScheme colorScheme, String status) {
    Color badgeColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'active':
        badgeColor = Colors.green;
        statusText = 'Active';
        break;
      case 'completed':
        badgeColor = colorScheme.primary;
        statusText = 'Completed';
        break;
      case 'cancelled':
        badgeColor = colorScheme.error;
        statusText = 'Cancelled';
        break;
      default:
        badgeColor = colorScheme.outline;
        statusText = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: badgeColor,
          fontSize: 9.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme colorScheme) {
    return Row(
      children: [
        Text(
          'Typing',
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 12.sp,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 1.w),
        SizedBox(
          width: 6.w,
          height: 2.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 600 + (index * 200)),
                width: 1.w,
                height: 1.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? Colors.blue : colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'archive' : 'delete',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Archive' : 'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
