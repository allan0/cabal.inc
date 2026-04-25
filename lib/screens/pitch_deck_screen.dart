// lib/screens/pitch_deck_screen.dart
import 'package:cabal/utils/app_colors.dart';
import 'package:cabal/widgets/diamond_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class PitchDeckScreen extends StatefulWidget {
  const PitchDeckScreen({Key? key}) : super(key: key);

  @override
  State<PitchDeckScreen> createState() => _PitchDeckScreenState();
}

class _PitchDeckScreenState extends State<PitchDeckScreen> {
  late VideoPlayerController _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/videos/cabal_promo.mp4',
    );
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      _videoController.setVolume(0.0); // Mute demo video
      _videoController.play();
      if (mounted) setState(() {}); // Update UI once video is ready
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Project Pitch Deck")),
      body: DiamondMeshBackground(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTitleSlide(theme, "Cabal: The Web3 Growth & Commerce Engine"),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.lightbulb,
              title: "The Problem",
              content: "Web3 projects struggle with two critical challenges: acquiring real, engaged users and creating sustainable token economies. Traditional growth-hacking is expensive and often attracts mercenary users, while building on-chain commerce tools from scratch is complex and diverts focus from the core product."
            ),
             _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.rocket,
              title: "Our Solution",
              content: "Cabal is a comprehensive, on-chain platform that provides projects with the tools to grow, engage, and monetize their communities. We turn user acquisition into a gamified, rewarding experience and provide the Web3 commerce infrastructure (NFTs, marketplaces, escrow) needed for a thriving digital economy."
            ),
             _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.handshake,
              title: "Revenue Generation Model",
              content: "Our business model is designed for sustainability and alignment with our users' success:\n\n"
                       "1.  **Marketplace & Escrow Fees (2.5%)**: A small, transparent fee on all successful NFT and real estate transactions.\n\n"
                       "2.  **TGE Launchpad Services (1-2%)**: A success fee for projects that use our platform to launch their own tokens, ensuring we only win when they do.\n\n"
                       "3.  **Premium Creator Tools (Subscription)**: A tiered subscription model paid in \$CBL for Cabal creators, unlocking advanced analytics, custom smart contract templates, and priority support."
            ),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.users,
              title: "Target Market",
              content: "Our primary customers are new and existing Web3 projects, including DeFi protocols, GameFi studios, NFT artists, and real estate tokenization platforms. Our secondary market is the vast community of Web3 users, KOLs, and developers looking for new opportunities, rewards, and tools."
            ),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.road,
              title: "Roadmap at a Glance",
              content: "Phase 1 (Done): Core Platform & MVP.\n"
                       "Phase 2 (Done): Web3 Economy & Creator Tools.\n"
                       "Phase 3 (In Progress): Advanced Commerce & Giveaways.\n"
                       "Phase 4 (Planned): Full Decentralization & L2 Scaling.",
            ),
            _buildSection(
              theme: theme,
              icon: FontAwesomeIcons.circlePlay,
              title: "Platform Demo",
              contentWidget: _buildVideoPlayer(),
            ),
          ].animate(interval: 200.ms).fadeIn().slideY(begin: 0.1),
        ),
      ),
    );
  }

  Widget _buildTitleSlide(ThemeData theme, String title) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    String? content,
    Widget? contentWidget,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(title, style: theme.textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            if (content != null)
              Text(content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
            if (contentWidget != null)
              contentWidget,
          ],
        ),
      ),
    );
  }
  
  Widget _buildVideoPlayer() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && _videoController.value.isInitialized) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_videoController),
                  IconButton(
                    iconSize: 64,
                    icon: Icon(
                      _videoController.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
                      });
                    },
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading video demo."));
        } else {
          return const AspectRatio(
            aspectRatio: 16/9,
            child: Center(child: CircularProgressIndicator())
          );
        }
      },
    );
  }
}
