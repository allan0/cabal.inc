// lib/screens/tokenomics_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/utils/app_colors.dart';

class TokenomicsScreen extends StatefulWidget {
  const TokenomicsScreen({Key? key}) : super(key: key);

  @override
  State<TokenomicsScreen> createState() => _TokenomicsScreenState();
}

class _TokenomicsScreenState extends State<TokenomicsScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Cabal Tokenomics"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16,
            right: 16,
            bottom: 40,
          ),
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildChartSection(),
            const SizedBox(height: 24),
            _buildAllocationDetails(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$CBL Token",
          style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Total Supply: 100,000,000",
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          "Powering a decentralized ecosystem for growth, community, and opportunity.",
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: showingSections(),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final isTouched = (int index) => index == touchedIndex;
    final fontSize = (int index) => isTouched(index) ? 20.0 : 14.0;
    final radius = (int index) => isTouched(index) ? 60.0 : 50.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    // --- UPDATED ALLOCATION ---
    final data = [
      {'value': 60.0, 'title': '60%', 'color': AppColors.primaryAccent}, // Community
      {'value': 15.0, 'title': '15%', 'color': AppColors.tertiaryAccent}, // Partners
      {'value': 15.0, 'title': '15%', 'color': AppColors.gold},           // Investors
      {'value': 10.0, 'title': '10%', 'color': AppColors.warning},        // Team
    ];

    return List.generate(data.length, (i) {
      return PieChartSectionData(
        color: data[i]['color'] as Color,
        value: data[i]['value'] as double,
        title: data[i]['title'] as String,
        radius: radius(i),
        titleStyle: TextStyle(
          fontSize: fontSize(i),
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  Widget _buildAllocationDetails(ThemeData theme) {
    return Column(
      children: [
        // --- UPDATED DETAILS ---
        _buildDetailRow(
          color: AppColors.primaryAccent,
          title: "Community & Ecosystem Growth (60%)",
          subtitle: "Quest rewards, airdrops, KOL incentives, and prizes for the first 2M users.",
          icon: FontAwesomeIcons.users,
        ),
        _buildDetailRow(
          color: AppColors.tertiaryAccent,
          title: "Partners & Alliances (15%)",
          subtitle: "For gaming guilds, DAOs, and projects integrating with Cabal.",
          icon: FontAwesomeIcons.handshake,
        ),
        _buildDetailRow(
          color: AppColors.gold,
          title: "Early Investors (15%)",
          subtitle: "For our foundational backers. Subject to vesting schedules.",
          icon: FontAwesomeIcons.seedling,
        ),
        _buildDetailRow(
          color: AppColors.warning,
          title: "Core Team (10%)",
          subtitle: "For the builders. Locked for 9 months, then linear vesting.",
          icon: FontAwesomeIcons.peopleGroup,
        ),
      ],
    );
  }

  Widget _buildDetailRow({required Color color, required String title, required String subtitle, required IconData icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: FaIcon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
