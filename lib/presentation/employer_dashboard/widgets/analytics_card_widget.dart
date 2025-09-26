// ignore_for_file: unused_local_variable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AnalyticsCardWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> chartData;
  final String chartType;
  final Color? primaryColor;
  final VoidCallback? onTap;

  const AnalyticsCardWidget({
    super.key,
    required this.title,
    required this.chartData,
    this.chartType = 'line',
    this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'analytics',
                  size: 20,
                  color: primaryColor ?? colorScheme.primary,
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 20.h,
              child: _buildChart(context),
            ),
            SizedBox(height: 2.h),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (chartType.toLowerCase()) {
      case 'bar':
        return _buildBarChart(context);
      case 'pie':
        return _buildPieChart(context);
      case 'line':
      default:
        return _buildLineChart(context);
    }
  }

  Widget _buildLineChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colorScheme.outline.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('Mon', style: style);
                    break;
                  case 1:
                    text = const Text('Tue', style: style);
                    break;
                  case 2:
                    text = const Text('Wed', style: style);
                    break;
                  case 3:
                    text = const Text('Thu', style: style);
                    break;
                  case 4:
                    text = const Text('Fri', style: style);
                    break;
                  case 5:
                    text = const Text('Sat', style: style);
                    break;
                  case 6:
                    text = const Text('Sun', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: chartData.asMap().entries.map((entry) {
              final index = entry.key.toDouble();
              final value = (entry.value['value'] ?? 0).toDouble();
              return FlSpot(index, value);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                primaryColor ?? colorScheme.primary,
                (primaryColor ?? colorScheme.primary).withValues(alpha: 0.3),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  (primaryColor ?? colorScheme.primary).withValues(alpha: 0.3),
                  (primaryColor ?? colorScheme.primary).withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: chartData
                .map((e) => (e['value'] ?? 0).toDouble())
                .reduce((a, b) => a > b ? a : b) +
            1,
        barTouchData: BarTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < chartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      chartData[index]['label'] ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: chartData.asMap().entries.map((entry) {
          final index = entry.key;
          final value = (entry.value['value'] ?? 0).toDouble();
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: primaryColor ?? colorScheme.primary,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: chartData.asMap().entries.map((entry) {
          final index = entry.key;
          final value = (entry.value['value'] ?? 0).toDouble();
          final colors = [
            primaryColor ?? colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
            Colors.orange,
            Colors.purple,
          ];

          return PieChartSectionData(
            color: colors[index % colors.length],
            value: value,
            title: '${value.toInt()}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (chartType.toLowerCase() == 'pie') {
      final colors = [
        primaryColor ?? colorScheme.primary,
        colorScheme.secondary,
        colorScheme.tertiary,
        Colors.orange,
        Colors.purple,
      ];

      return Wrap(
        spacing: 4.w,
        runSpacing: 1.h,
        children: chartData.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value['label'] ?? '';

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }).toList(),
      );
    }

    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: primaryColor ?? colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          'Applications',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
