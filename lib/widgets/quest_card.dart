// lib/widgets/quest_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/quest_model.dart';
import '../services/supabase_service.dart';
import '../services/ton_service.dart';
import '../utils/app_colors.dart';
import '../utils/icon_mapper.dart';
import '../utils/constants.dart';
import 'quest_complete_celebration.dart';

class QuestCard extends StatefulWidget {
  final Quest quest;
  final VoidCallback? onComplete;

  const QuestCard({
    super.key, 
    required this.quest, 
    this.onComplete
  });

  @override
  State<QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> {
  bool _isProcessing = false;

  /// Primary handler for quest interaction based on QuestType
  Future<void> _handleQuestAction(BuildContext context) async {
    if (_isProcessing || widget.quest.isLocked) return;

    final supabase = Provider.of<SupabaseService>(context, listen: false);
    final ton = Provider.of<TonService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() => _isProcessing = true);

    try {
      bool actionVerified = false;

      // 1. Handle Blockchain/Action Specifics
      switch (widget.quest.type) {
        case QuestType.connectWalletEth: // Mapping to TON for this focus
          final address = await ton.connectWallet();
          actionVerified = address != null;
          break;
          
        case QuestType.websiteVisit:
        case QuestType.telegramChannelJoin:
          // In production, we'd check if the user actually returned from the URL
          actionVerified = true; 
          break;

        default:
          // For custom quests, we assume immediate completion or manual verification
          actionVerified = true;
      }

      if (!actionVerified) {
        setState(() => _isProcessing = false);
        return;
      }

      // 2. Handle Manual Verification Flag
      if (widget.quest.requiresManualVerification) {
        // Logic for submitting proof to public.user_quest_progress
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text("Submission sent for review!"), backgroundColor: AppColors.info),
        );
        setState(() => _isProcessing = false);
        return;
      }

      // 3. Trigger Atomic Completion in Supabase
      final result = await supabase.completeQuest(widget.quest.id);

      if (result['success'] == true) {
        // Trigger high-fidelity celebration overlay
        showQuestCompleteCelebration(context);
        
        if (widget.onComplete != null) widget.onComplete!();
      }
    } catch (e) {
      debugPrint("QuestCard Error: $e");
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Action failed: $e"), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isCompleted = widget.quest.userStatus == 'completed';
    final bool isOnCooldown = widget.quest.isOnCooldown;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted ? AppColors.success.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          if (!isCompleted)
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SIDE ACCENT ---
              Container(
                width: 6,
                color: isCompleted ? AppColors.success : AppColors.gold,
              ),

              // --- CONTENT ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FaIcon(
                              getIconFromName(widget.quest.iconName),
                              color: isCompleted ? AppColors.success : AppColors.gold,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.quest.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  "+${widget.quest.xpReward} XP",
                                  style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.quest.description,
                        style: const TextStyle(color: AppColors.greyText, fontSize: 13, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // --- PROGRESS BAR (Multi-step) ---
                      if (widget.quest.totalSteps > 1 && !isCompleted) ...[
                        const SizedBox(height: 16),
                        _buildProgressBar(),
                      ],

                      const SizedBox(height: 16),

                      // --- FOOTER ACTIONS ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.quest.statusText.toUpperCase(),
                            style: TextStyle(
                              color: isCompleted ? AppColors.success : AppColors.greyText,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          _buildActionButton(context, isCompleted, isOnCooldown),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildProgressBar() {
    double progress = widget.quest.userCurrentSteps / widget.quest.totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("PROGRESS", style: TextStyle(fontSize: 9, color: AppColors.greyText)),
            Text("${widget.quest.userCurrentSteps}/${widget.quest.totalSteps}", style: const TextStyle(fontSize: 9, color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool isCompleted, bool isOnCooldown) {
    if (isCompleted && !isOnCooldown && widget.quest.cooldown == null) {
      return const FaIcon(FontAwesomeIcons.circleCheck, color: AppColors.success, size: 24);
    }

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: (_isProcessing || widget.quest.isLocked || isOnCooldown) 
            ? null 
            : () => _handleQuestAction(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? Colors.white10 : AppColors.gold,
          foregroundColor: isCompleted ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: _isProcessing
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
            : Text(
                isOnCooldown ? "LOCKED" : (isCompleted ? "REDO" : "START"),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
