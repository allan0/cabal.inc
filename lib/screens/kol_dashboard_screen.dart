// lib/screens/kol_dashboard_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class KolDashboardScreen extends StatefulWidget {
  final UserProfile userProfile;
  const KolDashboardScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<KolDashboardScreen> createState() => _KolDashboardScreenState();
}

class _KolDashboardScreenState extends State<KolDashboardScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<Map<String, dynamic>>? _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _supabaseService.getKolDashboardData(widget.userProfile.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("KOL Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Error loading dashboard data: ${snapshot.error}"));
            }

            final data = snapshot.data!;
            return _buildDashboardContent(theme, data);
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(ThemeData theme, Map<String, dynamic> data) {
    final totalReferrals = data['total_referrals'] as int? ?? 0;
    final activeReferrals30d = data['active_referrals_30d'] as int? ?? 0;
    final estimatedEarnings = (data['estimated_earnings'] as num? ?? 0.0).toDouble();
    final referralTimeseries = (data['referral_timeseries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final activeTargets = (data['active_targets'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return ListView(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
        left: 16, right: 16, bottom: 40,
      ),
      children: [
        _buildSummaryCards(theme, totalReferrals, activeReferrals30d, estimatedEarnings),
        const SizedBox(height: 24),
        if (referralTimeseries.isNotEmpty)
          _buildChartCard(theme, referralTimeseries),
        const SizedBox(height: 24),
        if (activeTargets.isNotEmpty)
          _buildTargetsSection(theme, activeTargets, totalReferrals),
      ],
    ).animate().fadeIn();
  }

  Widget _buildSummaryCards(ThemeData theme, int totalReferrals, int activeReferrals30d, double estimatedEarnings) {
    return Row(
      children: [
        Expanded(child: _buildMetricCard(theme, "Total Referrals", totalReferrals.toString(), FontAwesomeIcons.users, theme.colorScheme.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard(theme, "Active (30d)", activeReferrals30d.toString(), FontAwesomeIcons.bolt, theme.colorScheme.secondary)),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricCard(theme, "Est. Earnings", NumberFormat.simpleCurrency().format(estimatedEarnings), FontAwesomeIcons.dollarSign, AppColors.success)),
      ],
    );
  }

  Widget _buildMetricCard(ThemeData theme, String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(ThemeData theme, List<Map<String, dynamic>> timeseries) {
    final spots = timeseries.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final count = (entry.value['new_referrals'] as num? ?? 0).toDouble();
      return FlSpot(index, count);
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Referrals (Last 30 Days)", style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
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
                          if (index % 7 == 0 && index < timeseries.length) {
                            final date = DateTime.parse(timeseries[index]['report_date']);
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
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary.withOpacity(0.3), theme.colorScheme.primary.withOpacity(0.0)],
                          begin: Alignment.topCenter, end: Alignment.bottomCenter
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetsSection(ThemeData theme, List<Map<String, dynamic>> targets, int currentReferrals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Active Targets", style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...targets.map((target) {
          final targetUsers = (target['target_users'] as num).toInt();
          final rewardAmount = (target['reward_amount'] as num).toDouble();
          final progress = (currentReferrals / targetUsers).clamp(0.0, 1.0);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Target: Bring ${NumberFormat.compact().format(targetUsers)} Users",
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    "Reward: ${NumberFormat.simpleCurrency().format(rewardAmount)} ${target['reward_currency']}",
                    style: theme.textTheme.titleMedium?.copyWith(color: AppColors.success),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${(progress * 100).toStringAsFixed(1)}%",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${NumberFormat.compact().format(currentReferrals)} / ${NumberFormat.compact().format(targetUsers)} referrals",
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            ),
          );
        })
      ],
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
            Expanded(child: ShimmerWidget.rectangular(height: 120)),
            SizedBox(width: 16),
            Expanded(child: ShimmerWidget.rectangular(height: 120)),
            SizedBox(width: 16),
            Expanded(child: ShimmerWidget.rectangular(height: 120)),
          ],
        ),
        SizedBox(height: 24),
        ShimmerWidget.rectangular(height: 300),
      ],
    );
  }
}
