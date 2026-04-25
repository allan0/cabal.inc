// lib/widgets/friends_feed_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FriendsFeedCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String timeAgo;
  final String content;
  final String? imageUrl;

  const FriendsFeedCard({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text(timeAgo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                      ],
                    ),
                  ),
                  Icon(FontAwesomeIcons.ellipsis, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
                ],
              ),
            ),
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Divider(height: 1, thickness: 0.5, color: theme.dividerColor.withOpacity(0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(theme, icon: FontAwesomeIcons.heart, label: "Like"),
                  _buildActionButton(theme, icon: FontAwesomeIcons.comment, label: "Comment"),
                  _buildActionButton(theme, icon: FontAwesomeIcons.share, label: "Share"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme, {required IconData icon, required String label}) {
    return TextButton.icon(
      onPressed: () {},
      icon: FaIcon(icon, size: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8)),
      label: Text(label, style: theme.textTheme.bodySmall),
      style: TextButton.styleFrom(
        foregroundColor: theme.textTheme.bodyMedium?.color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
