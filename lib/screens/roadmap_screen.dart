// lib/screens/roadmap_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

// --- Data Models for the Roadmap ---
enum RoadmapStatus { done, inProgress, planned }

class RoadmapFeature {
  final String title;
  final String description;
  final RoadmapStatus status;

  RoadmapFeature({
    required this.title,
    required this.description,
    required this.status,
  });
}

class RoadmapPhase {
  final String title;
  final String goal;
  final String timeline;
  final RoadmapStatus status;
  final List<RoadmapFeature> features;

  RoadmapPhase({
    required this.title,
    required this.goal,
    required this.timeline,
    required this.status,
    required this.features,
  });
}

// --- Roadmap Screen Widget ---
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({Key? key}) : super(key: key);

  // --- FULLY UPDATED ROADMAP DATA ---
  static final List<RoadmapPhase> roadmapData = [
    RoadmapPhase(
      title: "Phase 1: Foundation & Core MVP",
      goal: "Establish a stable, engaging platform with a complete user journey, from onboarding to quest completion and social interaction.",
      timeline: "Complete",
      status: RoadmapStatus.done,
      features: [
        RoadmapFeature(title: "Full User Authentication & Profiles", description: "Robust sign-up/login, profile editing, and social connections.", status: RoadmapStatus.done),
        RoadmapFeature(title: "Dynamic Cabal & Quest System", description: "Creators can launch and manage public/private cabals with quests.", status: RoadmapStatus.done),
        RoadmapFeature(title: "Live Community Hub", description: "Users can create posts and comments within cabals to foster engagement.", status: RoadmapStatus.done),
        RoadmapFeature(title: "KOL Dashboard & Referral System", description: "Influencers can track referrals and performance against set targets.", status: RoadmapStatus.done),
      ],
    ),
    RoadmapPhase(
      title: "Phase 2: Web3 Economy & Creator Tools",
      goal: "Integrate a full-fledged on-chain economy, enabling real value creation and transfer for users and creators.",
      timeline: "Complete",
      status: RoadmapStatus.done,
      features: [
        RoadmapFeature(title: "Full EVM & Solana Wallet Integration", description: "Seamless wallet connectivity on both mobile and web for secure on-chain actions.", status: RoadmapStatus.done),
        RoadmapFeature(title: "Cabal TGE & Tokenomics", description: "Deployment of the \$CBL token with on-chain vesting schedules and a public presale mechanism.", status: RoadmapStatus.done),
        RoadmapFeature(title: "On-Chain Creator Tipping", description: "Users can directly tip creators on community posts with \$CBL tokens.", status: RoadmapStatus.done),
        RoadmapFeature(title: "NFT Real Estate Protocol", description: "Ability to tokenize real-world or digital property as NFTs (Deeds) on the blockchain.", status: RoadmapStatus.done),
        RoadmapFeature(title: "NFT Marketplace V1", description: "A secure on-chain marketplace for users to list and buy NFTs for native currency (e.g., ETH).", status: RoadmapStatus.done),
      ],
    ),
    RoadmapPhase(
      title: "Phase 3: Advanced Commerce & Engagement",
      goal: "Build sophisticated commerce and engagement tools that deepen the on-chain economy and provide unparalleled value for Cabal creators.",
      timeline: "In Progress",
      status: RoadmapStatus.inProgress,
      features: [
        RoadmapFeature(title: "Cabal Giveaway Protocol", description: "Creators can lock high-value prizes (like a Tesla or USDC) into a smart contract that automatically pays out when specific on-chain growth targets are met.", status: RoadmapStatus.inProgress),
        RoadmapFeature(title: "Real Estate Offer & Bidding System", description: "Enable a secure offer/counter-offer system for NFT properties, with on-chain fund verification.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "User Wallet V2: Swaps & Management", description: "Integrate a DEX aggregator to allow users to swap \$CBL for other tokens directly within the app.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "Advanced Creator Toolkit", description: "Provide boilerplate smart contracts (e.g., for staking, DAOs) and IPFS tools that creators can easily deploy for their Cabals.", status: RoadmapStatus.planned),
      ],
    ),
    RoadmapPhase(
      title: "Phase 4: Decentralization & Multi-Chain",
      goal: "Transition core functionalities to user-owned protocols and expand Cabal's presence across multiple blockchain ecosystems.",
      timeline: "Planned",
      status: RoadmapStatus.planned,
      features: [
        RoadmapFeature(title: "Cabal Governance (DAO)", description: "Allow \$CBL token holders to vote on platform features, treasury usage, and fee structures.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "Full Solana Protocol Parity", description: "Implement Solana-native smart contracts for the marketplace, escrow, and giveaways.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "L2 & Multi-Chain Deployment", description: "Deploy contracts on Layer 2 solutions like Base or Arbitrum to drastically reduce user gas fees and improve speed.", status: RoadmapStatus.planned),
      ],
    ),
    RoadmapPhase(
      title: "Phase 5: Monetization & Sustainability",
      goal: "Introduce sustainable, value-aligned revenue streams to ensure the long-term growth and development of the Cabal ecosystem.",
      timeline: "Planned",
      status: RoadmapStatus.planned,
      features: [
        RoadmapFeature(title: "Marketplace & Escrow Fees", description: "A small, transparent percentage fee on successful NFT and real estate transactions.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "Premium Creator Tools", description: "Offer advanced analytics, custom smart contract templates, and priority support for a subscription in \$CBL.", status: RoadmapStatus.planned),
        RoadmapFeature(title: "TGE Launchpad Service Fees", description: "A fee for projects that use Cabal's platform to launch their own tokens and manage their TGE.", status: RoadmapStatus.planned),
      ],
    ),
  ];

  Widget _buildStatusIcon(RoadmapStatus status, ThemeData theme) {
    switch (status) {
      case RoadmapStatus.done:
        return FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.success, size: 20);
      case RoadmapStatus.inProgress:
        return FaIcon(FontAwesomeIcons.spinner, color: theme.colorScheme.primary, size: 20)
            .animate(onPlay: (c) => c.repeat())
            .rotate(duration: 1500.ms);
      case RoadmapStatus.planned:
        return FaIcon(FontAwesomeIcons.lightbulb, color: theme.colorScheme.secondary.withOpacity(0.8), size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Roadmap"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: isDark ? AppColors.particleGoldSoft.withOpacity(0.2) : AppColors.particleGoldSoft.withOpacity(0.4),
        particleColor2: isDark ? AppColors.particleGreySoft.withOpacity(0.2) : AppColors.particleGreySoft.withOpacity(0.3),
        child: ListView.builder(
          padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top + 20, left: 16, right: 16, bottom: 40),
          itemCount: roadmapData.length,
          itemBuilder: (context, index) {
            final phase = roadmapData[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatusIcon(phase.status, theme),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            phase.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phase.timeline,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                      ),
                    ),
                    Divider(height: 24, thickness: 0.5, color: theme.dividerColor.withOpacity(0.5)),
                    Text(
                      phase.goal,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ...phase.features.map(
                      (feature) => ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                        childrenPadding: const EdgeInsets.all(12.0).copyWith(top: 0),
                        leading: _buildStatusIcon(feature.status, theme),
                        title: Text(
                          feature.title,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        children: [
                          Text(
                            feature.description,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (200 * index).ms).slideY(begin: 0.2);
          },
        ),
      ),
    );
  }
}
