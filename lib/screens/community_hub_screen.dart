// lib/screens/community_hub_screen.dart
import 'package:cabal/models/community_cabal_preview.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/community_cabal_card.dart';
import 'package:cabal/widgets/empty_state_card.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../widgets/diamond_mesh_background.dart';
import 'cabal_detail_screen.dart';

class CommunityHubScreen extends StatefulWidget {
  const CommunityHubScreen({Key? key}) : super(key: key);

  @override
  State<CommunityHubScreen> createState() => _CommunityHubScreenState();
}

class _CommunityHubScreenState extends State<CommunityHubScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<CommunityCabalPreview> _activeCabals = [];
  bool _isLoading = true;
  UserProfile? _currentUserProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final authUser = _supabaseService.getCurrentUser();
      if (authUser != null) {
        _currentUserProfile = await _supabaseService.getUserProfile(authUser.id);
      }
      final cabals = await _supabaseService.getCommunityHubCabals();
      if (mounted) {
        setState(() {
          _activeCabals = cabals;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading community hub data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToCabalDetail(CommunityCabalPreview preview) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: CabalDetailScreen(cabalId: preview.cabal.id),
      ),
    ).then((_) => _loadData()); // Reload data when returning
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Community Hub"),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      ),
      body: DiamondMeshBackground(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: _isLoading
              ? _buildLoadingState()
              : _activeCabals.isEmpty
                  ? _buildEmptyState()
                  : _buildCabalList(),
        ),
      ),
    );
  }

  Widget _buildCabalList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 40,
      ),
      itemCount: _activeCabals.length,
      itemBuilder: (context, index) {
        final preview = _activeCabals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            height: 250, // Give cards a consistent height
            child: CommunityCabalCard(
              preview: preview,
              onTap: () => _navigateToCabalDetail(preview),
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
      ),
      itemCount: 3,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: ShimmerWidget.rectangular(height: 250),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: EmptyStateCard(
          title: "The Hub is Quiet",
          message: "No communities have any posts yet. Explore a cabal and be the first to start a conversation!",
          icon: FontAwesomeIcons.solidCommentDots,
          buttonText: "Explore Cabals",
          currentUserProfile: _currentUserProfile,
          onButtonPressed: () {
            // This is a placeholder; a better implementation would use the HomeNavWrapper's controller
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Navigate to the 'Explore' tab.")));
          },
        ),
      ),
    );
  }
}
