// lib/widgets/empty_state_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../models/user_profile_model.dart';
import '../screens/login_screen.dart';

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final UserProfile? currentUserProfile; // Pass this to check login status

  const EmptyStateCard({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.buttonText,
    required this.onButtonPressed,
    this.currentUserProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void handleTap() {
      if (currentUserProfile == null) {
        // If user is a guest, navigate to login first
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const LoginScreen(),
          ),
        );
      } else {
        // If user is logged in, perform the intended action
        onButtonPressed();
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(icon, size: 48, color: theme.colorScheme.primary.withOpacity(0.7)),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleTap,
              style: theme.elevatedButtonTheme.style,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
