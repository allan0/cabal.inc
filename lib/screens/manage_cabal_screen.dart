import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/cabal_model.dart';
import '../models/quest_section_model.dart';
import '../services/supabase_service.dart';
import '../utils/app_colors.dart';
import '../widgets/diamond_mesh_background.dart';

class ManageCabalScreen extends StatefulWidget {
  final Cabal cabal;
  const ManageCabalScreen({super.key, required this.cabal});

  @override
  State<ManageCabalScreen> createState() => _ManageCabalScreenState();
}

class _ManageCabalScreenState extends State<ManageCabalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SupabaseService _supabase = SupabaseService();
  
  List<QuestSection> _sections = [];
  List<Map<String, dynamic>> _pendingSubmissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadManagementData();
  }

  Future<void> _loadManagementData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _supabase.getQuestSectionsForCabal(widget.cabal.id),
      _supabase.getPendingQuestSubmissions(widget.cabal.id),
    ]);

    setState(() {
      _sections = results[0] as List<QuestSection>;
      _pendingSubmissions = results[1] as List<Map<String, dynamic>>;
      _isLoading = false;
    });
  }

  Future<void> _handleReview(String submissionId, bool approve) async {
    final success = await _supabase.reviewQuestSubmission(
      submissionId: submissionId, 
      approve: approve
    );
    if (success) _loadManagementData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MANAGE ${widget.cabal.name.toUpperCase()}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          tabs: const [
            Tab(text: "QUEST SECTIONS"),
            Tab(text: "SUBMISSIONS"),
          ],
        ),
      ),
      body: DiamondMeshBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSectionsTab(),
                _buildSubmissionsTab(),
              ],
            ),
      ),
    );
  }

  Widget _buildSectionsTab() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sections.length,
      onReorder: (oldIndex, newIndex) async {
        if (oldIndex < newIndex) newIndex -= 1;
        final item = _sections.removeAt(oldIndex);
        _sections.insert(newIndex, item);
        await _supabase.updateSectionOrder(_sections);
      },
      itemBuilder: (context, index) {
        final section = _sections[index];
        return Card(
          key: ValueKey(section.id),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.drag_handle, color: AppColors.greyText),
            title: Text(section.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${section.order} • ${section.description ?? 'No description'}"),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.gold),
              onPressed: () {}, // Edit Section Logic
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmissionsTab() {
    if (_pendingSubmissions.isEmpty) {
      return const Center(child: Text("No pending reviews", style: TextStyle(color: AppColors.greyText)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingSubmissions.length,
      itemBuilder: (context, index) {
        final sub = _pendingSubmissions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: AppColors.glassDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sub['quest_title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text("User: ${sub['user_display_name']}", style: const TextStyle(color: AppColors.gold)),
              const Divider(height: 24, color: Colors.white10),
              Text(sub['proof_content'] ?? "No proof provided"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleReview(sub['id'], false),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                      child: const Text("REJECT"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleReview(sub['id'], true),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.black),
                      child: const Text("APPROVE"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
