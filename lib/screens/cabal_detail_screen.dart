import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/cabal_model.dart';
import '../models/quest_model.dart';
import '../services/supabase_service.dart';
import '../utils/app_colors.dart';
import '../widgets/quest_card_widget.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/quest_complete_celebration.dart';

class CabalDetailScreen extends StatefulWidget {
  final String cabalId;
  const CabalDetailScreen({super.key, required this.cabalId});

  @override
  State<CabalDetailScreen> createState() => _CabalDetailScreenState();
}

class _CabalDetailScreenState extends State<CabalDetailScreen> {
  bool _isLoading = true;
  Cabal? _cabal;
  List<Quest> _quests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final supabase = context.read<SupabaseService>();
    final results = await Future.wait([
      supabase.getCabal(widget.cabalId),
      supabase.getQuestsForCabal(widget.cabalId),
    ]);

    setState(() {
      _cabal = results[0] as Cabal?;
      _quests = results[1] as List<Quest>;
      _isLoading = false;
    });
  }

  Future<void> _handleQuestCompletion(Quest quest) async {
    final supabase = context.read<SupabaseService>();
    final result = await supabase.completeQuest(quest.id);

    if (result['success'] == true) {
      if (mounted) showQuestCompleteCelebration(context);
      _loadData(); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_cabal == null) return const Scaffold(body: Center(child: Text("Cabal Not Found")));

    return Scaffold(
      body: DiamondMeshBackground(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.background,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  _cabal!.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontSize: 16,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_cabal!.bannerImageUrl != null)
                      Image.network(_cabal!.bannerImageUrl!, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withOpacity(0.8),
                            AppColors.background,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              Text(
                "MISSIONS",
                style: TextStyle(
                  color: AppColors.gold.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  fontSize: 12,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 16),
              ..._quests.map((quest) => QuestCardWidget(
                quest: quest,
                onTap: () => _handleQuestCompletion(quest),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
