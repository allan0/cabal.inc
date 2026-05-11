// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/user_profile_model.dart';
import '../../services/supabase_service.dart';
import '../../services/ton_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/diamond_mesh_background.dart';
import '../../widgets/shimmer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _supabaseService.getCurrentUser();
    if (user == null) return;

    setState(() => _isLoading = true);
    final profile = await _supabaseService.getUserProfile(user.id);
    
    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    await _supabaseService.signOutUser();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address copied to clipboard"), backgroundColor: AppColors.info),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tonService = Provider.of<TonService>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("MY IDENTITY"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket, size: 18, color: Colors.redAccent),
            onPressed: _handleLogout,
            tooltip: "Logout",
          )
        ],
      ),
      body: DiamondMeshBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
              child: Column(
                children: [
                  // --- 1. AVATAR & NAME ---
                  _buildProfileHeader(),
                  const SizedBox(height: 32),

                  // --- 2. PROGRESS & STATS ---
                  _buildStatsCard(),
                  const SizedBox(height: 24),

                  // --- 3. TON WALLET CONNECTION ---
                  _buildWalletSection(tonService),
                  const SizedBox(height: 24),

                  // --- 4. ADDITIONAL CONNECTIONS ---
                  _buildSocialsSection(),
                  
                  const SizedBox(height: 40),
                  Text(
                    "VERSION 1.0.0-BETA",
                    style: TextStyle(color: AppColors.greyText.withOpacity(0.5), fontSize: 10, letterSpacing: 2),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 2),
            boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.2), blurRadius: 20)],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.darkGrey,
            backgroundImage: _profile?.profileImageUrl != null 
                ? NetworkImage(_profile!.profileImageUrl!) 
                : null,
            child: _profile?.profileImageUrl == null 
                ? const FaIcon(FontAwesomeIcons.userAstronaut, size: 40, color: AppColors.gold) 
                : null,
          ),
        ).animate().fadeIn(duration: 600.ms).scale(),
        const SizedBox(height: 16),
        Text(
          _profile?.displayName?.toUpperCase() ?? "UNKNOWN EXPLORER",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        if (_profile?.telegramUsername != null)
          Text(
            "@${_profile!.telegramUsername}",
            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }

  Widget _buildStatsCard() {
    final numberFormat = NumberFormat.compact();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("LEVEL", _profile?.level.toString() ?? "1"),
              _buildStatDivider(),
              _buildStatItem("TOTAL XP", numberFormat.format(_profile?.totalXp ?? 0)),
              _buildStatDivider(),
              _buildStatItem("QUESTS", _profile?.joinedCabalIds.length.toString() ?? "0"),
            ],
          ),
          const SizedBox(height: 20),
          _buildLevelProgressBar(),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.greyText, fontSize: 10, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30, width: 1, color: Colors.white10);
  }

  Widget _buildLevelProgressBar() {
    // Current leveling logic: floor(sqrt(xp / 100)) + 1
    // Progress is based on the remainder of the square
    double progress = (_profile!.totalXp % 100) / 100.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.white.withOpacity(0.05),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
      ),
    );
  }

  Widget _buildWalletSection(TonService ton) {
    final bool isConnected = ton.isConnected;
    final String address = ton.currentAddress ?? "NOT CONNECTED";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkGrey, Colors.black.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isConnected ? AppColors.gold.withOpacity(0.3) : Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.gem, color: AppColors.gold, size: 18),
              const SizedBox(width: 12),
              const Text("TON BLOCKCHAIN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              const Spacer(),
              if (isConnected)
                const Icon(Icons.verified, color: AppColors.success, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isConnected ? "CONNECTED ADDRESS" : "WALLET STATUS",
            style: const TextStyle(color: AppColors.greyText, fontSize: 10),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: isConnected ? () => _copyToClipboard(address) : null,
            child: Text(
              isConnected 
                  ? "${address.substring(0, 12)}...${address.substring(address.length - 8)}" 
                  : "No wallet linked to this profile.",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: isConnected ? Colors.white : Colors.white38,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                if (isConnected) {
                  await ton.disconnect();
                } else {
                  await ton.connectWallet();
                }
                _loadProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected ? Colors.white10 : AppColors.gold,
                foregroundColor: isConnected ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isConnected ? "DISCONNECT WALLET" : "CONNECT TON WALLET",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildSocialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text("CONNECTIONS", style: TextStyle(fontSize: 10, letterSpacing: 2, color: AppColors.greyText)),
        ),
        _buildSocialTile(FontAwesomeIcons.twitter, "X (Twitter)", _profile?.twitterHandle ?? "Not Linked"),
        const SizedBox(height: 8),
        _buildSocialTile(FontAwesomeIcons.discord, "Discord", "Not Linked"),
      ],
    ).animate(delay: 400.ms).fadeIn();
  }

  Widget _buildSocialTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 16, color: Colors.white54),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
