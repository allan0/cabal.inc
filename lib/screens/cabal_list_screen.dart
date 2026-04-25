// lib/screens/cabal_list_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/widgets/cabal_card_widget.dart';
import 'package:cabal/widgets/empty_state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../models/cabal_model.dart';
import '../services/supabase_service.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/horizontal_cabal_list.dart';
import 'cabal_detail_screen.dart';
import 'create_cabal_screen.dart';
import 'login_screen.dart';

class CabalListScreen extends StatefulWidget {
  final String? telegramUsername;
  const CabalListScreen({Key? key, this.telegramUsername}) : super(key: key);
  @override
  State<CabalListScreen> createState() => _CabalListScreenState();
}

class _CabalListScreenState extends State<CabalListScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = true;

  UserProfile? _currentUserProfile;
  List<Cabal> _myCabals = [];
  List<Cabal> _newestCabals = [];
  List<Cabal> _gamingCabals = [];
  List<Cabal> _defiCabals = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Fetch all cabals first
      final allCabals = await _supabaseService.getAllCabals();

      // Fetch the current user profile in parallel
      final authUser = _supabaseService.getCurrentUser();
      if (authUser != null) {
        _currentUserProfile = await _supabaseService.getUserProfile(authUser.id);
      }

      // Now, filter the lists based on the fetched data
      if (mounted) {
        setState(() {
          // "Your Cabals" includes private ones, so we filter from the complete list.
          if (_currentUserProfile != null) {
            final joinedIds = _currentUserProfile!.joinedCabalIds.toSet();
            _myCabals = allCabals.where((c) => joinedIds.contains(c.id)).toList();
          }

          // Public sections should only show public cabals.
          final publicCabals = allCabals.where((c) => !c.isPrivate).toList();
          
          // Sort for "Newest Cabals" from public ones
          publicCabals.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
          _newestCabals = publicCabals.take(5).toList();

          // Filter by categories from public ones
          _gamingCabals = publicCabals.where((c) => c.category == 'Gaming').toList();
          _defiCabals = publicCabals.where((c) => c.category == 'DeFi & Trading').toList();
          
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading cabal list data: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load cabals.")));
      }
    }
  }

  // --- THIS METHOD IS NOW CORRECTED TO HANDLE REFRESH ---
  void _navigateToCreateCabal({String? category}) {
    if (_currentUserProfile == null) {
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
      return;
    }
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: CreateCabalScreen(initialCategory: category),
      ),
    ).then((didCreate) {
      // This 'then' block is executed when we come back from the CreateCabalScreen.
      // If a cabal was successfully created, the screen will pop with `true`.
      if (didCreate == true) {
        _loadAllData(); // Refresh all the data on the screen.
      }
    });
  }
  
  void _navigateToCabalDetail(Cabal cabal) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: CabalDetailScreen(cabalId: cabal.id),
      ),
    );
  }

  Widget _buildYourCabalsSection() {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Cabals 🤝", style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    if (_myCabals.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
          child: EmptyStateCard(
            title: "You Haven't Joined Any Cabals",
            message: "Join a cabal from the sections below to see it here!",
            icon: FontAwesomeIcons.rightToBracket,
            buttonText: "Discover Cabals",
            onButtonPressed: () { /* Could make the page jump down */ },
            currentUserProfile: _currentUserProfile,
          ),
        ),
      );
    }
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Your Cabals 🤝", style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 600;

                if (isWide) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: _myCabals.map((cabal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SizedBox(
                          height: 230,
                          child: CabalCardWidget(
                            project: cabal,
                            onTap: () => _navigateToCabalDetail(cabal),
                            layout: CabalCardLayout.horizontalList,
                          ),
                        ),
                      )).toList(),
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _myCabals.length,
                    itemBuilder: (context, index) {
                      final cabal = _myCabals[index];
                      return CabalCardWidget(
                        project: cabal,
                        onTap: () => _navigateToCabalDetail(cabal),
                        layout: CabalCardLayout.grid,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicSection({
    required String title,
    required List<Cabal> cabals,
    String? categoryKey,
    required String emptyTitle,
    required String emptyMessage,
    required IconData emptyIcon,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: cabals.isEmpty && !_isLoading
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: EmptyStateCard(
                  title: emptyTitle,
                  message: emptyMessage,
                  icon: emptyIcon,
                  buttonText: 'Create a Cabal',
                  onButtonPressed: () => _navigateToCreateCabal(category: categoryKey),
                  currentUserProfile: _currentUserProfile,
                ),
              )
            : HorizontalCabalList(
                title: title,
                cabals: cabals,
                isLoading: _isLoading,
                emptyMessage: "No cabals in this category yet.",
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _loadAllData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('Explore Cabals'),
                floating: true,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    onPressed: () => _navigateToCreateCabal(),
                    tooltip: "Create a new Cabal",
                  )
                ],
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildYourCabalsSection(),
              _buildPublicSection(
                title: "Newest Cabals ✨",
                cabals: _newestCabals,
                emptyTitle: "No New Cabals",
                emptyMessage: "Be the first to create a new cabal for the community!",
                emptyIcon: FontAwesomeIcons.rocket,
              ),
              _buildPublicSection(
                title: "Gaming 🎮",
                cabals: _gamingCabals,
                categoryKey: 'Gaming',
                emptyTitle: "No Gaming Cabals",
                emptyMessage: "Start the first gaming-focused cabal and build your community!",
                emptyIcon: FontAwesomeIcons.gamepad,
              ),
              _buildPublicSection(
                title: "DeFi & Trading 📈",
                cabals: _defiCabals,
                categoryKey: 'DeFi & Trading',
                emptyTitle: "No DeFi Cabals",
                emptyMessage: "Create a cabal for traders and yield farmers to share alpha.",
                emptyIcon: FontAwesomeIcons.chartLine,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
