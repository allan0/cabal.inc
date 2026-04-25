// lib/widgets/leaderboard_preview_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'shimmer_widget.dart';

class LeaderboardPreviewCard extends StatelessWidget {
  final int? rank;
  final int? userCabalXp;
  final bool isLoading;
  final VoidCallback onTap;

  const LeaderboardPreviewCard({
    Key? key,
    required this.rank,
    required this.userCabalXp,
    required this.isLoading,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final xpFormatter = NumberFormat.compact();

    if (isLoading) {
      return const ShimmerWidget.rectangular(height: 80);
    }
    
    if (rank == null || userCabalXp == null) {
      // Don't show the card if the user isn't ranked (e.g., 0 XP)
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.rankingStar, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Cabal Rank", style: theme.textTheme.titleMedium),
                  Text("Tap to view the full leaderboard", style: theme.textTheme.bodySmall),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("#$rank", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.secondary)),
                  Text("${xpFormatter.format(userCabalXp)} XP", style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
