// lib/screens/marketplace_screen.dart
import 'package:cabal/models/nft_listing_model.dart';
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/create_developer_profile_screen.dart';
import 'package:cabal/screens/create_project_listing_screen.dart';
import 'package:cabal/screens/dashboard_screen.dart';
import 'package:cabal/screens/list_property_screen.dart';
import 'package:cabal/screens/nft_detail_screen.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/empty_state_card.dart';
import 'package:cabal/widgets/nft_listing_card.dart';
import 'package:cabal/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../models/marketplace_models.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/project_listing_card.dart';
import '../widgets/developer_profile_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  // State for original marketplace tabs
  List<ProjectListing> _projectListings = [];
  bool _isLoadingProjects = true;
  List<DeveloperProfile> _developerProfiles = [];
  bool _isLoadingDevelopers = true;
  
  // --- NEW: State for NFT Marketplace Tab ---
  List<NftListing> _nftListings = [];
  bool _isLoadingNfts = true;

  UserProfile? _currentUserProfile;
  DeveloperProfile? _currentUserDeveloperProfile;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }
  
  Future<void> _fetchAllData() async {
    final authUser = _supabaseService.getCurrentUser();
    if (authUser != null) {
      final profile = await _supabaseService.getUserProfile(authUser.id);
      if(mounted) setState(() => _currentUserProfile = profile);
    }

    // Fetch all data in parallel for a faster loading experience
    await Future.wait([
      _fetchProjectListings(),
      _fetchDeveloperProfiles(),
      _fetchNftListings(),
    ]);
  }

  Future<void> _fetchProjectListings() async {
    if (!mounted) return;
    setState(() => _isLoadingProjects = true);
    try {
      final listings = await _supabaseService.getProjectListings();
      if (mounted) setState(() => _projectListings = listings);
    } catch (e) {
      debugPrint("Error fetching project listings: $e");
    } finally {
      if (mounted) setState(() => _isLoadingProjects = false);
    }
  }

  Future<void> _fetchDeveloperProfiles() async {
    if (!mounted) return;
    setState(() => _isLoadingDevelopers = true);
    try {
      final profiles = await _supabaseService.getDeveloperProfiles();
      if (mounted) {
        _developerProfiles = profiles;
        if (_currentUserProfile != null) {
          try {
             _currentUserDeveloperProfile = profiles.firstWhere((p) => p.userId == _currentUserProfile!.id);
          } catch(e) {
            _currentUserDeveloperProfile = null;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching developer profiles: $e");
    } finally {
      if (mounted) setState(() => _isLoadingDevelopers = false);
    }
  }

  Future<void> _fetchNftListings() async {
    if (!mounted) return;
    setState(() => _isLoadingNfts = true);
    try {
      final listings = await _supabaseService.getNftListings();
      if (mounted) setState(() => _nftListings = listings);
    } catch (e) {
      debugPrint("Error fetching NFT listings: $e");
    } finally {
      if (mounted) setState(() => _isLoadingNfts = false);
    }
  }
  
  void _showCreateListingOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.building),
            title: const Text('List a Property'),
            subtitle: const Text('Tokenize a real estate asset as an NFT'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const ListPropertyScreen()));
              if (result == true) _fetchAllData();
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.fileCode),
            title: const Text('Post a Project'),
            subtitle: const Text('Find talent to build your vision'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProjectListingScreen()));
              if (result == true) _fetchProjectListings();
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.userAstronaut),
            title: Text(_currentUserDeveloperProfile == null ? 'List Your Services' : 'Edit Your Services'),
            subtitle: Text(_currentUserDeveloperProfile == null ? 'Offer your skills to the community' : 'Update your public developer profile'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateDeveloperProfileScreen(existingProfile: _currentUserDeveloperProfile)),
              );
              if (result == true) _fetchDeveloperProfiles();
            },
          ),
        ],
      ),
    );
  }
  
  void _navigateToUserProfile(String userId) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: DashboardScreen(viewProfileId: userId, isLoadingProfile: false),
      ),
    );
  }

  void _navigateToNftDetail(NftListing listing) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NftDetailScreen(listing: listing))
    ).then((_) => _fetchAllData()); // Refresh data when returning
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 3, // Updated to 3 tabs
      child: Scaffold(
        body: DiamondMeshBackground(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text("Cabal Marketplace"),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: "NFTs 💎"),
                      Tab(text: "Projects 🚀"),
                      Tab(text: "Talent 🧑‍💻"),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildNftsTab(),
                _buildProjectsTab(),
                _buildDevelopersTab(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateListingOptions,
          icon: const Icon(Icons.add),
          label: const Text("Create Listing"),
        ),
      ),
    );
  }

  Widget _buildNftsTab() {
    if (_isLoadingNfts) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8),
        itemCount: 6,
        itemBuilder: (context, index) => const ShimmerWidget.rectangular(height: 250),
      );
    }

    if (_nftListings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyStateCard(
            title: "No NFTs Listed",
            message: "The NFT marketplace is brand new. Be the first to list a tokenized asset for sale!",
            icon: FontAwesomeIcons.gem,
            buttonText: "List an Asset",
            currentUserProfile: _currentUserProfile,
            onButtonPressed: _showCreateListingOptions,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNftListings,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8
        ),
        itemCount: _nftListings.length,
        itemBuilder: (context, index) {
          final listing = _nftListings[index];
          return NftListingCard(
            listing: listing,
            onTap: () => _navigateToNftDetail(listing),
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
        },
      ),
    );
  }

  Widget _buildProjectsTab() {
    if (_isLoadingProjects) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: ShimmerWidget.rectangular(height: 250),
        ),
      );
    }

    if (_projectListings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyStateCard(
            title: "No Projects Found",
            message: "The marketplace is waiting for its first project. Be the one to kick things off!",
            icon: FontAwesomeIcons.fileCode,
            buttonText: "Post the First Project",
            currentUserProfile: _currentUserProfile,
            onButtonPressed: () async {
               final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateProjectListingScreen()),
              );
              if (result == true) _fetchProjectListings();
            },
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchProjectListings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _projectListings.length,
        itemBuilder: (context, index) {
          final project = _projectListings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ProjectListingCard(project: project),
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
        },
      ),
    );
  }
  
  Widget _buildDevelopersTab() {
    if (_isLoadingDevelopers) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: ShimmerWidget.rectangular(height: 200),
        ),
      );
    }

    if (_developerProfiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyStateCard(
            title: "No Developers Found",
            message: "Be the first developer to list your services and get noticed by project creators!",
            icon: FontAwesomeIcons.userAstronaut,
            buttonText: "List Your Services",
            currentUserProfile: _currentUserProfile,
            onButtonPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateDeveloperProfileScreen()),
              );
              if (result == true) _fetchDeveloperProfiles();
            },
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchDeveloperProfiles,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _developerProfiles.length,
        itemBuilder: (context, index) {
          final developer = _developerProfiles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DeveloperProfileCard(
              developer: developer,
              onContact: () => _navigateToUserProfile(developer.userId),
            ),
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
        },
      ),
    );
  }
}
