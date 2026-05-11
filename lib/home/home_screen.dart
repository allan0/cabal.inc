// lib/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/cabal_model.dart';
import '../models/quest_model.dart';
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import '../services/ton_service.dart';
import '../utils/app_colors.dart';
import '../widgets/quest_card.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/shimmer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  bool _isLoading = true;
  UserProfile? _userProfile;
  List<Cabal> _featuredCabals = [];
  List<Quest> _dailyQuests = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  /// Refreshes all dashboard data from Supabase and the TON Blockchain
  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = _supabaseService.getCurrentUser();
      if (user != null) {
        _userProfile = await _supabaseService.getUserProfile(user.id);
      }

      // Fetch Cabals and Quests in parallel
      final results = await Future.wait([
        _supabaseService.getAllCabals(),
        // For now, we fetch global/featured quests or quests from the first cabal
      ]);

      _featuredCabals = (results[0] as List<Cabal>).take(5).toList();
      
      if (_featuredCabals.isNotEmpty) {
        _dailyQuests = await _supabaseService.getQuestsForCabal(_featuredCabals.first.id);
      }

    } catch (e) {
      debugPrint("HomeScreen: Error loading data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tonService = Provider.of<TonService>(context);

    return Scaffold(
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: AppColors.gold,
          backgroundColor: AppColors.darkGrey,
          child: CustomScrollView(
            slivers: [
              // --- 1. THE COMMANDER HEADER ---
              _buildSliverHeader(tonService),

              // --- 2. QUICK ACTIONS ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: _buildQuickActions(context),
                ),
              ),

              // --- 3. FEATURED PARTNERS ---
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "FEATURED CABALS",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeaturedScroll(),
                  ],
                ),
              ),

              // --- 4. DAILY QUEST FEED ---
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "DAILY MISSIONS",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppColors.gold,
                            ),
                          ),
                          if (_userProfile != null)
                            Text(
                              "Level ${_userProfile!.level}",
                              style: const TextStyle(color: AppColors.greyText, fontSize: 12),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_isLoading)
                        ...List.generate(3, (index) => const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: ShimmerWidget.rectangular(height: 100),
                        ))
                      else if (_dailyQuests.isEmpty)
                        _buildEmptyQuests()
                      else
                        ..._dailyQuests.map((quest) => QuestCard(
                          quest: quest,
                          onComplete: () => _loadDashboardData(),
                        )).toList(),
                      const SizedBox(height: 100), // Bottom padding for FAB/Nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader(TonService ton) {
    final bool hasWallet = ton.isConnected;
    final String displayAddress = hasWallet 
        ? "${ton.currentAddress!.substring(0, 6)}...${ton.currentAddress!.substring(ton.currentAddress!.length - 4)}"
        : "No Wallet Connected";

    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.black.withOpacity(0.5),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.offBlack, AppColors.gold.withOpacity(0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16).copyWith(top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userProfile?.displayName ?? "Explorer",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => hasWallet ? null : ton.connectWallet(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: hasWallet ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: hasWallet ? AppColors.success.withOpacity(0.5) : AppColors.error.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                hasWallet ? FontAwesomeIcons.wallet : FontAwesomeIcons.linkSlash,
                                size: 10,
                                color: hasWallet ? AppColors.success : AppColors.error,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                displayAddress,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: hasWallet ? AppColors.success : AppColors.error,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildXpBadge(),
                ],
              ),
              const Spacer(),
              _buildXpProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXpBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(
            NumberFormat.compact().format(_userProfile?.totalXp ?? 0),
            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text("XP", style: TextStyle(fontSize: 8, color: AppColors.greyText)),
        ],
      ),
    ).animate().scale(delay: 400.ms, curve: Curves.elasticOut);
  }

  Widget _buildXpProgressBar() {
    if (_userProfile == null) return const SizedBox.shrink();
    
    // Simple linear progress toward next level
    double progress = (_userProfile!.totalXp % 100) / 100.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("STRENGTH", style: TextStyle(fontSize: 9, letterSpacing: 1, color: AppColors.greyText)),
            Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 9, color: AppColors.gold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(context, "EXPLORE", FontAwesomeIcons.compass, () {}),
        _buildActionItem(context, "MARKET", FontAwesomeIcons.store, () {}),
        _buildActionItem(context, "HUB", FontAwesomeIcons.cubes, () {}),
        _buildActionItem(context, "WALLET", FontAwesomeIcons.wallet, () {
          Navigator.pushNamed(context, '/profile');
        }),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50, width: 50,
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Center(child: FaIcon(icon, size: 18, color: Colors.white70)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.greyText)),
        ],
      ),
    );
  }

  Widget _buildFeaturedScroll() {
    if (_isLoading) {
      return SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: ShimmerWidget.rectangular(height: 180, width: 280),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _featuredCabals.length,
        itemBuilder: (context, index) {
          final cabal = _featuredCabals[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(cabal.bannerImageUrl ?? 'https://picsum.photos/300/180?sig=$index'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: AppColors.cardOverlayGradient,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(cabal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    cabal.description ?? "Join this community",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.greyText, fontSize: 12),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
        },
      ),
    );
  }

  Widget _buildEmptyQuests() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          FaIcon(FontAwesomeIcons.clipboardCheck, size: 40, color: AppColors.greyText.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text("ALL MISSIONS COMPLETE", style: TextStyle(color: AppColors.greyText, letterSpacing: 1)),
        ],
      ),
    );
  }
}
