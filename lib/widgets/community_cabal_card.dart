// lib/widgets/community_cabal_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/community_cabal_preview.dart';
import '../utils/app_colors.dart';

class CommunityCabalCard extends StatelessWidget {
  final CommunityCabalPreview preview;
  final VoidCallback onTap;

  const CommunityCabalCard({
    Key? key,
    required this.preview,
    required this.onTap,
  }) : super(key: key);

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'No posts yet';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return "${difference.inSeconds}s ago";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    return DateFormat('MMM d').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: preview.cabal.logoUrl != null
                        ? NetworkImage(preview.cabal.logoUrl!)
                        : null,
                    child: preview.cabal.logoUrl == null
                        ? FaIcon(FontAwesomeIcons.usersRectangle, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preview.cabal.name,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "by ${preview.cabal.creatorHandle ?? 'Unknown'}",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              if (preview.latestPostSnippet != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaIcon(FontAwesomeIcons.quoteLeft, size: 12, color: theme.colorScheme.secondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"${preview.latestPostSnippet!}"',
                        style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatChip(theme, icon: FontAwesomeIcons.users, text: "${preview.memberCount} Members"),
                  _buildStatChip(theme, icon: FontAwesomeIcons.solidMessage, text: "${preview.postCount} Posts"),
                  Text(
                    "Last post: ${_formatTimeAgo(preview.latestPostTimestamp)}",
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(ThemeData theme, {required IconData icon, required String text}) {
    return Chip(
      avatar: FaIcon(icon, size: 14, color: theme.colorScheme.secondary),
      label: Text(text),
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}
