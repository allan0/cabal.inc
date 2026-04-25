// lib/widgets/user_profile_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../models/user_profile_model.dart';
import '../models/achievement_model.dart';
import '../services/supabase_service.dart';
import '../utils/icon_mapper.dart';
import '../utils/leveling.dart';
import '../utils/app_colors.dart';
import 'shimmer_widget.dart';

class UserProfileWidget extends StatefulWidget {
  final UserProfile userProfile;
  final Color? backgroundColor;
  final Color? textColor;

  const UserProfileWidget({
    Key? key,
    required this.userProfile,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Achievement> _earnedAchievements = [];
  bool _isLoadingAchievements = true;
  final NumberFormat xpFormatter = NumberFormat.compact();

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  @override
  void didUpdateWidget(covariant UserProfileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userProfile.id != oldWidget.userProfile.id || !const ListEquality().equals(widget.userProfile.earnedAchievementIds, oldWidget.userProfile.earnedAchievementIds)) {
      _loadAchievements();
    }
  }

  Future<void> _loadAchievements() async {
    if (!mounted) return;
    setState(() => _isLoadingAchievements = true);

    if (widget.userProfile.earnedAchievementIds.isEmpty) {
      if (mounted) setState(() => _isLoadingAchievements = false);
      return;
    }
    try {
      final achievements = await _supabaseService.getAchievementsByIds(widget.userProfile.earnedAchievementIds);
      if (mounted) {
        setState(() {
          _earnedAchievements = achievements;
          _isLoadingAchievements = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading achievements: $e");
      if (mounted) setState(() => _isLoadingAchievements = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = widget.backgroundColor ?? theme.cardTheme.color ?? theme.cardColor;
    final txtColor = widget.textColor ?? (isDark ? Colors.white : Colors.black);
    final txtSecColor = widget.textColor?.withOpacity(0.7) ?? theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white70 : Colors.black54);
    final accentColor = theme.colorScheme.secondary;

    int xpForNext = xpForLevel(widget.userProfile.level + 1);
    int xpForCurrent = xpForLevel(widget.userProfile.level);
    double progressPercentage = (widget.userProfile.totalXp - xpForCurrent).toDouble() / (xpForNext - xpForCurrent).toDouble();
    if (progressPercentage.isNaN || progressPercentage.isInfinite) {
      progressPercentage = 1.0;
    }

    return Card(
      elevation: 4,
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: widget.userProfile.profileImageUrl != null ? NetworkImage(widget.userProfile.profileImageUrl!) : null,
                  child: widget.userProfile.profileImageUrl == null ? FaIcon(FontAwesomeIcons.userAstronaut, size: 30, color: txtSecColor) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userProfile.displayName ?? 'User',
                        style: theme.textTheme.titleLarge?.copyWith(color: txtColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Level ${widget.userProfile.level}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: txtSecColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${xpFormatter.format(widget.userProfile.totalXp)} XP / ${xpForNext == 999999999 ? "MAX" : xpFormatter.format(xpForNext)} XP ${xpForNext == 999999999 ? "" : "to Level ${widget.userProfile.level + 1}"}',
              style: theme.textTheme.bodyMedium?.copyWith(color: txtColor.withOpacity(0.85)),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: accentColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const Divider(height: 32),
            _isLoadingAchievements
              ? const ShimmerWidget.rectangular(height: 30)
              : _earnedAchievements.isEmpty
                ? Center(child: Text("No achievements yet.", style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)))
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _earnedAchievements.map((ach) => Tooltip(
                      message: ach.description,
                      child: Chip(
                        avatar: FaIcon(getIconFromName(ach.iconName), size: 16, color: accentColor.withOpacity(0.9)),
                        label: Text(ach.title, style: theme.chipTheme.labelStyle),
                        backgroundColor: theme.chipTheme.backgroundColor,
                      ),
                    )).toList(),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip(context, icon: FontAwesomeIcons.users, count: widget.userProfile.followersUserIds.length, label: "Followers", accentColor: accentColor),
                _buildStatChip(context, icon: FontAwesomeIcons.userCheck, count: widget.userProfile.followingUserIds.length, label: "Following", accentColor: accentColor),
                _buildStatChip(context, icon: FontAwesomeIcons.rightToBracket, count: widget.userProfile.joinedCabalIds.length, label: "Cabals", accentColor: accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, {required IconData icon, required int count, required String label, required Color accentColor}) {
    final theme = Theme.of(context);
    return Chip(
      avatar: FaIcon(icon, size: 14, color: accentColor),
      label: Text('$count $label', style: theme.chipTheme.labelStyle?.copyWith(color: accentColor, fontSize: 13)),
      backgroundColor: accentColor.withOpacity(0.12),
      padding: theme.chipTheme.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
