// lib/screens/create_quest_screen.dart
import 'package:cabal/models/quest_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';
import '../widgets/animated_particle_background.dart';
import '../widgets/info_tooltip.dart';

// Enum for boilerplate task templates
enum BoilerplateTask { none, watchVideo, readArticle, twitterFollow, discordJoin }

class CreateQuestScreen extends StatefulWidget {
  final String cabalId;
  final String sectionId;
  final Quest? existingQuest;

  const CreateQuestScreen({
    Key? key,
    required this.cabalId,
    required this.sectionId,
    this.existingQuest,
  }) : super(key: key);

  @override
  State<CreateQuestScreen> createState() => _CreateQuestScreenState();
}

class _CreateQuestScreenState extends State<CreateQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();
  bool get _isEditing => widget.existingQuest != null;
  bool _isLoading = false;

  // Form field controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _xpController;
  late TextEditingController _actionUrlController;
  late TextEditingController _buttonTextController;
  late TextEditingController _cooldownController;
  
  QuestType _selectedQuestType = QuestType.custom;
  BoilerplateTask _selectedBoilerplate = BoilerplateTask.none;
  bool _requiresManualVerification = false;

  @override
  void initState() {
    super.initState();
    final quest = widget.existingQuest;
    _titleController = TextEditingController(text: quest?.title ?? '');
    _descriptionController = TextEditingController(text: quest?.description ?? '');
    _xpController = TextEditingController(text: quest?.xpReward.toString() ?? '100');
    _actionUrlController = TextEditingController(text: quest?.actionUrl ?? '');
    _buttonTextController = TextEditingController(text: quest?.taskButtonText ?? '');
    _cooldownController = TextEditingController(text: quest?.cooldownPeriod?.inSeconds.toString() ?? '');
    _selectedQuestType = quest?.type ?? QuestType.custom;
    _requiresManualVerification = quest?.requiresManualVerification ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _xpController.dispose();
    _actionUrlController.dispose();
    _buttonTextController.dispose();
    _cooldownController.dispose();
    super.dispose();
  }

  Future<void> _saveQuest() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final questData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'xp_reward': int.tryParse(_xpController.text) ?? 100,
        'type': questTypeToString(_selectedQuestType),
        'action_url': _actionUrlController.text.trim().isEmpty ? null : _actionUrlController.text.trim(),
        'task_button_text': _buttonTextController.text.trim().isEmpty ? null : _buttonTextController.text.trim(),
        'requires_manual_verification': _requiresManualVerification,
        'cooldown_period_seconds': int.tryParse(_cooldownController.text.trim()),
      };

      if (_isEditing) {
        await _supabaseService.updateQuest(widget.existingQuest!.id, questData);
      } else {
        questData['id'] = const Uuid().v4();
        await _supabaseService.createQuest(widget.cabalId, widget.sectionId, questData);
      }
      
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Quest ${_isEditing ? 'updated' : 'saved'} successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true);
      }

    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  void _onBoilerplateChanged(BoilerplateTask? task) {
    setState(() {
      _selectedBoilerplate = task ?? BoilerplateTask.none;
      switch (_selectedBoilerplate) {
        case BoilerplateTask.watchVideo:
          _titleController.text = "Watch a Video";
          _descriptionController.text = "Watch the embedded video to learn more.";
          _selectedQuestType = QuestType.custom;
          _buttonTextController.text = "Mark as Watched";
          break;
        case BoilerplateTask.readArticle:
          _titleController.text = "Read an Article";
          _descriptionController.text = "Read the linked article to understand our mission.";
          _selectedQuestType = QuestType.websiteVisit;
          _buttonTextController.text = "I Have Read It";
          break;
        case BoilerplateTask.twitterFollow:
          _titleController.text = "Follow us on X / Twitter";
          _descriptionController.text = "Follow our official account to stay updated.";
          _selectedQuestType = QuestType.twitterFollow;
          _buttonTextController.text = "Follow";
          break;
        case BoilerplateTask.discordJoin:
           _titleController.text = "Join our Discord Server";
          _descriptionController.text = "Become a part of our community on Discord.";
          _selectedQuestType = QuestType.discordJoin;
          _buttonTextController.text = "Join Server";
          break;
        case BoilerplateTask.none:
          // Do nothing, allow manual entry
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Quest' : 'Create Quest'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedParticleBackground(
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
                    left: 16, right: 16, bottom: 100
                  ),
                  children: [
                    _buildBoilerplateSelector(theme),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Quest Title *'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Short Description *', alignLabelWithHint: true),
                      maxLines: 3,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _xpController,
                            decoration: const InputDecoration(labelText: 'XP Reward *', prefixIcon: Icon(Icons.star_rounded)),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (v) => (v == null || int.tryParse(v) == null) ? 'Must be a valid number' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cooldownController,
                            decoration: const InputDecoration(
                              labelText: 'Cooldown (Seconds)',
                              prefixIcon: Icon(Icons.timer_outlined),
                              suffixIcon: InfoTooltip(message: "Time in seconds before a user can repeat this quest. Leave blank for a one-time quest.")
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildQuestTypeSelector(theme),
                    const SizedBox(height: 16),
                    if (_selectedQuestType != QuestType.custom)
                      TextFormField(
                        controller: _actionUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Action URL *',
                          hintText: 'e.g., https://twitter.com/user/status/123',
                          suffixIcon: InfoTooltip(message: 'The URL the user will be sent to (e.g., a Tweet to like, a website to visit).'),
                        ),
                        keyboardType: TextInputType.url,
                        validator: (v) => (_selectedQuestType != QuestType.custom && (v == null || v.trim().isEmpty)) ? 'URL is required for this quest type' : null,
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _buttonTextController,
                      decoration: const InputDecoration(
                        labelText: 'Task Button Text',
                        hintText: 'e.g., "Like this Tweet"',
                        suffixIcon: InfoTooltip(message: 'The text displayed on the action button. If empty, a default will be used.'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Requires Manual Verification'),
                      subtitle: const Text('Admins must approve submissions for this quest.'),
                      value: _requiresManualVerification,
                      onChanged: (val) => setState(() => _requiresManualVerification = val),
                      secondary: const FaIcon(FontAwesomeIcons.userShield),
                    ),
                  ].animate(interval: 80.ms).fadeIn().slideY(begin: 0.1),
                ),
              ),
              if (_isLoading)
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
          icon: const Icon(Icons.save),
          label: Text(_isEditing ? 'Save Changes' : 'Create Quest'),
          onPressed: _isLoading ? null : _saveQuest,
        ),
      ),
    );
  }
  
  Widget _buildBoilerplateSelector(ThemeData theme) {
    return DropdownButtonFormField<BoilerplateTask>(
      value: _selectedBoilerplate,
      decoration: const InputDecoration(
        labelText: 'Start with a Template (Optional)',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: BoilerplateTask.none, child: Text('Custom Quest')),
        DropdownMenuItem(value: BoilerplateTask.watchVideo, child: Text('Watch a Video')),
        DropdownMenuItem(value: BoilerplateTask.readArticle, child: Text('Read an Article')),
        DropdownMenuItem(value: BoilerplateTask.twitterFollow, child: Text('Twitter Follow')),
        DropdownMenuItem(value: BoilerplateTask.discordJoin, child: Text('Discord Join')),
      ],
      onChanged: _onBoilerplateChanged,
    );
  }

  Widget _buildQuestTypeSelector(ThemeData theme) {
    return DropdownButtonFormField<QuestType>(
      value: _selectedQuestType,
      decoration: const InputDecoration(
        labelText: 'Quest Type *',
        border: OutlineInputBorder(),
      ),
      items: QuestType.values.map((QuestType type) {
        return DropdownMenuItem<QuestType>(
          value: type,
          child: Text(type.toString().split('.').last),
        );
      }).toList(),
      onChanged: (QuestType? newValue) {
        setState(() {
          _selectedQuestType = newValue!;
          _selectedBoilerplate = BoilerplateTask.none; // Reset boilerplate if type is changed manually
        });
      },
    );
  }
}
