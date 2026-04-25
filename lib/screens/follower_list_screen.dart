// lib/screens/follower_list_screen.dart
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import 'dashboard_screen.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/diamond_mesh_background.dart';

class FollowerListScreen extends StatefulWidget {
  final String userId;
  final String listType; // "Followers" or "Following"

  const FollowerListScreen({
    Key? key,
    required this.userId,
    required this.listType,
  }) : super(key: key);

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<List<UserProfile>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      if (widget.listType == "Followers") {
        _usersFuture = _supabaseService.getFollowers(widget.userId);
      } else {
        _usersFuture = Future.value([]); 
      }
    });
  }

  void _navigateToUserProfile(String userId) {
     Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        // --- THIS IS THE FIX ---
        child: DashboardScreen(
          viewProfileId: userId,
          isLoadingProfile: false, // The required parameter was missing
        ),
        // --- END OF FIX ---
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.listType),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
        elevation: 0,
      ),
      body: DiamondMeshBackground(
        child: FutureBuilder<List<UserProfile>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top, left: 8, right: 8),
                itemCount: 8,
                itemBuilder: (context, index) => const ListTile(
                  leading: ShimmerWidget.circular(width: 48, height: 48),
                  title: ShimmerWidget.rectangular(height: 16),
                  subtitle: ShimmerWidget.rectangular(height: 12),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No ${widget.listType.toLowerCase()} found."));
            }

            final users = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(user.displayName?.substring(0, 1).toUpperCase() ?? 'U')
                        : null,
                  ),
                  title: Text(user.displayName ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => _navigateToUserProfile(user.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
