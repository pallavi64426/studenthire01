import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationPickerSection extends StatefulWidget {
  final TextEditingController locationController;
  final double selectedRadius;
  final Function(double) onRadiusChanged;

  const LocationPickerSection({
    super.key,
    required this.locationController,
    required this.selectedRadius,
    required this.onRadiusChanged,
  });

  @override
  State<LocationPickerSection> createState() => _LocationPickerSectionState();
}

class _LocationPickerSectionState extends State<LocationPickerSection> {
  bool showMapPreview = false;

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
            'Job Location',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.locationController,
            decoration: InputDecoration(
              hintText: 'Enter address or use current location',
              prefixIcon: CustomIconWidget(
                iconName: 'location_on',
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'my_location',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      // Get current location
                      widget.locationController.text = 'Current Location';
                    },
                  ),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: showMapPreview ? 'map' : 'map_outlined',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        showMapPreview = !showMapPreview;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Visibility Radius',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Students within:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${widget.selectedRadius.toInt()} miles',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: colorScheme.primary,
                    inactiveTrackColor:
                        colorScheme.outline.withValues(alpha: 0.3),
                    thumbColor: colorScheme.primary,
                    overlayColor: colorScheme.primary.withValues(alpha: 0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: widget.selectedRadius,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    onChanged: widget.onRadiusChanged,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1 mile',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '50 miles',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showMapPreview) ...[
            SizedBox(height: 2.h),
            Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'map',
                          color: colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Map Preview',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Job visible to students within ${widget.selectedRadius.toInt()} miles',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: colorScheme.onSurface,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            showMapPreview = false;
                          });
                        },
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
