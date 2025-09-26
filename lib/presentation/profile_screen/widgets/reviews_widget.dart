import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../widgets/custom_icon_widget.dart';

class ReviewsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;

  const ReviewsWidget({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

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
          // Header with rating summary
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'star',
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Reviews',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildRatingBreakdown(context),
              ],
            ),
          ),

          // Reviews list
          if (reviews.isEmpty)
            _buildEmptyReviews(context)
          else
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: reviews
                    .take(3)
                    .map((review) => _buildReviewItem(context, review))
                    .toList(),
              ),
            ),

          // View all reviews button
          if (reviews.length > 3)
            Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 4.w),
              child: TextButton(
                onPressed: () {
                  _showAllReviews(context);
                },
                child: Text('View All ${reviews.length} Reviews'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRatingBreakdown(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate rating distribution
    final ratingCounts = List<int>.filled(5, 0);
    for (final review in reviews) {
      final rating = review['rating'] as int;
      if (rating >= 1 && rating <= 5) {
        ratingCounts[rating - 1]++;
      }
    }

    return Column(
      children: [
        for (int i = 4; i >= 0; i--)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            child: Row(
              children: [
                Text(
                  '${i + 1}',
                  style: theme.textTheme.labelSmall,
                ),
                SizedBox(width: 1.w),
                CustomIconWidget(
                  iconName: 'star',
                  size: 12,
                  color: Colors.amber,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: LinearProgressIndicator(
                    value:
                        reviews.isEmpty ? 0 : ratingCounts[i] / reviews.length,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${ratingCounts[i]}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReviewItem(BuildContext context, Map<String, dynamic> review) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info and rating
          Row(
            children: [
              CircleAvatar(
                radius: 5.w,
                backgroundImage: CachedNetworkImageProvider(
                  review['employerAvatar'] as String,
                ),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error
                },
                child: (review['employerAvatar'] as String).isEmpty
                    ? CustomIconWidget(
                        iconName: 'business',
                        color: colorScheme.onPrimaryContainer,
                        size: 5.w,
                      )
                    : null,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['employerName'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Job: ${review['jobTitle']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
                        5,
                        (index) => CustomIconWidget(
                          iconName: index < (review['rating'] as int)
                              ? 'star'
                              : 'star_border',
                          size: 14,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatDate(review['date'] as String),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Review comment
          Text(
            review['comment'] as String,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),

          // Helpful counter
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  // Mark as helpful
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'thumb_up',
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Helpful (${review['helpful']})',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReviews(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'rate_review',
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Reviews Yet',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete your first job to start receiving reviews from employers',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAllReviews(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 85.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'All Reviews (${reviews.length})',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return _buildReviewItem(context, reviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 30) {
        return '$difference days ago';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
