// lib/widgets/community_stats_header.dart
import 'package:cabal/models/cabal_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CommunityStatsHeader extends StatelessWidget {
  final Cabal cabal;
  final int memberCount;
  final int postCount;

  const CommunityStatsHeader({
    Key? key,
    required this.cabal,
    required this.memberCount,
    required this.postCount,
  }) : super(key: key);

  String _formatCabalAge() {
    if (cabal.createdAt == null) return "Age unknown";
    final difference = DateTime.now().difference(cabal.createdAt!);
    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()}y old";
    }
    if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()}mo old";
    }
    if (difference.inDays > 0) {
      return "${difference.inDays}d old";
    }
    return "New!";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(theme, count: memberCount, label: "Members", icon: FontAwesomeIcons.users),
            _buildStat(theme, count: postCount, label: "Posts", icon: FontAwesomeIcons.solidMessage),
            _buildStat(theme, label: _formatCabalAge(), icon: FontAwesomeIcons.solidCalendarDays, isAge: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(ThemeData theme, {int? count, required String label, required IconData icon, bool isAge = false}) {
    return Column(
      children: [
        FaIcon(icon, size: 20, color: theme.colorScheme.secondary),
        const SizedBox(height: 8),
        if (!isAge)
          Text(
            NumberFormat.compact().format(count ?? 0),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        Text(
          label,
          style: isAge 
            ? theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
