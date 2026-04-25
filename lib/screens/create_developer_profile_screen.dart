// lib/screens/create_developer_profile_screen.dart
import 'package:cabal/models/marketplace_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_particle_background.dart';
import '../utils/app_colors.dart';

class CreateDeveloperProfileScreen extends StatefulWidget {
  final DeveloperProfile? existingProfile;

  const CreateDeveloperProfileScreen({Key? key, this.existingProfile}) : super(key: key);

  @override
  State<CreateDeveloperProfileScreen> createState() => _CreateDeveloperProfileScreenState();
}

class _CreateDeveloperProfileScreenState extends State<CreateDeveloperProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();

  late TextEditingController _taglineController;
  late TextEditingController _rateController;
  late TextEditingController _skillController;
  late List<String> _skills;
  late bool _isAvailable;

  bool get _isEditing => widget.existingProfile != null;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.existingProfile;
    _taglineController = TextEditingController(text: profile?.tagline ?? '');
    _rateController = TextEditingController(text: profile?.rate ?? '');
    _skillController = TextEditingController();
    _skills = profile?.skills != null ? List.from(profile!.skills) : [];
    _isAvailable = profile?.isAvailable ?? true;
  }
  
  void _addSkill() {
    if (_skillController.text.trim().isNotEmpty && !_skills.contains(_skillController.text.trim())) {
      setState(() {
        _skills.add(_skillController.text.trim());
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isSaving = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (_isEditing) {
        // Update existing profile
        await _supabaseService.updateDeveloperProfile(
          tagline: _taglineController.text.trim(),
          rate: _rateController.text.trim(),
          skills: _skills,
          isAvailable: _isAvailable,
        );
      } else {
        // Create new profile
        await _supabaseService.createDeveloperProfile(
          tagline: _taglineController.text.trim(),
          rate: _rateController.text.trim(),
          skills: _skills,
        );
      }
      
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Developer profile ${_isEditing ? 'updated' : 'published'} successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop(true);
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
    _taglineController.dispose();
    _rateController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Developer Profile' : 'Create Developer Profile'),
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
                    bottom: 100,
                  ),
                  children: [
                    Text(
                      _isEditing ? "Update Your Profile" : "Showcase Your Skills",
                      style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isEditing ? "Keep your services and skills up-to-date." : "Create your public profile to get hired by projects in the Cabal ecosystem.",
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _taglineController,
                      decoration: const InputDecoration(labelText: 'Your Tagline * (e.g., Senior Solidity Auditor)'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'A tagline is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _rateController,
                      decoration: const InputDecoration(labelText: 'Hourly Rate (e.g., \$150/hr or Project-based)'),
                    ),
                    const SizedBox(height: 24),
                    Text("Your Core Skills", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _buildSkillInput(theme),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _skills
                          .map((skill) => Chip(
                                label: Text(skill),
                                onDeleted: () => _removeSkill(skill),
                                deleteIcon: const Icon(Icons.close, size: 16),
                              ))
                          .toList(),
                    ).animate().fadeIn(),
                     const SizedBox(height: 24),
                    SwitchListTile(
                      title: Text("Available for new work", style: theme.textTheme.titleMedium),
                      value: _isAvailable,
                      onChanged: (val) => setState(() => _isAvailable = val),
                      secondary: FaIcon(_isAvailable ? FontAwesomeIcons.solidCircleCheck : FontAwesomeIcons.solidCircleXmark, color: _isAvailable ? AppColors.success : AppColors.error),
                    )
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
          icon: Icon(_isEditing ? Icons.save_alt_rounded : Icons.rocket_launch_rounded),
          label: Text(_isEditing ? 'Save Changes' : 'Publish Profile'),
          onPressed: _isSaving ? null : _submitProfile,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillInput(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _skillController,
            decoration: const InputDecoration(labelText: 'Add a Skill (e.g., Flutter)'),
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
