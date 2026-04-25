// lib/models/community_post_model.dart
import 'package:intl/intl.dart';

enum PostType { standard, poll, link }

class PollOption {
  final String id;
  final String text;
  int votes;

  PollOption({required this.id, required this.text, this.votes = 0});
}

class CommunityPost {
  final String id;
  final String userId;
  final String cabalId;
  final String content;
  final PostType type;
  int likes;
  final DateTime createdAt;
  
  // Joined data
  final String authorName;
  final String authorAvatarUrl;
  int commentCount;
  bool isLikedByUser;

  // Optional fields for specific post types
  final List<PollOption>? pollOptions;
  final String? linkImageUrl;
  final String? linkTitle;
  final String? linkSource;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.cabalId,
    required this.content,
    this.type = PostType.standard,
    required this.likes,
    required this.createdAt,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.commentCount,
    required this.isLikedByUser,
    this.pollOptions,
    this.linkImageUrl,
    this.linkTitle,
    this.linkSource,
  });

  factory CommunityPost.fromSupabase(Map<String, dynamic> data) {
    // This factory now handles the flat structure from the RPC call
    return CommunityPost(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      cabalId: data['cabal_id'] as String,
      content: data['content'] as String,
      likes: (data['likes'] ?? 0) as int,
      createdAt: DateTime.parse(data['created_at'] as String),
      authorName: data['author_name'] as String? ?? 'Anonymous',
      authorAvatarUrl: data['author_avatar_url'] as String? ?? '',
      commentCount: (data['comment_count'] ?? 0) as int,
      isLikedByUser: (data['is_liked_by_user'] ?? false) as bool,
      // You can add logic here to parse poll options etc. from a JSONB column if you add one
    );
  }

  // Helper method for optimistic UI updates on like
  void updateFromToggleLike(Map<String, dynamic> likeData) {
    isLikedByUser = likeData['is_liked'] as bool? ?? isLikedByUser;
    likes = likeData['new_like_count'] as int? ?? likes;
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return DateFormat('MMM d').format(createdAt);
    }
  }
}
