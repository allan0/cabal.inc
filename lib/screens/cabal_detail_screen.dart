// lib/screens/cabal_detail_screen.dart
import 'dart:async';
import 'dart:math';
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/models/merchandise_product_model.dart';
import 'package:cabal/screens/add_merch_screen.dart';
import 'package:cabal/screens/create_post_screen.dart';
import 'package:cabal/screens/dex_screen.dart';
import 'package:cabal/screens/edit_cabal_screen.dart';
import 'package:cabal/screens/list_property_screen.dart';
import 'package:cabal/screens/manage_cabal_screen.dart';
import 'package:cabal/widgets/community_activity_chart.dart';
import 'package:cabal/widgets/community_stats_header.dart';
import 'package:cabal/widgets/merchandise_card_widget.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:page_transition/page_transition.dart';

import '../models/cabal_model.dart';
import '../models/quest_section_model.dart';
import '../models/quest_model.dart';
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import '../widgets/quest_section_widget.dart';
import '../utils/app_colors.dart';
import '../widgets/quest_complete_celebration.dart';
import '../features/wallet/application/wallet_provider.dart';
import '../utils/constants.dart';
import '../widgets/cabal_header_widget.dart';
import '../widgets/leaderboard_preview_card.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';
import 'leaderboard_screen.dart';

class CabalDetailScreen extends StatefulWidget {
  final String cabalId;
  final String? telegramUsername;

  const CabalDetailScreen({
    Key? key,
    required this.cabalId,
    this.telegramUsername,
  }) : super(key: key);

  @override
  State<CabalDetailScreen> createState() => _CabalDetailScreenState();
}

enum QuestStatusFilter { all, locked, completed, inProgress, onCooldown, pending }

class _CabalDetailScreenState extends State<CabalDetailScreen> with TickerProviderStateMixin {
  final SupabaseService _supabaseService = SupabaseService();
  final AuthService _authService = AuthService();
  late TabController _tabController;

  Cabal? _cabal;
  UserProfile? _viewingUserProfile;
  UserProfile? _currentUserProfile;
  
  List<QuestSection> _questSections = [];
  Map<String, List<Quest>> _allQuestsBySection = {};
  Map<String, List<Quest>> _filteredQuestsBySection = {};
  Set<String> _viewingUserCompletedQuestIds = {};
  Map<String, DateTime?> _viewingUserCompletionTimestamps = {};
  Map<String, int> _viewingUserQuestStepsMap = {};
  Map<String, String> _viewingUserQuestActualStatusMap = {};
  QuestStatusFilter _selectedStatusFilter = QuestStatusFilter.all;

  List<CommunityPost> _communityPosts = [];
  bool _isLoadingPosts = true;
  
  bool _isLoadingCommunityStats = true;
  int _memberCount = 0;
  int _postCount = 0;
  List<Map<String, dynamic>> _activityTimeseries = [];
  
  List<MerchandiseProduct> _merchandise = [];
  bool _isLoadingMerch = true;
  
  bool _isLoading = true;
  String? _errorMessage;
  String? _loadingClaimQuestId;
  bool _isFavoriting = false;
  bool _isJoining = false;
  int? _userRank;
  int? _userCabalXp;
  bool _isLoadingRank = true;
  
  bool _hasPendingRequest = false;
  bool _isRequestingToJoin = false;
  
  Color? _pageBackgroundColor;
  Color? _cardColor;
  Color? _textColor;
  Color? _accentColor;

  bool get _cabalIsTokenized => _cabal?.tokenContractAddress != null && _cabal!.tokenContractAddress!.isNotEmpty;
  bool get _isCreator => _currentUserProfile?.id == _cabal?.creatorId;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); 
    _tabController.addListener(() => setState(() {}));
    _loadCabalScreenData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCabalScreenData({bool forceReload = false}) async {
    if (!mounted) return;
    if (!forceReload) setState(() => _isLoading = true);

    try {
      final authUser = _supabaseService.getCurrentUser();
      _currentUserProfile = authUser != null ? await _supabaseService.getUserProfile(authUser.id) : null;
      _cabal = await _supabaseService.getCabal(widget.cabalId);
      if (_cabal == null) throw Exception("Cabal not found.");
      
      _setThemeFromCabal(_cabal!.theme);
      
      _viewingUserProfile = widget.telegramUsername != null 
          ? await _supabaseService.findUserProfileByTelegram(widget.telegramUsername!) 
          : _currentUserProfile;

      if (_viewingUserProfile != null) {
        final progressData = await _supabaseService.getUserProgressInCabal(_viewingUserProfile!.id, widget.cabalId);
        _viewingUserCompletedQuestIds = progressData['completed_ids'] ?? {};
        _viewingUserCompletionTimestamps = progressData['timestamps'] ?? {};
        _viewingUserQuestStepsMap = progressData['steps'] ?? {};
        _viewingUserQuestActualStatusMap = progressData['statuses'] ?? {};
      } else {
        _isLoadingRank = false;
      }
      
      if (_cabal!.isPrivate && _currentUserProfile != null) {
        _hasPendingRequest = await _supabaseService.hasPendingJoinRequest(_cabal!.id);
      }

      final results = await Future.wait([
        _supabaseService.getQuestsForCabal(widget.cabalId),
        _supabaseService.getQuestSectionsForCabal(widget.cabalId),
        _supabaseService.getCommunityPosts(widget.cabalId),
        _supabaseService.getCabalCommunityStats(widget.cabalId),
        _supabaseService.getMerchandiseForCabal(widget.cabalId),
      ]);
      
      final allQuests = results[0] as List<Quest>;
      final sections = results[1] as List<QuestSection>;
      _communityPosts = results[2] as List<CommunityPost>;
      final stats = results[3] as Map<String, dynamic>;
      _merchandise = results[4] as List<MerchandiseProduct>;

      _memberCount = stats['member_count'];
      _postCount = stats['post_count'];
      _activityTimeseries = stats['activity_timeseries'];
      
      final tabCount = 2 + (_cabalIsTokenized ? 1 : 0) + ((_merchandise.isNotEmpty || _isCreator) ? 1 : 0);
      if (_tabController.length != tabCount) {
        final initialIndex = _tabController.index;
        _tabController.dispose();
        _tabController = TabController(length: tabCount, vsync: this, initialIndex: min(initialIndex, tabCount - 1));
        _tabController.addListener(() => setState(() {}));
      }

      if (_cabal!.questSectionOrder.isNotEmpty) {
        sections.sort((a, b) => _cabal!.questSectionOrder.indexOf(a.id).compareTo(_cabal!.questSectionOrder.indexOf(b.id)));
      } else {
        sections.sort((a,b) => a.order.compareTo(b.order));
      }
      _questSections = sections;
      _allQuestsBySection.clear();
      for (final quest in allQuests) {
        final sectionId = quest.id;
        if(sectionId != null) {
            _allQuestsBySection.putIfAbsent(sectionId, () => []).add(quest);
        }
      }
      
      _updateQuestObjectsWithViewingUserProgress();
      _applyFilters();
      
      if (mounted) {
        setState(() {
          _isLoadingPosts = false;
          _isLoadingCommunityStats = false;
          _isLoadingMerch = false;
          _isLoading = false;
        });
      }
    } catch (e, s) {
      debugPrint("Error loading cabal screen data: $e\n$s");
      if (mounted) setState(() { _errorMessage = "Failed to load cabal details."; _isLoading = false; });
    }
  }
  
  void _updateQuestObjectsWithViewingUserProgress() {
    if (_viewingUserProfile == null) {
      _allQuestsBySection.values.forEach((quests) => quests.forEach((q) {
        q.isLockedForUser = true;
        q.isCompletedByUser = false;
      }));
      return;
    }
    _allQuestsBySection.values.forEach((quests) => quests.forEach((q) => q.updateUserStatus(
      allCompletedQuestIdsForUserInCabal: _viewingUserCompletedQuestIds,
      userQuestCompletionTimestamps: _viewingUserCompletionTimestamps,
      userQuestStepsCompletedMap: _viewingUserQuestStepsMap,
      userQuestActualStatusesMap: _viewingUserQuestActualStatusMap,
    )));
  }

  void _applyFilters() {
    _filteredQuestsBySection.clear();
    _allQuestsBySection.forEach((sectionId, quests) {
      final filtered = quests.where((quest) {
        switch (_selectedStatusFilter) {
          case QuestStatusFilter.all: return true;
          case QuestStatusFilter.locked: return quest.isLockedForUser;
          case QuestStatusFilter.completed: return quest.isCompletedByUser;
          case QuestStatusFilter.inProgress: return !quest.isLockedForUser && !quest.isCompletedByUser && !quest.isOnCooldownForUser && quest.userQuestSpecificStatus != 'pending_verification';
          case QuestStatusFilter.onCooldown: return quest.isOnCooldownForUser;
          case QuestStatusFilter.pending: return quest.userQuestSpecificStatus == 'pending_verification';
        }
      }).toList();
      if (filtered.isNotEmpty) _filteredQuestsBySection[sectionId] = filtered;
    });
    setState(() {});
  }
  
  void _setThemeFromCabal(Map<String, dynamic>? themeData) {
    if (themeData == null) return;
    try {
      _pageBackgroundColor = Color(int.parse(themeData['page_bg'].substring(1, 7), radix: 16) + 0xFF000000);
      _cardColor = Color(int.parse(themeData['card_bg'].substring(1, 7), radix: 16) + 0xFF000000);
      _textColor = Color(int.parse(themeData['text_color'].substring(1, 7), radix: 16) + 0xFF000000);
      _accentColor = Color(int.parse(themeData['accent_color'].substring(1, 7), radix: 16) + 0xFF000000);
    } catch (e) {
      debugPrint("Error parsing custom theme colors: $e");
    }
  }

  Future<void> _handleQuestClaim(Quest quest) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final walletProvider = context.read<WalletProvider>();
    final currentUser = _currentUserProfile;
    if (currentUser == null) {
      _showLoginPrompt();
      return;
    }

    setState(() => _loadingClaimQuestId = quest.id);

    try {
      bool actionSuccess = false;
      String? walletAddress;
      
      switch (quest.type) {
        case QuestType.connectWalletEth:
        case QuestType.connectWalletBase:
          await walletProvider.connectEVMWallet(context: context);
          walletAddress = walletProvider.connectedEVMAddress;
          actionSuccess = walletProvider.isConnectedEVM;
          break;
        case QuestType.twitterFollow:
        case QuestType.twitterLike:
        case QuestType.twitterRetweet:
          actionSuccess = await _authService.signInWithTwitter(quest.actionUrl);
          break;
        case QuestType.discordJoin:
          actionSuccess = await _authService.signInWithDiscord(quest.actionUrl);
          break;
        case QuestType.websiteVisit:
        case QuestType.telegramChannelJoin:
        case QuestType.telegramGroupJoin:
           await _authService.launchActionUrl(quest.actionUrl);
           actionSuccess = true;
           break;
        default:
          actionSuccess = true;
      }
      
      if(actionSuccess) {
        final result = await _supabaseService.completeQuest(quest.id);
        if (result['success'] as bool? ?? false) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Quest complete! +${quest.xpReward} XP'), backgroundColor: AppColors.success));
          showQuestCompleteCelebration(context);
          await _loadCabalScreenData(forceReload: true);
        } else {
          throw Exception(result['message'] ?? 'Failed to complete quest.');
        }
      }
      
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Action failed: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _loadingClaimQuestId = null);
    }
  }
  
  Future<void> _toggleFavorite() async {
    if (_currentUserProfile == null) return;
    setState(() => _isFavoriting = true);
    final isCurrentlyFavorited = _currentUserProfile!.favoritedCabalIds.contains(widget.cabalId);
    
    if (isCurrentlyFavorited) {
      _currentUserProfile!.favoritedCabalIds.remove(widget.cabalId);
    } else {
      _currentUserProfile!.favoritedCabalIds.add(widget.cabalId);
    }
    
    try {
      await _supabaseService.updateUserProfile({'favorited_cabal_ids': _currentUserProfile!.favoritedCabalIds});
    } catch(e) {
      if (isCurrentlyFavorited) {
        _currentUserProfile!.favoritedCabalIds.add(widget.cabalId);
      } else {
        _currentUserProfile!.favoritedCabalIds.remove(widget.cabalId);
      }
    } finally {
      if(mounted) setState(() => _isFavoriting = false);
    }
  }
  
  Future<void> _handleJoinCabal() async {
    if (_currentUserProfile == null) {
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
      return;
    }
    if (_isJoining || _cabal == null) return;

    setState(() => _isJoining = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _supabaseService.joinCabal(_cabal!.id);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Welcome to the ${_cabal!.name} Cabal!'), backgroundColor: AppColors.success),
      );
      await _loadCabalScreenData(forceReload: true);
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error joining cabal: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }
  
  void _navigateToLeaderboard() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: LeaderboardScreen(currentUserId: _currentUserProfile?.id),
      ),
    );
  }

  Future<void> _requestToJoin() async {
    if (_cabal == null || _currentUserProfile == null) return;
    setState(() => _isRequestingToJoin = true);
    try {
      await _supabaseService.requestToJoinCabal(_cabal!.id);
      setState(() {
        _hasPendingRequest = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request sent!"), backgroundColor: AppColors.success),
      );
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isRequestingToJoin = false);
    }
  }

  void _showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please log in to perform this action.")));
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator(color: _accentColor)));
    }
    if (_errorMessage != null || _cabal == null) {
      return Scaffold(body: Center(child: Text(_errorMessage ?? "Cabal not found.")));
    }
    
    final cabal = _cabal!;
    final isMember = _currentUserProfile?.joinedCabalIds.contains(cabal.id) ?? false;
    final canAccess = !cabal.isPrivate || isMember || _isCreator;
    
    List<Widget> tabs = [ const Tab(text: 'Quests'), const Tab(text: 'Community'), ];
    List<Widget> tabViews = [ _buildQuestsView(), _buildCommunityView(), ];

    if (_merchandise.isNotEmpty || _isCreator) {
      tabs.add(const Tab(text: 'Merch'));
      tabViews.add(_buildMerchView());
    }
    if (_cabalIsTokenized) {
      tabs.add(const Tab(text: 'Treasury / DEX'));
      tabViews.add(DexScreen(cabal: cabal, userProfile: _currentUserProfile!));
    }
    
    return Scaffold(
      backgroundColor: _pageBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(cabal.name, style: TextStyle(color: _textColor, shadows: const [Shadow(color: Colors.black54, blurRadius: 4)])),
                background: cabal.bannerImageUrl != null
                  ? Image.network(cabal.bannerImageUrl!, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: _cardColor))
                  : Container(color: _accentColor?.withOpacity(0.2)),
              ),
              actions: [
                if (_currentUserProfile != null) IconButton(
                  icon: _isFavoriting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : FaIcon(
                    (_currentUserProfile?.favoritedCabalIds.contains(cabal.id) ?? false) ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                    color: _accentColor
                  ),
                  onPressed: _toggleFavorite
                ),
              ],
            ),
            SliverToBoxAdapter(child: CabalHeaderWidget(project: cabal).animate().fadeIn(delay: 200.ms)),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildContextualActions(isMember),
              ),
            ),
            
            if (canAccess) SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: tabs.length > 3,
                  tabs: tabs,
                  indicatorColor: _accentColor,
                  labelColor: _accentColor,
                  unselectedLabelColor: _textColor?.withOpacity(0.7),
                ),
                backgroundColor: _pageBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ];
        },
        body: canAccess
            ? TabBarView(controller: _tabController, children: tabViews)
            : _buildAccessDeniedWidget(Theme.of(context), isMember),
      ),
      floatingActionButton: _buildFloatingActionButton(canAccess, _isCreator),
    );
  }

  // --- BUILD METHODS RESTORED ---
  Widget _buildContextualActions(bool isMember) {
    if (_isCreator) {
      return _buildCreatorActions();
    } else if (!isMember && !_cabal!.isPrivate) {
      return ElevatedButton.icon(
        icon: _isJoining
            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const FaIcon(FontAwesomeIcons.rightToBracket, size: 16),
        label: Text(_isJoining ? 'Joining...' : 'Join Cabal'),
        onPressed: _isJoining ? null : _handleJoinCabal,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildCreatorActions() {
    final theme = Theme.of(context);
    List<Widget> actions = [];

    actions.add(
      Expanded(
        child: OutlinedButton.icon(
          icon: const FaIcon(FontAwesomeIcons.gears, size: 16),
          label: const Text("Manage Cabal"),
          onPressed: () async {
            final needsRefresh = await Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ManageCabalScreen(cabal: _cabal!)));
            if (needsRefresh == true && mounted) {
              _loadCabalScreenData(forceReload: true);
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: _textColor ?? theme.colorScheme.onSurface,
            side: BorderSide(color: (_textColor ?? theme.colorScheme.onSurface).withOpacity(0.5))
          ),
        ),
      ),
    );

    if (_cabal?.category == 'Real Estate') {
      actions.add(const SizedBox(width: 12));
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            icon: const FaIcon(FontAwesomeIcons.houseMedical, size: 16),
            label: const Text("List Property"),
            onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const ListPropertyScreen())),
          ),
        ),
      );
    }

    return Row(children: actions);
  }
  
  Widget _buildQuestsView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: LeaderboardPreviewCard(
            rank: _userRank, 
            userCabalXp: _userCabalXp, 
            isLoading: _isLoadingRank, 
            onTap: _navigateToLeaderboard
          )
        )),
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            _buildFilterChips(Theme.of(context)), 
            backgroundColor: _pageBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor
          )
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: _filteredQuestsBySection.isEmpty 
            ? SliverFillRemaining(child: Center(child: Text("No quests match the current filters.", style: TextStyle(color: _textColor?.withOpacity(0.7))))) 
            : SliverList(
              delegate: SliverChildListDelegate(
                _questSections
                  .where((s) => _filteredQuestsBySection.containsKey(s.id))
                  .map((section) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), 
                    child: QuestSectionWidget(
                      cabalId: _cabal!.id, 
                      section: section, 
                      quests: _filteredQuestsBySection[section.id] ?? [], 
                      viewingUserProfile: _viewingUserProfile, 
                      currentUserProfile: _currentUserProfile, 
                      completedQuestIdsForProject: _viewingUserCompletedQuestIds, 
                      userQuestCompletionTimestamps: _viewingUserCompletionTimestamps, 
                      userQuestStepsMap: _viewingUserQuestStepsMap, 
                      userQuestStatusMap: _viewingUserQuestActualStatusMap, 
                      onClaimReward: _handleQuestClaim, 
                      loadingClaimQuestId: _loadingClaimQuestId, 
                      cardColor: _cardColor ?? Theme.of(context).cardColor, 
                      textColor: _textColor ?? Theme.of(context).textTheme.bodyLarge!.color!, 
                      accentColor: _accentColor ?? Theme.of(context).colorScheme.secondary
                    )
                  )).toList()
              )
            )
        )
      ]
    );
  }

  Widget _buildCommunityView() {
    return RefreshIndicator(
      onRefresh: () async { await _loadCabalScreenData(forceReload: true); },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _isLoadingCommunityStats
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    CommunityStatsHeader(cabal: _cabal!, memberCount: _memberCount, postCount: _postCount),
                    const SizedBox(height: 16),
                    if (_activityTimeseries.isNotEmpty) CommunityActivityChart(activityData: _activityTimeseries)
                  ])
            )
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: Text("Latest Posts", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: _textColor)))
          ),
          _isLoadingPosts
            ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            : _communityPosts.isEmpty
              ? SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FaIcon(FontAwesomeIcons.solidCommentDots, size: 50, color: _textColor?.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text("No posts here yet.", style: TextStyle(color: _textColor, fontSize: 18))
                ])))
              : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = _communityPosts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: PostCardWidget(post: post, currentUserProfile: _currentUserProfile)
                      );
                    },
                    childCount: _communityPosts.length
                  )
                )
              ),
          const SliverToBoxAdapter(child: SizedBox(height: 80))
        ]
      )
    );
  }

  Widget _buildMerchView() {
    if (_isLoadingMerch) { return const Center(child: CircularProgressIndicator()); }
    if (_merchandise.isEmpty && !_isCreator) { return Center(child: Text("This Cabal has no merchandise available yet.", style: TextStyle(color: _textColor))); }
    if (_merchandise.isEmpty && _isCreator) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Your store is empty.", style: TextStyle(color: _textColor)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_currentUserProfile == null) { _showLoginPrompt(); return; }
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddMerchScreen(cabalId: widget.cabalId, userProfile: _currentUserProfile!)));
              if (result == true) _loadCabalScreenData(forceReload: true);
            },
            child: const Text('List Your First Item'),
          )
        ]),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75,
      ),
      itemCount: _merchandise.length,
      itemBuilder: (context, index) {
        final product = _merchandise[index];
        return MerchandiseCardWidget(
          product: product,
          onTap: () async {
             if (_currentUserProfile == null) { _showLoginPrompt(); return; }
             final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product, userProfile: _currentUserProfile!)));
             if (result == true) _loadCabalScreenData(forceReload: true);
          },
        );
      },
    );
  }
  
  Widget _buildFilterChips(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      height: 60.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        children: QuestStatusFilter.values.map((filter) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(filter.name),
            selected: _selectedStatusFilter == filter,
            onSelected: (selected) {
              if (selected) setState(() { _selectedStatusFilter = filter; _applyFilters(); });
            },
            selectedColor: _accentColor,
            labelStyle: TextStyle(color: _selectedStatusFilter == filter ? ((_accentColor?.computeLuminance() ?? 0) > 0.5 ? Colors.black : Colors.white) : _textColor)
          )
        )).toList()
      )
    );
  }

  Widget _buildAccessDeniedWidget(ThemeData theme, bool isMember) {
    Widget button;
    if (_currentUserProfile == null) {
      button = ElevatedButton.icon(onPressed: (){ Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen())); }, icon: const Icon(Icons.login), label: const Text("Log In to Join"));
    } else if (_hasPendingRequest) {
      button = ElevatedButton.icon(onPressed: null, icon: const FaIcon(FontAwesomeIcons.hourglassHalf, size: 16), label: const Text("Request Pending"));
    } else {
      button = ElevatedButton.icon(onPressed: _isRequestingToJoin ? null : _requestToJoin, icon: _isRequestingToJoin ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const FaIcon(FontAwesomeIcons.rightToBracket, size: 16), label: const Text("Request to Join"));
    }
    return Center(child: Card(color: _cardColor, child: Padding(padding: const EdgeInsets.all(32.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
      FaIcon(FontAwesomeIcons.lock, size: 40, color: _textColor?.withOpacity(0.7)),
      const SizedBox(height: 16),
      Text("This is a Private Cabal", style: theme.textTheme.titleLarge?.copyWith(color: _textColor)),
      const SizedBox(height: 8),
      Text("You must be a member to view its content.", style: theme.textTheme.bodyMedium?.copyWith(color: _textColor?.withOpacity(0.8))),
      if (!isMember) ...[ const SizedBox(height: 24), button ]
    ])))).animate().fadeIn(delay: 300.ms);
  }

  Widget? _buildFloatingActionButton(bool canAccess, bool isCreator) {
    if (!canAccess) return null;
    
    int communityTabIndex = 1;
    int merchTabIndex = -1;
    if (_merchandise.isNotEmpty || isCreator) merchTabIndex = 2;

    VoidCallback? onPressedAction;
    IconData? icon;
    String? label;

    if (_tabController.index == communityTabIndex) {
      onPressedAction = () async {
        if (_currentUserProfile == null) { _showLoginPrompt(); return; }
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen(cabalId: widget.cabalId, cabalName: _cabal?.name ?? 'Cabal')));
        if (result == true) _loadCabalScreenData(forceReload: true);
      };
      icon = Icons.add;
      label = 'Create Post';
    } else if (isCreator && _tabController.index == merchTabIndex) {
      onPressedAction = () async {
        if (_currentUserProfile == null) { _showLoginPrompt(); return; }
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddMerchScreen(cabalId: widget.cabalId, userProfile: _currentUserProfile!)));
        if (result == true) _loadCabalScreenData(forceReload: true);
      };
      icon = Icons.add_shopping_cart;
      label = 'Add Merch';
    }

    if (onPressedAction != null) {
      return FloatingActionButton.extended(
        onPressed: onPressedAction,
        icon: Icon(icon),
        label: Text(label!),
      );
    }
    return null;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._child, {required this.backgroundColor});
  final Widget _child;
  final Color backgroundColor;
  @override double get minExtent => 48.0;
  @override double get maxExtent => 48.0;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) { return Container(color: backgroundColor, child: _child); }
  @override bool shouldRebuild(_SliverAppBarDelegate oldDelegate) { return backgroundColor != oldDelegate.backgroundColor || _child != oldDelegate._child; }
}
