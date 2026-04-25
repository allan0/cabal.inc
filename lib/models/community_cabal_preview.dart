// lib/models/community_cabal_preview.dart
import 'cabal_model.dart';

class CommunityCabalPreview {
  final Cabal cabal;
  final int memberCount;
  final int postCount;
  final String? latestPostSnippet;
  final DateTime? latestPostTimestamp;

  CommunityCabalPreview({
    required this.cabal,
    required this.memberCount,
    required this.postCount,
    this.latestPostSnippet,
    this.latestPostTimestamp,
  });

  factory CommunityCabalPreview.fromSupabase(Map<String, dynamic> data) {
    // This assumes the RPC returns a nested 'cabals' object.
    // Adjust as per your actual RPC response structure.
    final cabalData = data['cabals'] as Map<String, dynamic>?;
    if (cabalData == null) {
      throw Exception("Invalid data format for CommunityCabalPreview");
    }

    return CommunityCabalPreview(
      cabal: Cabal.fromSupabase(cabalData),
      memberCount: (data['member_count'] ?? 0) as int,
      postCount: (data['post_count'] ?? 0) as int,
      latestPostSnippet: data['latest_post_snippet'] as String?,
      latestPostTimestamp: data['latest_post_timestamp'] != null
          ? DateTime.tryParse(data['latest_post_timestamp'] as String)
          : null,
    );
  }
}
