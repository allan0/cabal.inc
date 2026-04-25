// lib/screens/dashboard_screen.dart
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/screens/notifications_screen.dart'; // <-- ADD THIS IMPORT
import 'package:cabal/screens/xp_balance_screen.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:cabal/widgets/profile_header.dart';
import 'package:cabal/widgets/profile_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart';

import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import 'profile_edit_screen.dart';
import 'login_screen.dart';
import 'follower_list_screen.dart';
import '../widgets/diamond_mesh_background.dart';
import '../utils/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile? userProfile; // This is the currently LOGGED IN user
  final String? viewProfileId; // Optionally view SOMEONE ELSE's profile
  final bool isLoadingProfile;
  final Future<void> Function()? onUserProfileNeedsRefresh;

  const DashboardScreen({
    Key? key,
    this.userProfile,
    this.viewProfileId,
    required this.isLoadingProfile,
    this.onUserProfileNeedsRefresh,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SupabaseService _supabaseService = SupabaseService();

  UserProfile? _profileToDisplay;
  bool _isLoading = true;
  String? _errorMessage;
  List<CommunityPost> _userPosts = [];
  bool _isLoadingPosts = true;

  bool get _isViewingSelf {
    // If viewProfileId is null, we are viewing the logged-in user.
    // If viewProfileId is not null, compare it to the logged-in user's id.
    return widget.viewProfileId == null || widget.viewProfileId == widget.userProfile?.id;
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewProfileId != oldWidget.viewProfileId || widget.userProfile != oldWidget.userProfile) {
      _loadProfileData();
    }
  }

  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final profileId = widget.viewProfileId ?? widget.userProfile?.id;
    if (profileId == null) {
      setState(() {
        _isLoading = false;
        _profileToDisplay = null;
      });
      return;
    }

    try {
      final profileDetails = await _supabaseService.getProfileDetails(profileId);
      if (profileDetails == null) throw Exception("Profile not found.");

      if (mounted) {
        setState(() {
          _profileToDisplay = UserProfile.fromProfileDetails(profileDetails);
          _isLoading = false;
        });
        _loadUserPosts(profileId);
      }
    } catch (e) {
      debugPrint("DashboardScreen: Error loading profile data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Could not load profile.";
        });
      }
    }
  }

  Future<void> _loadUserPosts(String userId) async {
    if (!mounted) return;
    setState(() => _isLoadingPosts = true);
    final allPosts = await _supabaseService.getGlobalFeed();
    if (mounted) {
      setState(() {
        _userPosts = allPosts.where((p) => p.userId == userId).toList();
        _isLoadingPosts = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (widget.userProfile == null || _profileToDisplay == null || _isViewingSelf) return;

    final isCurrentlyFollowing = _profileToDisplay!.isFollowedByCurrentUser ?? false;
    
    setState(() {
      _profileToDisplay!.isFollowedByCurrentUser = !isCurrentlyFollowing;
      if (isCurrentlyFollowing) {
        _profileToDisplay!.followerCount = (_profileToDisplay!.followerCount ?? 1) - 1;
      } else {
        _profileToDisplay!.followerCount = (_profileToDisplay!.followerCount ?? 0) + 1;
      }
    });

    try {
      if (isCurrentlyFollowing) {
        await _supabaseService.unfollowUser(_profileToDisplay!.id);
      } else {
        await _supabaseService.followUser(_profileToDisplay!.id);
      }
      widget.onUserProfileNeedsRefresh?.call();
    } catch (e) {
      debugPrint("Error toggling follow: $e");
      _loadProfileData(); // Revert on error
    }
  }

  void _navigateToProfileEdit() {
    if (widget.userProfile == null) return;
    Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ProfileEditScreen(userProfile: widget.userProfile!)))
        .then((profileWasUpdated) {
      if (profileWasUpdated == true) {
        _loadProfileData();
        widget.onUserProfileNeedsRefresh?.call();
      }
    });
  }

  Widget _buildXpCard(ThemeData theme, UserProfile profile) {
    final numberFormat = NumberFormat.compact();

    return Card(
      elevation: 4,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: XpBalanceScreen(initialProfile: profile),
            ),
          ).then((_) => _loadProfileData());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.star, size: 32, color: AppColors.gold),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total XP", style: theme.textTheme.bodyMedium),
                  Text(
                    numberFormat.format(profile.totalXp),
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Level ${profile.level}", style: theme.textTheme.bodyMedium),
                  const Text("Manage Balance", style: TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Scaffold(backgroundColor: theme.scaffoldBackgroundColor, body: const Center(child: CircularProgressIndicator()));
    }

    if (_profileToDisplay == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: DiamondMeshBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.userLock, size: 60, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                const SizedBox(height: 20),
                Text("Please log in to view your profile.", textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login_rounded),
                  label: const Text("Log In / Sign Up"),
                  onPressed: () => Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen())),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
          ),
        ),
      );
    }

    final profile = _profileToDisplay!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: DiamondMeshBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                if (_isViewingSelf)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _navigateToProfileEdit,
                    tooltip: "Edit Profile & Settings",
                  ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ProfileHeader(
                    userProfile: profile,
                    isCurrentUser: _isViewingSelf,
                    onEditProfile: _navigateToProfileEdit,
                    onFollow: _toggleFollow,
                    isFollowing: profile.isFollowedByCurrentUser ?? false,
                  ),
                  const SizedBox(height: 24),
                  if (_isViewingSelf)
                    _buildXpCard(theme, profile),
                  const SizedBox(height: 24),
                  // --- MODIFIED STATS ROW ---
                  Row(
                    children: [
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Followers',
                          count: profile.followerCount ?? 0,
                          icon: FontAwesomeIcons.users,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                              FollowerListScreen(userId: profile.id, listType: 'Followers')
                            ));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Following',
                          count: profile.followingCount ?? 0,
                          icon: FontAwesomeIcons.userCheck,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_isViewingSelf)
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Notifications',
                            // The actual count is shown on the main nav bar, so this is just for navigation
                            count: 0, 
                            icon: FontAwesomeIcons.solidBell,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: NotificationsScreen(userId: profile.id),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Cabals Joined',
                            count: profile.joinedCabalIds.length,
                            icon: FontAwesomeIcons.rightToBracket,
                          ),
                        ),
                    ],
                  ),
                  // --- END OF MODIFICATION ---
                  const SizedBox(height: 32),
                  Text(
                    _isViewingSelf ? "Your Activity" : "Past Activity",
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
            if (_isLoadingPosts)
              const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
            else if (_userPosts.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      "${_isViewingSelf ? 'You haven\'t' : '${profile.displayName ?? 'They'} haven\'t'} posted anything yet.",
                      style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: PostCardWidget(
                          post: _userPosts[index],
                          currentUserProfile: widget.userProfile,
                        ),
                      );
                    },
                    childCount: _userPosts.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
