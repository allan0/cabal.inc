// lib/widgets/developer_profile_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/marketplace_models.dart';
import '../utils/app_colors.dart';

class DeveloperProfileCard extends StatelessWidget {
  final DeveloperProfile developer;
  final VoidCallback onContact;

  const DeveloperProfileCard({
    Key? key, 
    required this.developer,
    required this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(developer.developerAvatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(developer.developerName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(developer.tagline, style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                if (developer.isAvailable)
                  const FaIcon(FontAwesomeIcons.solidCircleCheck, color: AppColors.success, size: 20)
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: FaIcon(FontAwesomeIcons.dollarSign, size: 14, color: theme.colorScheme.secondary),
                label: Text(developer.rate),
                backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
              ),
            ),
            const Divider(height: 24),
            Text("Core Expertise:", style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: developer.skills.map((skill) => Chip(label: Text(skill))).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContact, // This now correctly uses the passed-in callback
                child: const Text("View Profile & Contact"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
