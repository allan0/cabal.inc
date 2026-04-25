// lib/screens/leaderboard_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_service.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/shimmer_widget.dart';
import '../utils/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  final String? currentUserId;

  const LeaderboardScreen({
    Key? key,
    this.currentUserId,
  }) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabaseService = SupabaseService();
  List<UserProfile> _leaderboardUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLeaderboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchLeaderboardData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final users = await _supabaseService.getAllUsersForLeaderboard();
      if (mounted) {
        setState(() {
          _leaderboardUsers = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load leaderboard. Please try again.";
        });
      }
    }
  }

  void _navigateToUserProfile(String userId) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: DashboardScreen(
          viewProfileId: userId,
          isLoadingProfile: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Global Leaderboard'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.rankingStar), text: 'Rank'),
            Tab(icon: FaIcon(FontAwesomeIcons.chartSimple), text: 'Activity'),
          ],
        ),
      ),
      body: DiamondMeshBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height) + MediaQuery.of(context).padding.top),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildRankView(),
              _buildActivityView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankView() {
    if (_isLoading) return _buildLoadingState();
    if (_errorMessage != null) return _buildErrorState(_errorMessage!);
    if (_leaderboardUsers.isEmpty) return _buildEmptyState();

    final xpFormatter = NumberFormat.compact();
    
    return RefreshIndicator(
      onRefresh: _fetchLeaderboardData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _leaderboardUsers.length,
        itemBuilder: (context, index) {
          final user = _leaderboardUsers[index];
          final rank = index + 1;
          final bool isCurrentUser = user.id == widget.currentUserId;
          final theme = Theme.of(context);

          return Card(
            elevation: isCurrentUser ? 4 : 2,
            color: isCurrentUser 
              ? theme.colorScheme.primary.withOpacity(0.15) 
              : theme.cardColor.withOpacity(0.8),
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isCurrentUser 
                ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
                : BorderSide.none,
            ),
            child: ListTile(
              onTap: () => _navigateToUserProfile(user.id),
              leading: SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    "#$rank", 
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isCurrentUser ? theme.colorScheme.primary : null,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
              title: Text(user.displayName ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text("Level ${user.level}"),
              trailing: Text(
                '${xpFormatter.format(user.totalXp)} XP', 
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary, 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildActivityView() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) return _buildErrorState(_errorMessage!);
    if (_leaderboardUsers.isEmpty) return _buildEmptyState();

    final theme = Theme.of(context);
    final xpBrackets = [0, 100, 250, 500, 1000, 2500, 5000, 10000];
    final distribution = List.filled(xpBrackets.length, 0);
    int maxCount = 0;

    for (final user in _leaderboardUsers) {
      for (int i = xpBrackets.length - 1; i >= 0; i--) {
        if (user.totalXp >= xpBrackets[i]) {
          distribution[i]++;
          if (distribution[i] > maxCount) {
            maxCount = distribution[i];
          }
          break;
        }
      }
    }
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("User XP Distribution", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text("Shows how many users are in each XP bracket.", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 32),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (maxCount * 1.2).toDouble(), // Add some padding to the top
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.darkGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} Users',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= xpBrackets.length) return const Text('');
                      return SideTitleWidget(axisSide: meta.axisSide, child: Text(NumberFormat.compact().format(xpBrackets[index]), style: theme.textTheme.bodySmall));
                    }, reservedSize: 30)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(xpBrackets.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [BarChartRodData(toY: distribution[index].toDouble(), color: theme.colorScheme.primary, width: 16, borderRadius: BorderRadius.circular(4))],
                    );
                  }),
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
      padding: const EdgeInsets.all(16.0),
      children: List.generate(10, (index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        child: ShimmerWidget.rectangular(height: 60),
      )),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.circleExclamation, size: 50, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Retry"),
            onPressed: _fetchLeaderboardData,
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.ghost, size: 50, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text("The leaderboard is currently empty.", style: theme.textTheme.titleMedium),
          Text("Be the first to climb!", style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
        ],
      ),
    );
  }
}
