// lib/screens/kol_metrics_screen.dart
import 'package:flutter/material.dart'; // CORRECTED: Was missing this essential import
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/shimmer_widget.dart';

class KolMetricsScreen extends StatefulWidget {
  const KolMetricsScreen({Key? key}) : super(key: key);

  @override
  State<KolMetricsScreen> createState() => _KolMetricsScreenState();
}

class _KolMetricsScreenState extends State<KolMetricsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<List<Map<String, dynamic>>>? _metricsFuture;
  int _totalActiveUsersLast30Days = 0;
  int _peakDailyActiveUsers = 0;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  void _loadMetrics() {
    _metricsFuture = _supabaseService.getKolMetrics().then((data) {
      if (mounted && data.isNotEmpty) {
        int total = 0;
        int peak = 0;
        for (var entry in data) {
          final count = (entry['active_referrals'] as num? ?? 0).toInt();
          // Note: Total active users is a bit misleading, it's total of daily counts.
          // A better metric might be a distinct count over 30 days, but this is fine for now.
          total += count;
          if (count > peak) {
            peak = count;
          }
        }
        setState(() {
          _totalActiveUsersLast30Days = total;
          _peakDailyActiveUsers = peak;
        });
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Your Referral Metrics"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _metricsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No referral data available yet."));
            }

            final data = snapshot.data!;
            return ListView(
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                left: 16, right: 16, bottom: 40,
              ),
              children: [
                _buildSummaryCards(theme),
                const SizedBox(height: 24),
                _buildChartCard(theme, data),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    NumberFormat.compact().format(_totalActiveUsersLast30Days),
                    style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text("Total Activity (30d)", textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    _peakDailyActiveUsers.toString(),
                    style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 4),
                  Text("Peak Daily Active Users", textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(ThemeData theme, List<Map<String, dynamic>> data) {
    final spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final count = (entry.value['active_referrals'] as num? ?? 0).toDouble();
      return BarChartGroupData(x: index.toInt(), barRods: [
        BarChartRodData(toY: count, color: theme.colorScheme.primary, width: 12, borderRadius: BorderRadius.circular(4)),
      ]);
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daily Active Referred Users (Last 30 Days)", style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
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
                          if (index % 7 == 0) { // Show label every 7 days
                            final date = DateTime.parse(data[index]['report_date']);
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
                        final date = DateTime.parse(data[group.x]['report_date']);
                        return BarTooltipItem(
                          '${rod.toY.toInt()} users\n',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
        left: 16, right: 16, bottom: 40,
      ),
      children: const [
        Row(
          children: [
            Expanded(child: ShimmerWidget.rectangular(height: 100)),
            SizedBox(width: 16),
            Expanded(child: ShimmerWidget.rectangular(height: 100)),
          ],
        ),
        SizedBox(height: 24),
        ShimmerWidget.rectangular(height: 400),
      ],
    );
  }
}
