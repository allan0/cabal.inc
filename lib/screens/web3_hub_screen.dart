// lib/screens/web3_hub_screen.dart
import 'package:cabal/models/user_profile_model.dart';
import 'package:cabal/screens/login_screen.dart';
import 'package:cabal/screens/marketplace_screen.dart';
import 'package:cabal/screens/presale_screen.dart';
import 'package:cabal/screens/token_analytics_screen.dart';
import 'package:cabal/screens/token_factory_screen.dart';
import 'package:cabal/screens/tokenomics_screen.dart';
import 'package:cabal/screens/user_wallet_screen.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:cabal/widgets/info_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class Web3HubScreen extends StatelessWidget {
  final UserProfile? userProfile;

  const Web3HubScreen({Key? key, this.userProfile}) : super(key: key);

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
        context, PageTransition(type: PageTransitionType.rightToLeft, child: screen));
  }

  void _navigateToProtected(BuildContext context, Widget screen) {
    if (userProfile != null) {
      _navigateTo(context, screen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please log in to use this feature.")));
      _navigateTo(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Web3 Hub"),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      ),
      body: DiamondMeshBackground(
        child: ListView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 16,
            right: 16,
            bottom: 40,
          ),
          children: [
            // --- Wallet Section ---
            _buildSectionHeader(theme, "My Wallet & Assets"),
            InfoTileWidget(
              icon: FontAwesomeIcons.wallet,
              title: "View My Wallet",
              subtitle: "Browse your on-chain tokens, NFTs, and property deeds.",
              onTap: () => _navigateToProtected(context, UserWalletScreen(userProfile: userProfile!)),
            ),
            const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.store,
              title: "NFT Marketplace",
              subtitle: "Buy and sell tokenized assets like Real Estate Deeds.",
              onTap: () => _navigateTo(context, const MarketplaceScreen()),
            ),
            const SizedBox(height: 24),

            // --- Creator Tools Section ---
            _buildSectionHeader(theme, "Creator Tools"),
             InfoTileWidget(
              icon: FontAwesomeIcons.coins,
              title: "Token Factory",
              subtitle: "Launch your own ERC20 community token with just a few clicks.",
              onTap: () => _navigateToProtected(context, TokenFactoryScreen(userProfile: userProfile!)),
            ),
            const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.gift,
              title: "Launch a Giveaway",
              subtitle: "Create a trustless, on-chain giveaway for your Cabal.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please launch giveaways from the 'Manage Cabal' screen."))
                );
              },
            ),
            const SizedBox(height: 24),
            
            // --- Token Economy Section ---
            _buildSectionHeader(theme, "\$CBL Token Economy"),
            InfoTileWidget(
              icon: FontAwesomeIcons.fire,
              title: "Token Presale",
              subtitle: "Participate in the early bird token sale.",
              onTap: () => _navigateTo(context, const PresaleScreen()),
            ),
            const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.chartPie,
              title: "Token Analytics",
              subtitle: "View live on-chain metrics for the \$CBL token.",
              onTap: () => _navigateTo(context, const TokenAnalyticsScreen()),
            ),
             const SizedBox(height: 12),
            InfoTileWidget(
              icon: FontAwesomeIcons.coins,
              title: "Tokenomics",
              subtitle: "Learn about the distribution and utility of \$CBL.",
              onTap: () => _navigateTo(context, const TokenomicsScreen()),
            ),
            
          ].animate(interval: 80.ms).fadeIn().slideX(begin: 0.1),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(title, style: theme.textTheme.headlineSmall),
    );
  }
}
