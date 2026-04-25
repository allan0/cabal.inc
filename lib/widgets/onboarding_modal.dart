import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed: Not used in this file

class OnboardingModal extends StatelessWidget {
  const OnboardingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      backgroundColor: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Welcome to Cabal!", // <--- CHANGED BRANDING HERE!
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),
            const SizedBox(height: 15),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.compass,
              title: "Explore Dashboard",
              description: "See your progress, XP, and active projects.",
              delay: 400.ms,
            ),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.listCheck,
              title: "Discover Projects",
              description: "Find new projects and complete quests.",
              delay: 600.ms,
            ),
            _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.userGear,
              title: "Manage Profile",
              description: "Connect wallets, socials, and customize your display name.",
              delay: 800.ms,
            ),
             _buildFeatureHighlight(
              context,
              icon: FontAwesomeIcons.rankingStar,
              title: "Climb Leaderboard",
              description: "Compete with others by earning XP!",
              delay: 1000.ms,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              ),
              child: const Text("Let's Go!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).animate().fadeIn(delay: 1200.ms).scaleXY(begin: 0.8, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureHighlight(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Duration delay,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, size: 24, color: theme.colorScheme.secondary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.8))),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: -0.3);
  }
}

void showOnboardingInfo(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must dismiss it
    builder: (BuildContext context) {
      return const OnboardingModal();
    },
  );
}
