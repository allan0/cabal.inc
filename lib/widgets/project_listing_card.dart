// lib/widgets/project_listing_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/marketplace_models.dart';
import '../utils/app_colors.dart';

class ProjectListingCard extends StatelessWidget {
  final ProjectListing project;

  const ProjectListingCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(project.creatorAvatarUrl)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.projectName,
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                if (project.isOpen)
                  Chip(
                    label: const Text("Open"),
                    backgroundColor: AppColors.success.withOpacity(0.15),
                    labelStyle: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  )
              ],
            ),
            const SizedBox(height: 4),
            Text("by ${project.creatorName}", style: theme.textTheme.bodySmall),
            const Divider(height: 24),
            Text(project.projectDescription, maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(theme, icon: FontAwesomeIcons.dollarSign, text: project.budget),
                const SizedBox(width: 8),
                _buildInfoChip(theme, icon: FontAwesomeIcons.clock, text: project.timeline),
              ],
            ),
            const SizedBox(height: 12),
            Text("Required Skills:", style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: project.requiredSkills.map((skill) => Chip(label: Text(skill))).toList(),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("View & Propose"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(ThemeData theme, {required IconData icon, required String text}) {
    return Chip(
      avatar: FaIcon(icon, size: 14, color: theme.colorScheme.secondary),
      label: Text(text),
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }
}
