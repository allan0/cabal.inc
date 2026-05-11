// lib/screens/quest/quest_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/quest_model.dart';
import '../../services/supabase_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/icon_mapper.dart';
import '../../widgets/custom_app_bar.dart';

class QuestDetailScreen extends StatefulWidget {
  final Quest quest;
  const QuestDetailScreen({super.key, required this.quest});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  final SupabaseService _service = SupabaseService();
  bool _isCompleting = false;

  Future<void> _completeQuest() async {
    setState(() => _isCompleting = true);
    try {
      await _service.completeQuest(widget.quest.id, 'completed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("+${widget.quest.xpReward} XP Earned!"),
          backgroundColor: AppColors.success,
        ),
      );
      if (mounted) Navigator.pop(context, true); // Return success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to complete quest")),
      );
    } finally {
      setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quest = widget.quest;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "Quest Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(getIconFromName(quest.iconName), size: 80, color: AppColors.gold),
            const SizedBox(height: 16),
            Text(quest.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Reward: +${quest.xpReward} XP", style: const TextStyle(fontSize: 20, color: AppColors.gold)),

            const SizedBox(height: 24),
            const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(quest.description, style: const TextStyle(fontSize: 16, color: AppColors.lightText)),

            if (quest.detailedContent != null) ...[
              const SizedBox(height: 24),
              const Text("How to Complete", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(quest.detailedContent!, style: const TextStyle(fontSize: 16)),
            ],

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: quest.isLockedForUser || _isCompleting
                    ? null
                    : _completeQuest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isCompleting
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(quest.statusText.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
