// lib/models/cabal_leaderboard_entry.dart
import 'user_profile_model.dart';

class CabalLeaderboardEntry {
  final UserProfile userProfile;
  final int cabalXp;
  final int rank;

  CabalLeaderboardEntry({
    required this.userProfile,
    required this.cabalXp,
    required this.rank,
  });
}
