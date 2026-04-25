// lib/widgets/cabal_card_widget.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/cabal_model.dart';
import '../utils/app_colors.dart';

enum CabalCardLayout { horizontalList, grid } // <-- NEW: Layout enum

class CabalCardWidget extends StatelessWidget {
  final Cabal project;
  final VoidCallback onTap;
  final CabalCardLayout layout; // <-- NEW: Layout property

  const CabalCardWidget({
    Key? key, 
    required this.project, 
    required this.onTap,
    this.layout = CabalCardLayout.horizontalList, // <-- NEW: Default layout
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return layout == CabalCardLayout.horizontalList 
      ? _buildHorizontalListCard(context)
      : _buildGridCard(context);
  }

  // This is the original card layout, now in its own method
  Widget _buildHorizontalListCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.85),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(theme, height: 100),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.description,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (project.isPrivate)
                      Chip(
                        avatar: const FaIcon(FontAwesomeIcons.lock, size: 12),
                        label: const Text("Private"),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        labelStyle: theme.textTheme.bodySmall,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // <-- NEW: A more compact card for the grid layout -->
  Widget _buildGridCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: theme.cardColor.withOpacity(0.85),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
              project.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: project.isPrivate 
              ? const FaIcon(FontAwesomeIcons.lock, size: 14, color: Colors.white70) 
              : null,
          ),
          child: _buildBanner(theme, height: double.infinity),
        ),
      ),
    );
  }

  Widget _buildBanner(ThemeData theme, {required double height}) {
    if (project.bannerImageUrl != null && project.bannerImageUrl!.isNotEmpty) {
      return Image.network(
        project.bannerImageUrl!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _buildPlaceholderBanner(theme, height: height),
      );
    }
    return _buildPlaceholderBanner(theme, height: height);
  }

  Widget _buildPlaceholderBanner(ThemeData theme, {required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.usersRectangle,
          size: 30,
          color: theme.colorScheme.primary.withOpacity(0.6),
        ),
      ),
    );
  }
}
