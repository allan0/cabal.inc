// lib/features/onboarding/presentation/onboarding_preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../../utils/app_colors.dart';
import '../../../widgets/animated_particle_background.dart';
import '../../../widgets/quest_complete_celebration.dart';
import '../application/onboarding_provider.dart';
import '../../../models/user_profile_model.dart';
import '../../../models/quest_model.dart';
import '../../../features/wallet/application/wallet_provider.dart';
import '../../../features/wallet/presentation/widgets/wallet_connector_widget.dart';
import '../../../screens/home_nav_wrapper.dart';
import '../../../screens/login_screen.dart';
import '../../../utils/constants.dart';

class OnboardingPreferencesScreen extends StatefulWidget {
  const OnboardingPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingPreferencesScreen> createState() => _OnboardingPreferencesScreenState();
}

class _OnboardingPreferencesScreenState extends State<OnboardingPreferencesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  User? _currentUser;
  bool _walletQuestCompleted = false;

  // Define the onboarding wallet connection quest
  final Quest _walletQuest = Quest(
    id: 'onboarding_wallet_connect',
    title: 'Connect Your First Wallet',
    description: 'LFG! Connect an EVM or Solana wallet to join the Web3 degen crew!',
    xpReward: 100,
    type: QuestType.connectWalletEth,
    iconName: 'wallet',
    isCompletedByUser: false,
    isLockedForUser: false,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    _currentUser = Supabase.instance.client.auth.currentUser;
    if (_currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to set your preferences.'), backgroundColor: Colors.red),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen(fromLogout: false)),
            (route) => false,
          );
        }
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
        onboardingProvider.fetchAvailableCoins();
        final authUser = Supabase.instance.client.auth.currentUser;
        if (authUser != null) {
          try {
            final UserProfile? userProfile = await onboardingProvider.supabaseService.getUserProfile(authUser.id);
            if (mounted) {
              onboardingProvider.initializeFromUserProfile(userProfile);
              // Check if wallet is already connected from a previous session
              if (userProfile?.connectedWallets.isNotEmpty ?? false) {
                 setState(() => _walletQuestCompleted = true);
              }
            }
          } catch (e) {
            debugPrint("Error fetching user profile for onboarding: $e");
          }
        }
      }
    });
  }

  void _handleTabChange() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  Future<void> _completeWalletQuest() async {
    if (_walletQuestCompleted || !mounted) return;

    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() => _walletQuestCompleted = true);
    showQuestCompleteCelebration(context); // Trigger celebration animation!

    try {
      final result = await onboardingProvider.supabaseService.completeQuest(_walletQuest.id);
      if (result['success'] as bool? ?? false) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Quest complete! +${_walletQuest.xpReward} XP'), backgroundColor: AppColors.success),
        );
      } else {
        throw Exception(result['message'] ?? 'Failed to complete quest.');
      }
    } catch (e) {
      debugPrint("Error completing wallet quest: $e");
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error saving quest progress: $e'), backgroundColor: Colors.red),
      );
      // Revert state on failure
      if (mounted) setState(() => _walletQuestCompleted = false);
    }
  }

  Future<void> _saveAndNavigate() async {
    if (_currentUser == null || !mounted) return;
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);

    final bool success = await onboardingProvider.savePreferences(_currentUser!.id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_walletQuestCompleted
              ? 'Preferences saved! Wallet connected, degen! Welcome to Cabal!'
              : 'Preferences saved! Welcome to Cabal!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeNavWrapper(showOnboarding: false)),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(onboardingProvider.saveError ?? 'Failed to save preferences.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    if (_currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Web3 Degen!'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorite Coins'),
            Tab(text: 'Interests'),
            Tab(text: 'Join the Chain'),
          ],
          labelStyle: theme.textTheme.titleMedium,
          unselectedLabelStyle: theme.textTheme.titleSmall,
          indicatorColor: theme.colorScheme.secondary,
          labelColor: theme.colorScheme.secondary,
          unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: isDark ? AppColors.particleGoldSoft.withOpacity(0.2) : AppColors.particleGoldSoft.withOpacity(0.4),
        particleColor2: isDark ? AppColors.particleGreySoft.withOpacity(0.2) : AppColors.particleGreySoft.withOpacity(0.3),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCoinSelectionTab(theme, onboardingProvider),
                  _buildInterestSelectionTab(theme, onboardingProvider),
                  _buildWalletConnectionTab(theme, onboardingProvider),
                ],
              ),
            ),
            _buildSaveButton(theme, onboardingProvider),
            if (onboardingProvider.saveError != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  onboardingProvider.saveError!,
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletConnectionTab(ThemeData theme, OnboardingProvider provider) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        // --- REACTIVE QUEST COMPLETION LOGIC ---
        if ((walletProvider.isConnectedEVM || walletProvider.isConnectedSolana) && !_walletQuestCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _completeWalletQuest();
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _walletQuest.title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _walletQuest.description,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.star, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_walletQuest.xpReward} XP Reward',
                    style: theme.textTheme.titleSmall?.copyWith(color: AppColors.gold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _walletQuestCompleted
                  ? Card(
                      elevation: 3,
                      color: AppColors.success.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.success, width: 1.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.success, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'LFG! Wallet connected. You’re a Web3 degen now!',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).shake(hz: 3, duration: 400.ms)
                  : WalletConnectorWidget().animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            ],
          ),
        );
      }
    );
  }
  
  Widget _buildInterestSelectionTab(ThemeData theme, OnboardingProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select up to 5 interests that align with your Web3 goals:',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          if (provider.coinLoadError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                provider.coinLoadError!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableInterests.map((interest) {
                  final isSelected = provider.selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      provider.toggleInterestSelection(interest);
                    },
                    selectedColor: theme.colorScheme.secondary,
                    checkmarkColor: theme.colorScheme.onSecondary,
                    labelStyle: theme.chipTheme.labelStyle?.copyWith(
                      color: isSelected ? theme.colorScheme.onSecondary : theme.chipTheme.labelStyle?.color,
                    ),
                    backgroundColor: theme.chipTheme.backgroundColor,
                  ).animate().fadeIn(delay: (50 * availableInterests.indexOf(interest)).ms);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCoinSelectionTab(ThemeData theme, OnboardingProvider provider) {
    if (provider.isLoadingCoins) {
      return Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary));
    }
    if (provider.coinLoadError != null && provider.availableCoins.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 40),
              const SizedBox(height: 10),
              Text(provider.coinLoadError!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: provider.fetchAvailableCoins,
                child: const Text('Retry Loading Coins'),
              ),
            ],
          ),
        ),
      );
    }
    if (provider.availableCoins.isEmpty) {
      return Center(
        child: Text(
          'No coins available. Try again later.',
          style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Select up to 10 coins you are most interested in:',
            style: theme.textTheme.titleSmall,
          ),
        ),
        if (provider.coinLoadError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              provider.coinLoadError!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: provider.availableCoins.length,
              itemBuilder: (context, index) {
                final coin = provider.availableCoins[index];
                final isSelected = provider.selectedPreferredCoinIds.contains(coin.id);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: isSelected ? 3 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
                      width: isSelected ? 1.5 : 0,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      backgroundImage: coin.imageUrl.isNotEmpty ? NetworkImage(coin.imageUrl) : null,
                      child: coin.imageUrl.isEmpty ? Text(coin.symbol.toUpperCase().substring(0,1), style: TextStyle(color: theme.colorScheme.primary)) : null,
                    ),
                    title: Text(coin.name, style: theme.textTheme.titleSmall),
                    subtitle: Text(coin.symbol.toUpperCase(), style: theme.textTheme.bodySmall),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: theme.colorScheme.secondary)
                        : Icon(Icons.radio_button_unchecked, color: theme.disabledColor),
                    onTap: () => provider.toggleCoinSelection(coin.id),
                  ),
                ).animate().fadeIn(delay: (50 * (index % 10)).ms).slideX(begin: index.isEven ? -0.05 : 0.05);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme, OnboardingProvider provider) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).padding.bottom + 16.0,
        top: 16.0,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: provider.isSavingPreferences ? null : _saveAndNavigate,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: provider.isSavingPreferences
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2.5),
              )
            : const Text('Save & Enter Cabal'),
      ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
    );
  }
}
