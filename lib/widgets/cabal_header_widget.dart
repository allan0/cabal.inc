// lib/widgets/project_header_widget.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cabal_model.dart'; // Cabal model
import '../utils/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // <--- ADDED FONT AWESOME IMPORT

class CabalHeaderWidget extends StatelessWidget {
  final Cabal project;

  const CabalHeaderWidget({Key? key, required this.project}) : super(key: key);

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    String thirdLineText = ''; // Initialize with empty string
    if (project.projectUrl != null && project.projectUrl!.isNotEmpty) {
      try {
        final uri = Uri.parse(project.projectUrl!);
        thirdLineText = uri.host; // Example: display the host/domain
      } catch (e) {
        // Keep thirdLineText empty or set to "Invalid URL"
      }
    }

    final theme = Theme.of(context); // Get theme for consistent text styles

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Ensures gradient is clipped
      // Removed `color` here, as the `Container` below will provide the background
      child: Container( // <--- WRAPPED IN CONTAINER FOR GRADIENT BACKGROUND
        decoration: BoxDecoration(
          // Subtle gradient using existing theme colors or AppColors for consistency
          gradient: LinearGradient(
            colors: [
              theme.cardTheme.color ?? AppColors.darkCardBackground, // Base dark background
              (theme.cardTheme.color ?? AppColors.darkCardBackground).withOpacity(0.9), // Slightly transparent version
              AppColors.gold.withOpacity(0.05), // Very subtle hint of gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.7, 1.0], // Control the spread of colors
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: project.logoUrl != null && project.logoUrl!.isNotEmpty
                        ? Image.network(
                            project.logoUrl!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(height: 70, width: 70, color:theme.colorScheme.surfaceVariant, child: FaIcon(FontAwesomeIcons.solidBuilding, size: 30, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))), // <--- CHANGED TO FAICON
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 70, width: 70, color: theme.colorScheme.surfaceVariant,
                                child: Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null, strokeWidth: 2, color: theme.colorScheme.primary,)),
                              );
                            },
                          )
                        : Container(height: 70, width: 70, color:theme.colorScheme.surfaceVariant, child: FaIcon(FontAwesomeIcons.solidBuilding, size: 30, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))), // <--- CHANGED TO FAICON
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: theme.textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.primary), // Use theme for consistency
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'By ${project.creatorHandle ?? "Unknown"}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: theme.textTheme.bodyMedium?.color), // Use theme for consistency
                        ),
                        if (thirdLineText.isNotEmpty) ...[ // Conditionally show this Text
                          const SizedBox(height: 2),
                          Text(
                            thirdLineText, // Use the prepared text
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: theme.textTheme.bodySmall?.color), // Use theme for consistency
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                project.description,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15, color: theme.textTheme.bodyLarge?.color, height: 1.4), // Use theme for consistency
              ),
              const SizedBox(height: 12),
              if (project.projectUrl != null && project.projectUrl!.isNotEmpty)
                InkWell(
                  onTap: () => _launchUrl(project.projectUrl!),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.link, size: 14, color: theme.colorScheme.primary), // Use theme for consistency
                      const SizedBox(width: 6),
                      Text(
                        'Visit Cabal',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.primary.withOpacity(0.8), // Use theme for consistency
                          decoration: TextDecoration.underline,
                          decorationColor: theme.colorScheme.primary.withOpacity(0.8), // Use theme for consistency
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
