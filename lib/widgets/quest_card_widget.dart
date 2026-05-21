import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quest_model.dart';
import '../utils/app_colors.dart';
import '../utils/icon_mapper.dart';

class QuestCardWidget extends StatelessWidget {
  final Quest quest;
  final VoidCallback onTap;
  final bool isLoading;

  const QuestCardWidget({
    super.key,
    required this.quest,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool onCooldown = quest.isOnCooldown;
    final bool isCompleted = quest.status == 'completed' && !onCooldown;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCompleted 
                    ? AppColors.success.withOpacity(0.3) 
                    : Colors.white.withOpacity(0.08),
              ),
            ),
            child: InkWell(
              onTap: (onCooldown || isLoading) ? null : onTap,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _buildIcon(onCooldown, isCompleted),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quest.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: onCooldown ? Colors.white38 : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "+${quest.xpReward} XP",
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusTrailing(onCooldown, isCompleted),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }

  Widget _buildIcon(bool onCooldown, bool isCompleted) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: onCooldown ? Colors.white10 : AppColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: FaIcon(
          getIconFromName(quest.type.toString().split('.').last),
          color: onCooldown ? Colors.white24 : AppColors.gold,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildStatusTrailing(bool onCooldown, bool isCompleted) {
    if (isLoading) {
      return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (onCooldown) {
      return const FaIcon(FontAwesomeIcons.clock, size: 16, color: Colors.white24);
    }
    if (isCompleted) {
      return const FaIcon(FontAwesomeIcons.circleCheck, size: 20, color: AppColors.success);
    }
    return const FaIcon(FontAwesomeIcons.chevronRight, size: 14, color: Colors.white38);
  }
}
