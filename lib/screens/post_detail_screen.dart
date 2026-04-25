// lib/screens/post_detail_screen.dart
import 'package:cabal/models/community_post_model.dart';
import 'package:cabal/services/supabase_service.dart';
import 'package:cabal/widgets/post_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user_profile_model.dart';
import '../widgets/animated_particle_background.dart';

class PostDetailScreen extends StatefulWidget {
  final CommunityPost post;
  final UserProfile? currentUserProfile;

  const PostDetailScreen({
    Key? key,
    required this.post,
    this.currentUserProfile,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _commentController = TextEditingController();
  List<CommunityPost> _comments = []; // We can reuse the CommunityPost model for simple comments
  bool _isLoadingComments = true;
  bool _isPostingComment = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    if (!mounted) return;
    setState(() => _isLoadingComments = true);
    try {
      final comments = await _supabaseService.getPostComments(widget.post.id);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoadingComments = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching comments: $e");
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty || _isPostingComment) return;

    setState(() => _isPostingComment = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _supabaseService.addCommentToPost(
        postId: widget.post.id,
        content: _commentController.text.trim(),
      );
      _commentController.clear();
      // Optimistically update comment count on the original post
      widget.post.commentCount++;
      await _fetchComments(); // Refresh the comment list
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Failed to post comment: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isPostingComment = false);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Details"),
      ),
      body: AnimatedParticleBackground(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PostCardWidget(
                        post: widget.post,
                        currentUserProfile: widget.currentUserProfile,
                        isDetailView: true, // Prevents navigating to detail from detail screen
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text("Comments", style: theme.textTheme.titleLarge),
                    ),
                  ),
                  if (_isLoadingComments)
                    const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                  else if (_comments.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.solidCommentDots, size: 40, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                              const SizedBox(height: 16),
                              Text("No comments yet.", style: theme.textTheme.bodyLarge),
                              Text("Be the first to reply!", style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final comment = _comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: comment.authorAvatarUrl.isNotEmpty
                                  ? NetworkImage(comment.authorAvatarUrl)
                                  : null,
                              child: comment.authorAvatarUrl.isEmpty ? const FaIcon(FontAwesomeIcons.userAstronaut) : null,
                            ),
                            title: Text(comment.authorName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            subtitle: Text(comment.content),
                            trailing: Text(comment.timeAgo, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                          );
                        },
                        childCount: _comments.length,
                      ),
                    ),
                ],
              ),
            ),
            if (widget.currentUserProfile != null)
              _buildCommentInputField(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInputField(ThemeData theme) {
    return Material(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 12),
        color: theme.cardColor,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: "Add a comment...",
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: _isPostingComment
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send_rounded),
              onPressed: _postComment,
              color: theme.colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}
