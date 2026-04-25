// lib/screens/manage_cabal_screen.dart
import 'package:cabal/models/cabal_model.dart';
import '../models/quest_model.dart';
import '../models/quest_section_model.dart';
import 'package:cabal/screens/create_quest_screen.dart';
import 'package:cabal/screens/edit_cabal_screen.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/quest_section_dialog.dart';
import 'package:cabal/widgets/reorderable_quest_section_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../widgets/diamond_mesh_background.dart';
import '../utils/app_colors.dart';

class ManageCabalScreen extends StatefulWidget {
  final Cabal cabal;
  const ManageCabalScreen({Key? key, required this.cabal}) : super(key: key);

  @override
  State<ManageCabalScreen> createState() => _ManageCabalScreenState();
}

class _ManageCabalScreenState extends State<ManageCabalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabaseService = SupabaseService();

  List<QuestSection> _questSections = [];
  Map<String, List<Quest>> _questsBySection = {};
  bool _isLoadingQuests = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadQuestData();
  }

  Future<void> _loadQuestData() async {
    if (!mounted) return;
    setState(() => _isLoadingQuests = true);
    try {
      final sections = await _supabaseService.getQuestSectionsForCabal(widget.cabal.id);
      final quests = await _supabaseService.getQuestsForCabal(widget.cabal.id);
      
      final questsMap = <String, List<Quest>>{};
      // --- FIX: Correctly group quests by their section ID ---
      for (var quest in quests) {
        if (quest.quest_section_id != null) {
           questsMap.putIfAbsent(quest.quest_section_id!, () => []).add(quest);
        }
      }

      if (mounted) {
        setState(() {
          _questSections = sections..sort((a, b) => a.order.compareTo(b.order));
          _questsBySection = questsMap;
          _isLoadingQuests = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading quest data for management: $e");
      if (mounted) setState(() => _isLoadingQuests = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _addSection() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const QuestSectionDialog(),
    );

    if (result != null && mounted) {
      try {
        final newSection = await _supabaseService.createQuestSection(
          widget.cabal.id,
          result['title']!,
          _questSections.length,
          description: result['description'],
        );
        setState(() {
          _questSections.add(newSection);
        });
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error creating section: $e")));
      }
    }
  }

  Future<void> _editSection(QuestSection section) async {
     final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => QuestSectionDialog(section: section),
    );

    if (result != null && mounted) {
      try {
        final updatedSection = await _supabaseService.updateQuestSection(section.id, result);
        setState(() {
          final index = _questSections.indexWhere((s) => s.id == section.id);
          if (index != -1) {
            _questSections[index] = updatedSection;
          }
        });
      } catch (e) {
         if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating section: $e")));
      }
    }
  }

  Future<void> _deleteSection(QuestSection section) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Section?'),
        content: Text('Are you sure you want to delete "${section.title}" and all quests within it? This cannot be undone.'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop(false)),
          TextButton(child: const Text('Delete'), style: TextButton.styleFrom(foregroundColor: Colors.red), onPressed: () => Navigator.of(context).pop(true)),
        ],
      )
    );

    if (confirm != true || !mounted) return;
    
    try {
      await _supabaseService.deleteQuestSection(section.id);
      setState(() {
        _questSections.removeWhere((s) => s.id == section.id);
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting section: $e")));
    }
  }

  Future<void> _deleteCabal() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('⚠️ Delete "${widget.cabal.name}"?'),
        content: const Text('This action is permanent and cannot be undone. All associated quests, sections, and user progress will be lost.'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop(false)),
          ElevatedButton(
            child: const Text('Delete Permanently'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true)
          ),
        ],
      )
    );

    if (confirm != true || !mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await _supabaseService.deleteCabal(widget.cabal.id);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Cabal "${widget.cabal.name}" has been deleted.'), backgroundColor: AppColors.success),
      );
      navigator.pop();
      navigator.pop(true);
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error deleting cabal: $e"), backgroundColor: Colors.red));
    }
  }

  void _reorderSections(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final section = _questSections.removeAt(oldIndex);
      _questSections.insert(newIndex, section);

      for (int i = 0; i < _questSections.length; i++) {
        if (_questSections[i].order != i) {
          _questSections[i].order = i;
          _supabaseService.updateQuestSection(_questSections[i].id, {'order': i});
        }
      }
    });
  }
  
  Future<void> _navigateAndReload(Widget screen) async {
    final result = await Navigator.push(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: screen),
    );

    if (result == true && mounted) {
      _loadQuestData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Manage "${widget.cabal.name}"', overflow: TextOverflow.ellipsis),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.circleInfo), text: 'Details'),
            Tab(icon: FaIcon(FontAwesomeIcons.listCheck), text: 'Quests'),
            Tab(icon: FaIcon(FontAwesomeIcons.userCheck), text: 'Submissions'),
          ],
        ),
      ),
      body: DiamondMeshBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + (AppBar().preferredSize.height) + MediaQuery.of(context).padding.top),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(context),
              _buildQuestsTab(context),
              _buildSubmissionsTab(context),
            ],
          ),
        ),
      ),
      floatingActionButton: _tabController.index == 1 
        ? FloatingActionButton.extended(
            onPressed: _addSection,
            label: const Text('Add Section'),
            icon: const Icon(Icons.add),
          )
        : null,
    );
  }

  Widget _buildQuestsTab(BuildContext context) {
    if (_isLoadingQuests) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_questSections.isEmpty) {
       return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No quest sections created yet."),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addSection,
              child: const Text('Create Your First Section'),
            )
          ],
        ),
      );
    }

    return ReorderableListView(
      padding: const EdgeInsets.all(16.0),
      onReorder: _reorderSections,
      children: _questSections.map((section) {
        return ReorderableQuestSectionCard(
          key: ValueKey(section.id),
          section: section,
          questCount: _questsBySection[section.id]?.length ?? 0,
          onEdit: () => _editSection(section),
          onDelete: () => _deleteSection(section),
          onAddQuest: () {
            _navigateAndReload(
              CreateQuestScreen(
                cabalId: widget.cabal.id,
                sectionId: section.id,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.gears, size: 40),
                const SizedBox(height: 16),
                Text('Cabal Settings', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text('Update your cabal\'s name, description, category, and privacy settings.', textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Cabal Details'),
                  onPressed: () {
                    _navigateAndReload(EditCabalScreen(cabal: widget.cabal));
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          color: theme.colorScheme.error.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danger Zone',
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Deleting your cabal is irreversible and will remove all associated data. Please be certain.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error.withOpacity(0.9)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('Delete This Cabal'),
                    onPressed: _deleteCabal,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionsTab(BuildContext context) {
     return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.inbox, size: 40),
              const SizedBox(height: 16),
              Text('Review Submissions', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text('Users\' submissions for manual verification quests will appear here for you to approve or reject. (Coming Soon)', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
