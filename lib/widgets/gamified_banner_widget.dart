// lib/widgets/gamified_banner_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import 'app_logo_widget.dart';
import 'package:intl/intl.dart';

class GamifiedBannerWidget extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback? onTapLeaderboard;

  const GamifiedBannerWidget({
    Key? key,
    this.userProfile,
    this.onTapLeaderboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final NumberFormat xpFormatter = NumberFormat.compact();

    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(top: MediaQuery.of(context).padding.top + 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.9),
            theme.colorScheme.primary.withOpacity(0.7),
            theme.colorScheme.secondary.withOpacity(0.6)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppLogoWidget(logoHeight: 40).animate().fadeIn(delay: 200.ms).slideX(begin: -0.5),
              Text(
                "Cabal",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(1, 1), blurRadius: 2),
                  ]
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.5),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Cabal Intelligence Feed",
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white.withOpacity(0.95)),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
          const SizedBox(height: 8),
          if (userProfile != null)
            Row(
              children: [
                FaIcon(FontAwesomeIcons.medal, color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Level ${userProfile!.level}",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                FaIcon(FontAwesomeIcons.starHalfStroke, color: AppColors.accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  "${xpFormatter.format(userProfile!.totalXp)} XP",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
          const SizedBox(height: 10),
          if (onTapLeaderboard != null)
            Align(
              alignment: Alignment.centerRight,
              child: ActionChip(
                avatar: FaIcon(FontAwesomeIcons.rankingStar, color: theme.colorScheme.primary, size: 16),
                label: Text("View Leaderboard", style: TextStyle(color: theme.colorScheme.primary)),
                onPressed: onTapLeaderboard,
                backgroundColor: AppColors.accent.withOpacity(0.9),
                elevation: 2,
              ).animate().fadeIn(delay: 800.ms).scaleXY(begin: 0.8)
            ),
        ],
      ),
    );
  }
}
