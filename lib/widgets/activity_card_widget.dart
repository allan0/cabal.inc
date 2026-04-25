// lib/widgets/activity_card_widget.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; 
import '../models/activity_model.dart';
import '../utils/app_colors.dart';

class ActivityCardWidget extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onTap;

  const ActivityCardWidget({
    Key? key,
    required this.activity,
    this.onTap,
  }) : super(key: key);

  // Helper to get the appropriate icon for each activity type
  IconData _getIconForActivityType(ActivityType type) {
    switch (type) {
      case ActivityType.cabalCreated:
        return FontAwesomeIcons.plus;
      case ActivityType.questCompleted:
        return FontAwesomeIcons.solidCircleCheck;
      case ActivityType.achievementUnlocked:
        return FontAwesomeIcons.trophy;
      case ActivityType.userJoined:
        return FontAwesomeIcons.userPlus;
      default:
        return FontAwesomeIcons.infoCircle;
    }
  }

  // Helper to build the rich text description for the activity
  Widget _buildActivityText(BuildContext context, ThemeData theme) {
    final userStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary);
    final regularStyle = theme.textTheme.titleSmall;
    final contentStyle = theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary);

    final displayName = activity.userDisplayName ?? 'A user';
    final content = activity.content ?? 'an activity';

    List<TextSpan> textSpans;

    switch (activity.type) {
      case ActivityType.cabalCreated:
        textSpans = [
          TextSpan(text: displayName, style: userStyle),
          TextSpan(text: ' created a new cabal: ', style: regularStyle),
          TextSpan(text: content, style: contentStyle),
        ];
        break;
      case ActivityType.questCompleted:
        textSpans = [
          TextSpan(text: displayName, style: userStyle),
          TextSpan(text: ' completed the quest: ', style: regularStyle),
          TextSpan(text: content, style: contentStyle),
        ];
        break;
      // Add more cases here as you implement more activity types
      default:
        textSpans = [
          TextSpan(text: displayName, style: userStyle),
          TextSpan(text: ' did something.', style: regularStyle),
        ];
    }
    return RichText(
      text: TextSpan(children: textSpans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = _formatTimeAgo(activity.createdAt);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and Icon Column
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    backgroundImage: activity.userProfileImageUrl != null
                        ? NetworkImage(activity.userProfileImageUrl!)
                        : null,
                    child: activity.userProfileImageUrl == null
                        ? FaIcon(
                            FontAwesomeIcons.userAstronaut,
                            size: 24,
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        _getIconForActivityType(activity.type),
                        size: 14,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              // Text Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActivityText(context, theme),
                    const SizedBox(height: 4),
                    Text(
                      timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
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

  // Helper to format the timestamp into a "time ago" string
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
