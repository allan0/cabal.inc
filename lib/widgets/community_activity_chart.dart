// lib/widgets/community_activity_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';

class CommunityActivityChart extends StatelessWidget {
  final List<Map<String, dynamic>> activityData; // Expects [{'date': ISO_STRING, 'count': INT}]

  const CommunityActivityChart({Key? key, required this.activityData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spots = activityData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final count = (entry.value['count'] as num? ?? 0).toDouble();
      return BarChartGroupData(x: index.toInt(), barRods: [
        BarChartRodData(
          toY: count,
          color: theme.colorScheme.primary,
          width: 5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          )
        ),
      ]);
    }).toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Activity (Last 30 Days)", style: theme.textTheme.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: spots,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index % 7 == 0 && index < activityData.length) { 
                            final date = DateTime.parse(activityData[index]['date']);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(DateFormat('MMM d').format(date), style: theme.textTheme.bodySmall),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                   barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.darkGrey.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex >= activityData.length) return null;
                        final date = DateTime.parse(activityData[group.x]['date']);
                        return BarTooltipItem(
                          '${rod.toY.toInt()} posts\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: DateFormat('MMM d, yyyy').format(date),
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
