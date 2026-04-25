// lib/screens/create_post_screen.dart
import 'package:cabal/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_particle_background.dart';

class CreatePostScreen extends StatefulWidget {
  final String cabalId;
  final String cabalName;

  const CreatePostScreen({
    Key? key,
    required this.cabalId,
    required this.cabalName,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _contentController = TextEditingController();
  UserProfile? _currentUserProfile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _contentController.addListener(() {
      if (mounted) setState(() {}); // Rebuild to update character count and button state
    });
  }

  Future<void> _loadUserProfile() async {
    final user = _supabaseService.getCurrentUser();
    if (user != null) {
      final profile = await _supabaseService.getUserProfile(user.id);
      if (mounted) {
        setState(() {
          _currentUserProfile = profile;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitPost() async {
    if (_contentController.text.trim().isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final newPost = await _supabaseService.createCommunityPost(
        cabalId: widget.cabalId,
        content: _contentController.text.trim(),
      );

      if (newPost != null && mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Your post is live!'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop(true); // Pop with 'true' to indicate success
      } else {
        throw Exception("Post creation returned null.");
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to post: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canPost = _contentController.text.trim().isNotEmpty && !_isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post to ${widget.cabalName}'),
        // <-- Post button removed from here
      ),
      body: AnimatedParticleBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: _currentUserProfile?.profileImageUrl != null
                              ? NetworkImage(_currentUserProfile!.profileImageUrl!)
                              : null,
                          child: _currentUserProfile?.profileImageUrl == null
                              ? const FaIcon(FontAwesomeIcons.userAstronaut)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUserProfile?.displayName ?? 'Anonymous',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Share your thoughts with the cabal...',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: TextField(
                        controller: _contentController,
                        autofocus: true,
                        maxLines: null,
                        maxLength: 500,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      // <-- NEW: Added a persistent bottom sheet for the post button -->
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
        width: double.infinity,
        color: theme.cardColor,
        child: ElevatedButton(
          onPressed: canPost ? _submitPost : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: _isSaving
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
              : const Text('Post'),
        ),
      ),
    );
  }
}
