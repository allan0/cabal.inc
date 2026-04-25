// lib/screens/home_nav_wrapper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

// Screen Imports
import 'landing_screen.dart';
import 'cabal_list_screen.dart';
import 'placeholder_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import '../features/onboarding/presentation/onboarding_preferences_screen.dart';
import 'notifications_screen.dart';
import 'community_hub_screen.dart';

// Model & Service Imports
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import '../audio/audio_controller.dart';

// Util & Widget Imports
import '../utils/app_colors.dart';

class HomeNavWrapper extends StatefulWidget {
  final bool showOnboarding;
  const HomeNavWrapper({ Key? key, this.showOnboarding = false, }) : super(key: key);
  @override
  State<HomeNavWrapper> createState() => _HomeNavWrapperState();
}

class _HomeNavWrapperState extends State<HomeNavWrapper> {
  int _selectedIndex = 0;
  UserProfile? _userProfile;
  bool _isLoadingProfile = true;
  int _unreadNotificationsCount = 0;
  final SupabaseService _supabaseService = SupabaseService();
  StreamSubscription<AuthState>? _authSubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;

  late List<Widget> _widgetOptions;
  late List<String> _pageTitles;
  late List<IconData> _pageIcons;

  bool _isNavigationRailExtended = false;
  static const double _minDesktopWidth = 720;
  bool _isNewsPanelVisible = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeNavigationItems();
    _widgetOptions = _buildWidgetOptions(null, true);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioController>().startMusic();
      _setupAuthListener();
      final initialSession = _supabaseService.getCurrentUser();
      if (initialSession != null) {
        _refreshCurrentUserProfile(initialSession.id, showOnboardingAfterLoad: widget.showOnboarding);
      } else {
        _handleSignedOutUser(isInitialLoad: true);
      }
    });
  }

  void _setupAuthListener() {
    _authSubscription = _supabaseService.authStateChanges.listen((AuthState data) {
      final session = data.session;
      
      if (data.event == AuthChangeEvent.signedIn && session != null) {
        _refreshCurrentUserProfile(session.user.id, showOnboardingAfterLoad: true);
      } else if (data.event == AuthChangeEvent.signedOut) {
        _handleSignedOutUser();
      }
    });
  }

  void _toggleNewsPanel() => setState(() => _isNewsPanelVisible = !_isNewsPanelVisible);

  void _initializeNavigationItems() {
    _pageTitles = [ 'Home', 'Explore', 'Leaderboard', 'Community', 'My Profile' ];
    _pageIcons = [ FontAwesomeIcons.house, FontAwesomeIcons.compass, FontAwesomeIcons.rankingStar, FontAwesomeIcons.users, FontAwesomeIcons.solidUserCircle ];
  }

  void _navigateToLoginScreen() {
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
  }

  void _handleSignedOutUser({bool isInitialLoad = false}) {
    if (!mounted) return;
    setStateIfMounted(() {
      _userProfile = null;
      _isLoadingProfile = false;
      _widgetOptions = _buildWidgetOptions(null, false);
      _unreadNotificationsCount = 0;
      if (!isInitialLoad && _selectedIndex != 0) {
        _selectedIndex = 0;
        if (_pageController.hasClients) _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _refreshCurrentUserProfile(String userId, {bool showOnboardingAfterLoad = false}) async {
    if (!mounted) return;
    if (_userProfile?.id != userId || _userProfile == null) {
      setStateIfMounted(() => _isLoadingProfile = true);
    }

    try {
      final profile = await _supabaseService.getUserProfile(userId);
      if (profile == null) {
        if(mounted) _handleSignedOutUser();
        return;
      }
      
      await _supabaseService.recordActivity();
      
      final unreadCount = await _supabaseService.getUnreadNotificationCount(profile.id);

      if (mounted) {
        setStateIfMounted(() {
          _userProfile = profile;
          _unreadNotificationsCount = unreadCount;
          _isLoadingProfile = false;
          _widgetOptions = _buildWidgetOptions(_userProfile, false);
        });

        bool needsOnboarding = (profile.preferredCoinIds.isEmpty || profile.interests.isEmpty) && (profile.displayName == null || profile.displayName!.length <= 8);
        if (showOnboardingAfterLoad && needsOnboarding) {
           WidgetsBinding.instance.addPostFrameCallback((_) {
               if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const OnboardingPreferencesScreen()),
                );
               }
           });
        }
      }
    } catch (e) {
      debugPrint("Error refreshing profile: $e");
      if (mounted) {
        _handleSignedOutUser();
        setStateIfMounted(() => _isLoadingProfile = false);
      }
    }
  }

  void setStateIfMounted(VoidCallback fn) { if (mounted) setState(fn); }

  List<Widget> _buildWidgetOptions(UserProfile? userProfile, bool isLoadingProfile) {
    return <Widget>[
      LandingScreen(currentUserProfile: userProfile, onNavigateToProfile: () => _onItemTapped(4), onNavigateToLeaderboard: () => _onItemTapped(2), onNavigateToCabals: () => _onItemTapped(1), isNewsPanelVisible: _isNewsPanelVisible, onToggleNewsPanel: _toggleNewsPanel),
      const CabalListScreen(),
      const PlaceholderScreen(title: "Global Leaderboard", icon: FontAwesomeIcons.rankingStar, message: "Global rankings are coming soon! View leaderboards within each Cabal for now."),
      const CommunityHubScreen(),
      DashboardScreen(userProfile: userProfile, isLoadingProfile: isLoadingProfile, onUserProfileNeedsRefresh: () => _userProfile != null ? _refreshCurrentUserProfile(_userProfile!.id) : Future.value()),
    ];
  }
  
  void _onItemTapped(int index) {
    context.read<AudioController>().playSfx();
    const protectedIndices = {4};

    if (_userProfile == null && protectedIndices.contains(index)) { 
      _navigateToLoginScreen();
      return;
    }
    
    if (mounted) {
       _pageController.animateToPage(index, duration: 400.ms, curve: Curves.easeInOutQuad);
       if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
         Navigator.of(context).pop();
       }
    }
  }

  void _navigateToNotifications() {
     if (_userProfile == null) {
        _navigateToLoginScreen();
        return;
     }
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: NotificationsScreen(userId: _userProfile!.id)))
      .then((_) => mounted && _userProfile != null ? _refreshCurrentUserProfile(_userProfile!.id) : null);
  }
  
  List<NavigationRailDestination> _buildNavigationRailDestinations(ThemeData theme) {
    var destinations = List.generate(_pageTitles.length, (index) {
      bool hasBadge = index == 4 && _userProfile != null && _unreadNotificationsCount > 0;
      return NavigationRailDestination(
        icon: Badge(
          isLabelVisible: hasBadge,
          label: Text('$_unreadNotificationsCount'),
          child: FaIcon(_pageIcons[index])
        ),
        label: Text(_pageTitles[index]),
      );
    });
    if (!_isNewsPanelVisible) {
      destinations.add(const NavigationRailDestination(icon: FaIcon(FontAwesomeIcons.newspaper), label: Text("News Feed")));
    }
    return destinations;
  }

  List<Widget> _buildDrawerItems(ThemeData theme) {
    var items = List.generate(_pageTitles.length, (index) {
       bool hasBadge = index == 4 && _userProfile != null && _unreadNotificationsCount > 0;
       return ListTile(
        leading: FaIcon(_pageIcons[index], color: _selectedIndex == index ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7)),
        title: Text(_pageTitles[index], style: TextStyle(fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal)),
        selected: _selectedIndex == index,
        selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
        trailing: hasBadge ? Badge(label: Text('$_unreadNotificationsCount')) : null,
        onTap: () => _onItemTapped(index),
      );
    });
    if (!_isNewsPanelVisible) {
      items.add(ListTile(
        leading: FaIcon(FontAwesomeIcons.newspaper, color: theme.colorScheme.onSurface.withOpacity(0.7)),
        title: const Text("News Feed"),
        onTap: () {
          _toggleNewsPanel();
          _onItemTapped(0);
        },
      ));
    }
    return items;
  }

  Drawer _buildDrawer(ThemeData theme) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkGrey, AppColors.offBlack.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Cabal', style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(_userProfile?.displayName ?? "Guest Explorer", style: theme.textTheme.titleMedium?.copyWith(color: AppColors.lightText.withOpacity(0.8))),
              ],
            ),
          ),
          Expanded(child: ListView(padding: EdgeInsets.zero, children: _buildDrawerItems(theme))),
        ],
      ),
    );
  }
  
  AppBar _buildMobileAppBar(ThemeData theme) {
    return AppBar(
      elevation: 1,
      title: Text(_pageTitles[_selectedIndex]),
      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
      actions: [
        IconButton(
          icon: Badge(
            isLabelVisible: _userProfile != null && _unreadNotificationsCount > 0,
            label: Text('$_unreadNotificationsCount'),
            child: const FaIcon(FontAwesomeIcons.solidBell, size: 20)
          ),
          onPressed: _navigateToNotifications,
          tooltip: "Notifications",
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktopWeb = kIsWeb && screenWidth >= _minDesktopWidth;

    if (_isLoadingProfile && _supabaseService.getCurrentUser() != null && _userProfile == null) {
        return Scaffold(body: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)));
    }
    
    Widget mainContent = PageView(
      controller: _pageController,
      onPageChanged: (index) => setStateIfMounted(() => _selectedIndex = index),
      children: _widgetOptions,
    );

    if (isDesktopWeb) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                if (index >= _pageTitles.length) {
                   _toggleNewsPanel();
                   _onItemTapped(0);
                } else {
                  _onItemTapped(index);
                }
              },
              labelType: _isNavigationRailExtended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
              extended: _isNavigationRailExtended,
              minExtendedWidth: 220,
              leading: Column(
                children: [
                  const SizedBox(height: 20),
                  if (_isNavigationRailExtended)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Cabal", style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    ),
                  IconButton(
                    icon: Icon(_isNavigationRailExtended ? Icons.menu_open_rounded : Icons.menu_rounded),
                    onPressed: () => setStateIfMounted(() => _isNavigationRailExtended = !_isNavigationRailExtended),
                    tooltip: _isNavigationRailExtended ? "Collapse Menu" : "Expand Menu",
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              destinations: _buildNavigationRailDestinations(theme),
              elevation: 2,
              backgroundColor: theme.colorScheme.surface,
              indicatorColor: theme.colorScheme.primary.withOpacity(0.2),
              selectedLabelTextStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              selectedIconTheme: IconThemeData(color: theme.colorScheme.primary),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: mainContent),
          ],
        ),
      );
    } else { // Mobile view
      return Scaffold(
        key: _scaffoldKey,
        appBar: _selectedIndex == 0 ? null : _buildMobileAppBar(theme),
        drawer: _buildDrawer(theme),
        body: mainContent,
      );
    }
  }
}
