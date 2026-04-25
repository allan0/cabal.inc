// lib/screens/landing_screen.dart
import 'dart:async';
import 'package:cabal/models/activity_model.dart';
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/screens/marketplace_screen.dart';
import 'package:cabal/screens/partners_screen.dart';
import 'package:cabal/screens/web3_hub_screen.dart';
import 'package:cabal/widgets/activity_card_widget.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'dart:math';
import 'dart:ui';

import '../main.dart';
import '../audio/audio_controller.dart';
import '../widgets/animated_header_widget.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/news_card_widget.dart';
import '../models/user_profile_model.dart';
import '../models/news_article_model.dart';
import '../models/coin_data_model.dart';
import '../services/supabase_service.dart';
import '../core/services/coingecko_service.dart';
import '../models/cabal_model.dart';
import 'cabal_detail_screen.dart';
import 'login_screen.dart';
import 'create_cabal_screen.dart';
import '../utils/app_colors.dart';
import '../widgets/coin_chart_widget.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/chatoshi_search_modal.dart';
import '../widgets/cabal_card_widget.dart';
import '../widgets/info_tile_widget.dart';
import 'news_viewer_screen.dart';
import 'placeholder_screen.dart';
import '../widgets/glowing_header_widget.dart'; // <-- MODIFIED IMPORT

class _TickerCoin {
  final String id;
  final String name;
  final String price;
  final String change;
  final bool isUp;
  _TickerCoin({required this.id, required this.name, required this.price, required this.change, required this.isUp});
}

class LandingScreen extends StatefulWidget {
  final UserProfile? currentUserProfile;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToLeaderboard;
  final VoidCallback onNavigateToCabals;
  final String? telegramUsername;
  final bool isNewsPanelVisible;
  final VoidCallback onToggleNewsPanel;

  const LandingScreen({
    Key? key,
    this.currentUserProfile,
    required this.onNavigateToProfile,
    required this.onNavigateToLeaderboard,
    required this.onNavigateToCabals,
    this.telegramUsername,
    required this.isNewsPanelVisible,
    required this.onToggleNewsPanel,
  }) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late bool _isDarkTheme;
  final SupabaseService _supabaseService = SupabaseService();
  final CoinGeckoService _coinGeckoService = CoinGeckoService();
  final ScrollController _landingScrollController = ScrollController();
  
  List<Cabal> _latestCabals = [];
  List<NewsArticle> _newsArticles = [];
  List<CommunityPost> _communityPosts = [];
  List<Activity> _activityFeed = [];
  
  bool _isLoadingLatestCabals = true;
  bool _isLoadingNews = true;
  bool _isLoadingFeed = true;
  bool _isLoadingActivity = true;

  bool _isCreatorHubCollapsed = false;
  bool _isPlatformNavCollapsed = true;
  bool _isProjectShowcaseCollapsed = true;
  bool _isFeaturedCabalsCollapsed = false;
  bool _isCommunityFeedCollapsed = false;
  bool _isNewsCollapsedMobile = false;
  bool _isActivityFeedCollapsed = false;

  final List<_TickerCoin> _tickerCoins = [];
  final ScrollController _tickerScrollController = ScrollController();
  Timer? _tickerTimer;
  static const double _minDesktopWidth = 800;
  
  String? _selectedCoinIdForChart;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = themeManager.themeMode == ThemeMode.dark;
    _loadLandingPageData();
    _initializeTicker();
  }

  Future<void> _initializeTicker() async {
    final numberFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    List<String> coinIdsToShow = widget.currentUserProfile?.preferredCoinIds ?? [];

    try {
      List<CoinData> liveCoins;
      if (coinIdsToShow.isNotEmpty) {
        liveCoins = await _coinGeckoService.getTrendingCoins(topN: 100);
        liveCoins = liveCoins.where((c) => coinIdsToShow.contains(c.id)).toList();
        if(liveCoins.isEmpty) liveCoins = await _coinGeckoService.getTrendingCoins(topN: 10);
      } else {
        liveCoins = await _coinGeckoService.getTrendingCoins(topN: 10);
      }
      
      if (mounted) {
        setState(() {
          _tickerCoins.clear();
          for (var coin in liveCoins) {
            _tickerCoins.add(_TickerCoin(
              id: coin.id,
              name: coin.symbol.toUpperCase(),
              price: numberFormat.format(coin.currentPrice ?? 0.0),
              change: '${(coin.priceChangePercentage24h ?? 0.0) >= 0 ? '+' : ''}${(coin.priceChangePercentage24h ?? 0.0).toStringAsFixed(2)}%',
              isUp: (coin.priceChangePercentage24h ?? 0.0) >= 0,
            ));
          }
        });
      }
    } catch (e) {
      debugPrint("Error initializing coin ticker: $e");
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _tickerScrollController.hasClients) _startTickerAnimation();
    });
  }

  void _startTickerAnimation() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_tickerScrollController.hasClients || !_tickerScrollController.position.hasContentDimensions) return;
      double newOffset = _tickerScrollController.offset + 1.0;
      if (newOffset >= _tickerScrollController.position.maxScrollExtent) {
        _tickerScrollController.jumpTo(0);
      } else {
        _tickerScrollController.jumpTo(newOffset);
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerScrollController.dispose();
    _landingScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLandingPageData() async {
    setState(() {
      _isLoadingLatestCabals = true;
      _isLoadingNews = true;
      _isLoadingFeed = true;
      _isLoadingActivity = true;
    });

    await Future.wait([
      _loadLatestCabals(),
      _loadNews(),
      _loadGlobalFeed(),
      _loadActivityFeed(),
    ]);
  }
  
  Future<void> _loadActivityFeed() async {
    if (!mounted) return;
    if (widget.currentUserProfile == null) {
      setState(() => _isLoadingActivity = false);
      return;
    }
    try {
      final feed = await _supabaseService.getActivityFeed(widget.currentUserProfile!.id);
      if (mounted) setState(() => _activityFeed = feed);
    } catch (e) {
      debugPrint("Error loading activity feed: $e");
    } finally {
      if (mounted) setState(() => _isLoadingActivity = false);
    }
  }

  Future<void> _loadGlobalFeed() async {
    if (!mounted) return;
    try {
      final posts = await _supabaseService.getGlobalFeed();
      if (mounted) setState(() => _communityPosts = posts);
    } catch (e) {
      debugPrint("Error loading global feed: $e");
    } finally {
      if (mounted) setState(() => _isLoadingFeed = false);
    }
  }

  Future<void> _loadNews() async {
    if (!mounted) return;
    try {
      List<NewsArticle> articles = await newsService.fetchNews();
      if (mounted) setState(() => _newsArticles = articles.take(kIsWeb ? 5 : 3).toList());
    } catch (e) {
      debugPrint("Error loading news articles: $e");
    } finally {
      if (mounted) setState(() => _isLoadingNews = false);
    }
  }

  Future<void> _loadLatestCabals() async {
    if (!mounted) return;
    try {
      List<Cabal> allCabals = await _supabaseService.getAllCabals();
      allCabals.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      if (mounted) setState(() => _latestCabals = allCabals.where((c) => !c.isPrivate).take(5).toList());
    } catch (e) {
      debugPrint("Error loading latest cabals: $e");
    } finally {
      if(mounted) setState(() => _isLoadingLatestCabals = false);
    }
  }

  void _navigateToCabalDetail(Cabal cabal) {
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CabalDetailScreen(cabalId: cabal.id, telegramUsername: widget.currentUserProfile?.telegramUsername)));
  }

  void _navigateToLoginScreen() {
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _isDarkTheme = theme.brightness == Brightness.dark;

    final bool isDesktop = kIsWeb && MediaQuery.of(context).size.width >= _minDesktopWidth;

    Widget mainContentColumn = Column(
      children: [
        _buildWelcomeHeader(theme),
        const SizedBox(height: 24),
        _buildCreatorDeveloperHub(),
        const SizedBox(height: 16),
        _buildPlatformNavigationSection(),
        const SizedBox(height: 16),
        if (widget.currentUserProfile != null) ...[
            _buildActivityFeedSection(theme),
            const SizedBox(height: 16),
        ],
        _buildProjectShowcase(),
        const SizedBox(height: 16),
        _buildFeaturedCabalsSection(theme),
        const SizedBox(height: 16),
        _buildCommunityFeedSection(theme),
        if (!isDesktop) _buildNewsSection(theme),
      ].animate(interval: 100.ms).fadeIn(duration: 400.ms),
    );

    if (isDesktop) {
      return Scaffold(
        body: DiamondMeshBackground(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                color: AppColors.darkGrey.withOpacity(0.5),
                child: Column(
                  children: [
                    const SizedBox(height: 100, child: AnimatedHeaderWidget()),
                    const SizedBox(height: 12),
                    _buildCoinTicker(theme),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: mainContentColumn,
                        ),
                      ),
                    ),
                    if (widget.isNewsPanelVisible)
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (_selectedCoinIdForChart != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: SizedBox(
                                        height: 450,
                                        child: CoinChartWidget(
                                            key: ValueKey(_selectedCoinIdForChart),
                                            coinId: _selectedCoinIdForChart!,
                                            onClose: () => setState(() => _selectedCoinIdForChart = null))),
                                  ).animate().fadeIn().slideY(begin: -0.1),
                                _buildNewsSection(theme),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      );
    }

    // Mobile View with the new permanent Glowing Header
    return Scaffold(
      body: DiamondMeshBackground(
        child: CustomScrollView(
          controller: _landingScrollController,
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: _SliverGlowingHeaderDelegate(),
              pinned: true,
            ),
            SliverToBoxAdapter(child: _buildCoinTicker(theme)),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (_selectedCoinIdForChart != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: SizedBox(
                          height: 450,
                          child: CoinChartWidget(
                              key: ValueKey(_selectedCoinIdForChart),
                              coinId: _selectedCoinIdForChart!,
                              onClose: () => setState(() => _selectedCoinIdForChart = null))),
                    ).animate().fadeIn().slideY(begin: -0.1),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: mainContentColumn,
                ),
                const SizedBox(height: 100), // Padding for FAB
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => showChatoshiSearchModal(context),
      tooltip: 'Ask Chatoshi',
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.offBlack,
      child: const CircleAvatar(
          radius: 28, backgroundColor: Colors.transparent, backgroundImage: AssetImage('assets/images/chatoshi.jpeg')),
    ).animate().fadeIn(delay: 1500.ms).slide(begin: const Offset(0, 2));
  }
  
  Widget _buildWelcomeHeader(ThemeData theme) {
    String welcomeMessage = widget.currentUserProfile != null ? "Welcome back, ${widget.currentUserProfile!.displayName ?? widget.telegramUsername}!" : "Welcome to Cabal!";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(welcomeMessage, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Text("Your command center for Web3 growth. Explore active campaigns, check the latest news, or manage your profile.", style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.85))),
      ],
    );
  }

  Widget _buildCollapsibleCard({ required String title, required IconData icon, required Widget child, required bool isCollapsed, required VoidCallback onToggle, EdgeInsets padding = const EdgeInsets.all(16.0) }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            onTap: onToggle,
            leading: FaIcon(icon, color: theme.colorScheme.primary),
            title: Text(title, style: theme.textTheme.titleLarge),
            trailing: FaIcon(isCollapsed ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronUp, size: 16),
          ),
          AnimatedSize(
            duration: 300.ms,
            curve: Curves.easeInOut,
            child: isCollapsed ? const SizedBox.shrink() : Container(
              width: double.infinity,
              padding: padding.copyWith(top: 0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorDeveloperHub() {
    return _buildCollapsibleCard(
      title: "Creator & Developer Hub",
      icon: FontAwesomeIcons.wandMagicSparkles,
      isCollapsed: _isCreatorHubCollapsed,
      onToggle: () => setState(() => _isCreatorHubCollapsed = !_isCreatorHubCollapsed),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          InfoTileWidget(icon: FontAwesomeIcons.store, title: "Explore the Marketplace", subtitle: "Find talent or offer your skills to the ecosystem.", onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const MarketplaceScreen())), gradientColors: const [AppColors.primaryAccent, AppColors.secondaryAccent]),
          const SizedBox(height: 12),
          InfoTileWidget(
            icon: FontAwesomeIcons.cubesStacked,
            title: "Web3 Hub",
            subtitle: "Deploy tokens, manage giveaways, and access on-chain tools.",
            onTap: () => Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Web3HubScreen(userProfile: widget.currentUserProfile))),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlatformNavigationSection() {
    return _buildCollapsibleCard(
      title: "Platform Navigation",
      icon: FontAwesomeIcons.compass,
      isCollapsed: _isPlatformNavCollapsed,
      onToggle: () => setState(() => _isPlatformNavCollapsed = !_isPlatformNavCollapsed),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        height: 130,
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildFeatureTile(icon: FontAwesomeIcons.compass, label: "Explore Cabals", onTap: widget.onNavigateToCabals, theme: Theme.of(context)),
          const SizedBox(width: 12),
          _buildFeatureTile(icon: FontAwesomeIcons.rankingStar, label: "Leaderboard", onTap: widget.onNavigateToLeaderboard, theme: Theme.of(context)),
          const SizedBox(width: 12),
          _buildFeatureTile(icon: FontAwesomeIcons.solidUserCircle, label: "My Profile", onTap: widget.onNavigateToProfile, theme: Theme.of(context)),
        ]),
      ),
    );
  }

  Widget _buildProjectShowcase() {
    return _buildCollapsibleCard(
      title: "Project Vision",
      icon: FontAwesomeIcons.filePowerpoint,
      isCollapsed: _isProjectShowcaseCollapsed,
      onToggle: () => setState(() => _isProjectShowcaseCollapsed = !_isProjectShowcaseCollapsed),
      child: InfoTileWidget(
        icon: FontAwesomeIcons.play,
        title: "View Pitch Deck & Demo",
        subtitle: "Learn more about our vision, revenue model, and the future of Cabal.",
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: "Pitch Deck", icon: FontAwesomeIcons.filePowerpoint))),
      )
    );
  }

  Widget _buildActivityFeedSection(ThemeData theme) {
    if (_isLoadingActivity) {
      return _buildCollapsibleCard(title: "Your Activity Feed 📡", icon: FontAwesomeIcons.rss, isCollapsed: false, onToggle: (){}, child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    }
    if (_activityFeed.isEmpty) {
      return const SizedBox.shrink(); // Don't show if empty
    }
    return _buildCollapsibleCard(
      title: "Your Activity Feed 📡",
      icon: FontAwesomeIcons.rss,
      isCollapsed: _isActivityFeedCollapsed,
      onToggle: () => setState(() => _isActivityFeedCollapsed = !_isActivityFeedCollapsed),
      child: Column(
        children: _activityFeed.take(3).map((activity) => ActivityCardWidget(activity: activity)).toList(),
      ),
    );
  }

  Widget _buildFeatureTile({ required IconData icon, required String label, required VoidCallback onTap, required ThemeData theme }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FaIcon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(label, textAlign: TextAlign.center, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCabalsSection(ThemeData theme) {
    if (_isLoadingLatestCabals) return _buildCollapsibleCard(title: "Fresh Off The Press 🔥", icon: FontAwesomeIcons.fire, isCollapsed: false, onToggle: (){}, child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    if (_latestCabals.isEmpty) return _buildCollapsibleCard(title: "Fresh Off The Press 🔥", icon: FontAwesomeIcons.fire, isCollapsed: false, onToggle: (){}, child: EmptyStateCard(title: "No Cabals Yet", message: "The universe is quiet... Be the first to create a new cabal!", icon: FontAwesomeIcons.ghost, buttonText: "Create a Cabal", onButtonPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const CreateCabalScreen())), currentUserProfile: widget.currentUserProfile));
    
    return _buildCollapsibleCard(
      title: "Fresh Off The Press 🔥",
      icon: FontAwesomeIcons.fire,
      isCollapsed: _isFeaturedCabalsCollapsed,
      onToggle: () => setState(() => _isFeaturedCabalsCollapsed = !_isFeaturedCabalsCollapsed),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _latestCabals.length,
          itemBuilder: (context, index) => SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: Padding(padding: const EdgeInsets.only(right: 12.0), child: CabalCardWidget(project: _latestCabals[index], onTap: () => _navigateToCabalDetail(_latestCabals[index])))),
        ),
      ),
    );
  }

  Widget _buildCommunityFeedSection(ThemeData theme) {
    if (_isLoadingFeed) return _buildCollapsibleCard(title: "Community Feed 🌐", icon: FontAwesomeIcons.satelliteDish, isCollapsed: false, onToggle: (){}, child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    if (_communityPosts.isEmpty) return _buildCollapsibleCard(title: "Community Feed 🌐", icon: FontAwesomeIcons.satelliteDish, isCollapsed: false, onToggle: (){}, child: EmptyStateCard(title: "The Feed is Quiet", message: "Go to a cabal's community page and be the first to start a conversation!", icon: FontAwesomeIcons.solidCommentDots, buttonText: "Explore Cabals", onButtonPressed: widget.onNavigateToCabals, currentUserProfile: widget.currentUserProfile));
    
    return _buildCollapsibleCard(
      title: "Community Feed 🌐",
      icon: FontAwesomeIcons.satelliteDish,
      isCollapsed: _isCommunityFeedCollapsed,
      onToggle: () => setState(() => _isCommunityFeedCollapsed = !_isCommunityFeedCollapsed),
      child: Column(
        children: _communityPosts.take(3).map((post) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: PostCardWidget(post: post, currentUserProfile: widget.currentUserProfile))).toList(),
      ),
    );
  }

  Widget _buildNewsSection(ThemeData theme) {
    if (_isLoadingNews) return _buildCollapsibleCard(title: "Latest News 📰", icon: FontAwesomeIcons.newspaper, isCollapsed: _isNewsCollapsedMobile, onToggle: () => setState(() => _isNewsCollapsedMobile = !_isNewsCollapsedMobile), child: const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator())));
    if (_newsArticles.isEmpty) return const SizedBox.shrink();
    
    return _buildCollapsibleCard(
      title: "Latest News 📰",
      icon: FontAwesomeIcons.newspaper,
      isCollapsed: _isNewsCollapsedMobile,
      onToggle: () => setState(() => _isNewsCollapsedMobile = !_isNewsCollapsedMobile),
      child: Column(
        children: _newsArticles.map((article) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: NewsCardWidget(
            article: article,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewsViewerScreen(article: article, userProfile: widget.currentUserProfile))),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCoinTicker(ThemeData theme) {
    if (_tickerCoins.isEmpty) return const SizedBox(height: 40, child: Center(child: ShimmerWidget.rectangular(height: 38, width: 200)));
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _tickerScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _tickerCoins.length * 10, // Loop the list
        itemBuilder: (context, index) {
          final coin = _tickerCoins[index % _tickerCoins.length];
          return InkWell(
            onTap: () {
              context.read<AudioController>().playSfx();
              setState(() => _selectedCoinIdForChart = _selectedCoinIdForChart == coin.id ? null : coin.id);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(coin.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 8),
                Text(coin.price, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                const SizedBox(width: 8),
                Row(children: [
                  FaIcon(coin.isUp ? FontAwesomeIcons.arrowTrendUp : FontAwesomeIcons.arrowTrendDown, size: 12, color: coin.isUp ? AppColors.success : AppColors.error),
                  const SizedBox(width: 4),
                  Text(coin.change, style: theme.textTheme.bodySmall?.copyWith(color: coin.isUp ? AppColors.success : AppColors.error)),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _SliverGlowingHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 100.0;

  @override
  double get maxExtent => 250.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final double topPadding = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: AppColors.offBlack.withOpacity(0.7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.only(top: lerpDouble(0, topPadding, progress)!),
                child: GlowingHeaderWidget(shrinkProgress: progress),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
