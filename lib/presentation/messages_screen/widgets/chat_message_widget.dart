// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final bool showTimestamp;
  final VoidCallback? onImageTap;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.showTimestamp = false,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showTimestamp) ...[
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message['dateGroup'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
          Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isCurrentUser) ...[
                _buildAvatar(colorScheme),
                SizedBox(width: 2.w),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 75.w),
                  child: _buildMessageBubble(context, colorScheme),
                ),
              ),
              if (isCurrentUser) ...[
                SizedBox(width: 2.w),
                _buildMessageStatus(colorScheme),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: CustomImageWidget(
          imageUrl: message['senderAvatar'] as String,
          width: 8.w,
          height: 8.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final messageType = message['type'] as String? ?? 'text';

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? colorScheme.primary : colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
          bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
        ),
        border: !isCurrentUser
            ? Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (messageType == 'image')
            _buildImageMessage(context, colorScheme)
          else if (messageType == 'job_context')
            _buildJobContextMessage(context, colorScheme)
          else
            _buildTextMessage(context, colorScheme),
          _buildMessageFooter(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTextMessage(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 3.w, 4.w, 1.w),
      child: Text(
        message['content'] as String,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isCurrentUser ? colorScheme.onPrimary : colorScheme.onSurface,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: onImageTap,
      child: Container(
        margin: EdgeInsets.all(1.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomImageWidget(
            imageUrl: message['imageUrl'] as String,
            width: double.infinity,
            height: 40.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildJobContextMessage(
      BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final jobData = message['jobData'] as Map<String, dynamic>;

    return Container(
      margin: EdgeInsets.all(2.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: isCurrentUser ? 0.2 : 1.0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'work',
                color: colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  jobData['title'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isCurrentUser
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            jobData['company'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isCurrentUser
                  ? colorScheme.onPrimary.withValues(alpha: 0.8)
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  jobData['status'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 9.sp,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                jobData['salary'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isCurrentUser
                      ? colorScheme.onPrimary.withValues(alpha: 0.8)
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFooter(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message['timestamp'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isCurrentUser
                  ? colorScheme.onPrimary.withValues(alpha: 0.7)
                  : colorScheme.onSurfaceVariant,
              fontSize: 9.sp,
            ),
          ),
          if (isCurrentUser && message['isDelivered'] == true) ...[
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: message['isRead'] == true ? 'done_all' : 'done',
              color: message['isRead'] == true
                  ? Colors.blue
                  : colorScheme.onPrimary.withValues(alpha: 0.7),
              size: 12,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageStatus(ColorScheme colorScheme) {
    if (!isCurrentUser) return const SizedBox.shrink();

    return Column(
      children: [
        if (message['isDelivered'] == true)
          CustomIconWidget(
            iconName: message['isRead'] == true ? 'done_all' : 'done',
            color: message['isRead'] == true
                ? Colors.blue
                : colorScheme.onSurfaceVariant,
            size: 16,
          )
        else
          CustomIconWidget(
            iconName: 'schedule',
            color: colorScheme.onSurfaceVariant,
            size: 16,
          ),
      ],
    );
  }
}
