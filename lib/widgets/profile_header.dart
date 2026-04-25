// lib/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart'; // Import for AppColors

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;
  final bool isCurrentUser;
  final VoidCallback onEditProfile;
  final VoidCallback onFollow;
  final bool isFollowing;

  const ProfileHeader({
    Key? key,
    required this.userProfile,
    required this.isCurrentUser,
    required this.onEditProfile,
    required this.onFollow,
    required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayAddress = userProfile.connectedWallets['evm'] != null
        ? "${userProfile.connectedWallets['evm']!.substring(0, 6)}...${userProfile.connectedWallets['evm']!.substring(userProfile.connectedWallets['evm']!.length - 4)}"
        : "No Wallet Connected";

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.surfaceVariant,
          child: CircleAvatar(
            radius: 48,
            backgroundImage: userProfile.profileImageUrl != null
                ? NetworkImage(userProfile.profileImageUrl!)
                : null,
            child: userProfile.profileImageUrl == null
                ? FaIcon(FontAwesomeIcons.userAstronaut, size: 40, color: theme.colorScheme.onSurfaceVariant)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        // --- MODIFICATION START ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              userProfile.displayName ?? 'Cabal User',
              style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold),
            ),
            if (userProfile.is_twitter_verified == true) ...[
              const SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.questTypeTwitterBorder, size: 20),
            ]
          ],
        ),
        // --- MODIFICATION END ---
        const SizedBox(height: 4),
        if (userProfile.connectedWallets['evm'] != null)
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: userProfile.connectedWallets['evm']!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallet address copied to clipboard!')),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayAddress,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.7), fontFamily: 'monospace'),
                  ),
                  const SizedBox(width: 8),
                  FaIcon(FontAwesomeIcons.copy, size: 12, color: theme.colorScheme.onBackground.withOpacity(0.7)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCurrentUser) ...[
              ElevatedButton.icon(
                onPressed: onEditProfile,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  final referralLink = "https://cabal-001.web.app/join?ref=${userProfile.referralCode ?? userProfile.id}";
                  Share.share('Join me on Cabal! Use my referral link: $referralLink');
                },
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text('Share Profile'),
                 style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: onFollow,
                icon: FaIcon(isFollowing ? FontAwesomeIcons.userCheck : FontAwesomeIcons.userPlus, size: 14),
                label: Text(isFollowing ? 'Following' : 'Follow'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing ? theme.colorScheme.surfaceVariant : theme.colorScheme.primary,
                  foregroundColor: isFollowing ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onPrimary,
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }
}
