// lib/screens/create_project_listing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

class CreateProjectListingScreen extends StatefulWidget {
  const CreateProjectListingScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectListingScreen> createState() => _CreateProjectListingScreenState();
}

class _CreateProjectListingScreenState extends State<CreateProjectListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();

  // Form fields
  String _projectName = '';
  String _projectDescription = '';
  String _budget = '';
  String _timeline = '';
  final List<String> _requiredSkills = [];
  bool _isFullProject = false;

  final TextEditingController _skillController = TextEditingController();
  bool _isSaving = false;

  void _addSkill() {
    if (_skillController.text.trim().isNotEmpty && !_requiredSkills.contains(_skillController.text.trim())) {
      setState(() {
        _requiredSkills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _requiredSkills.remove(skill);
    });
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.'), backgroundColor: AppColors.warning),
      );
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isSaving = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final newListing = await _supabaseService.createProjectListing(
        projectName: _projectName,
        projectDescription: _projectDescription,
        budget: _budget,
        timeline: _timeline,
        requiredSkills: _requiredSkills,
        isFullProject: _isFullProject,
      );

      if (newListing != null && mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Project listing posted successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop(true); // Pop with 'true' to indicate success
      } else {
        throw Exception("Failed to create listing.");
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project Listing'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isSaving,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    bottom: 100, // Space for the save button
                  ),
                  children: [
                    _buildSectionHeader(theme, "Project Details"),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Project Name *'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Project name is required' : null,
                      onSaved: (v) => _projectName = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Project Description *',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (v) => (v == null || v.trim().length < 20) ? 'Please provide a detailed description (min 20 chars)' : null,
                      onSaved: (v) => _projectDescription = v!,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(theme, "Logistics"),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Budget (e.g., \$5k - \$10k USD)', hintText: 'Be as specific as you can'),
                      onSaved: (v) => _budget = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Estimated Timeline (e.g., 4-6 Weeks)'),
                      onSaved: (v) => _timeline = v!,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(theme, "Required Skills"),
                    _buildSkillInput(theme),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _requiredSkills
                          .map((skill) => Chip(
                                label: Text(skill),
                                onDeleted: () => _removeSkill(skill),
                                deleteIcon: const Icon(Icons.close, size: 16),
                              ))
                          .toList(),
                    ).animate().fadeIn(),
                    const SizedBox(height: 24),
                    SwitchListTile(
                      title: Text("This is a full project", style: theme.textTheme.titleMedium),
                      subtitle: Text(_isFullProject ? "Seeking a team or agency" : "Seeking individual contributors"),
                      value: _isFullProject,
                      onChanged: (val) => setState(() => _isFullProject = val),
                      secondary: FaIcon(_isFullProject ? FontAwesomeIcons.users : FontAwesomeIcons.user, color: theme.colorScheme.secondary),
                    ),
                  ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.1),
                ),
              ),
              if (_isSaving)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        width: double.infinity,
        color: theme.cardColor,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.publish_rounded),
          label: const Text('Post Listing'),
          onPressed: _isSaving ? null : _submitListing,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
    );
  }

  Widget _buildSkillInput(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillController,
            decoration: const InputDecoration(labelText: 'Add a Skill (e.g., Solidity)'),
            onFieldSubmitted: (_) => _addSkill(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: _addSkill,
          style: IconButton.styleFrom(backgroundColor: theme.colorScheme.secondary),
        ),
      ],
    );
  }
}
