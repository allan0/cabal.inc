// lib/screens/profile_edit_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:share_plus/share_plus.dart';

// Model & Service Imports
import '../models/user_profile_model.dart';
import '../services/supabase_service.dart';
import 'kol_dashboard_screen.dart';

// UI & Util Imports
import '../utils/app_colors.dart';
import '../widgets/animated_particle_background.dart';
import '../widgets/info_tooltip.dart';

// Screen Imports
import 'login_screen.dart';

// Feature Imports
import '../features/wallet/application/wallet_provider.dart';
import '../features/wallet/presentation/widgets/wallet_connector_widget.dart';

// Global Imports
import '../main.dart' show themeManager;

class ProfileEditScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileEditScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late TextEditingController _displayNameController;
  late TextEditingController _telegramUsernameController;
  late TextEditingController _twitterHandleController;
  bool _isSaving = false;
  late bool _isDarkTheme;

  Map<String, String> _connectedSocials = {};
  String? _initialProfileImageUrl;
  XFile? _pickedImageXFile;

  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.userProfile.displayName);
    _telegramUsernameController = TextEditingController(text: widget.userProfile.telegramUsername ?? '');
    _twitterHandleController = TextEditingController(text: widget.userProfile.connectedSocials['twitter'] ?? '');
    _connectedSocials = Map<String, String>.from(widget.userProfile.connectedSocials);
    _initialProfileImageUrl = widget.userProfile.profileImageUrl;
    _isDarkTheme = themeManager.themeMode == ThemeMode.dark;
  }
  
  Future<void> _pickImage() async {
    try {
      final XFile? pickedXFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxWidth: 1024,
          maxHeight: 1024);
      if (pickedXFile != null && mounted) {
        setState(() {
          _pickedImageXFile = pickedXFile;
        });
      }
    } catch (e) {
        if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error picking image: ${e.toString()}"), backgroundColor: Theme.of(context).colorScheme.error)
            );
        }
    }
  }

  Future<void> _saveProfile() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.'), backgroundColor: AppColors.warning),
      );
      return;
    }
    _formKey.currentState!.save();

    if (mounted) setState(() => _isSaving = true);

    String? newUploadedImageUrl;

    try {
      if (_pickedImageXFile != null) {
        newUploadedImageUrl = await _supabaseService.uploadProfileImage(_pickedImageXFile!, widget.userProfile.id);
        if (newUploadedImageUrl == null || newUploadedImageUrl.isEmpty) {
          throw Exception("Image upload failed or did not return a valid URL.");
        }
      }

      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      Map<String, String> walletsToSaveInProfile = {};

      if (walletProvider.isConnectedEVM && walletProvider.connectedEVMAddress != null) {
        walletsToSaveInProfile['evm'] = walletProvider.connectedEVMAddress!;
      }
      if (walletProvider.isConnectedSolana && walletProvider.connectedSolanaAddress != null) {
        walletsToSaveInProfile['solana'] = walletProvider.connectedSolanaAddress!;
      }

      _connectedSocials['twitter'] = _twitterHandleController.text.trim();

      Map<String, dynamic> updateData = {
        'display_name': _displayNameController.text.trim(),
        'telegram_username': _telegramUsernameController.text.trim().isEmpty ? null : _telegramUsernameController.text.trim(),
        'connected_wallets': walletsToSaveInProfile,
        'connected_socials': _connectedSocials,
        'twitter_handle': _twitterHandleController.text.trim().isEmpty ? null : _twitterHandleController.text.trim(),
        'is_twitter_verified': widget.userProfile.is_twitter_verified,
      };

      if (newUploadedImageUrl != null) {
        updateData['profile_image_url'] = newUploadedImageUrl;
      } else {
        updateData['profile_image_url'] = _initialProfileImageUrl;
      }

      await _supabaseService.updateUserProfile(updateData);

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString().split(':').last.trim()}'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _logout() async {
    if (!mounted) return;
    if (mounted) setState(() => _isSaving = true);

    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    try {
      if (walletProvider.isConnectedEVM) await walletProvider.disconnectEVMWallet();
      if (walletProvider.isConnectedSolana) await walletProvider.disconnectSolanaWallet();
    } catch (e) {
      debugPrint("Error disconnecting wallets during logout: $e");
    }

    await _supabaseService.signOutUser();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: const LoginScreen(fromLogout: true)),
        (Route<dynamic> route) => false,
      );
    }
  }
  
  Future<void> _handleDeleteAccount() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Delete Account?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is permanent and cannot be undone. All your data, quests, and profile information will be deleted.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: 'Type "DELETE" to confirm',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text('Cancel'),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: confirmController,
            builder: (context, value, child) {
              return TextButton(
                onPressed: value.text == 'DELETE'
                    ? () => navigator.pop(true)
                    : null,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete Permanently'),
              );
            },
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isSaving = true);
      try {
        await _supabaseService.deleteCurrentUserAccount();
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Account deleted successfully.')),
        );
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen(fromLogout: true)),
          (route) => false,
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error deleting account: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }
  
  Future<void> _simulateNewsNotification() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (widget.userProfile.preferredCoinIds.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Add some favorite coins in onboarding to test this feature!'), backgroundColor: AppColors.warning),
      );
      return;
    }

    final favoriteCoin = widget.userProfile.preferredCoinIds.first;
    final coinName = favoriteCoin.toUpperCase();

    try {
      await _supabaseService.createNotification(
        userId: widget.userProfile.id,
        title: '📈 News Update for $coinName',
        body: '$coinName just announced a new partnership with a major tech firm, causing a surge in market activity.',
        type: 'news_update',
        referenceId: favoriteCoin,
      );
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Simulated news notification created! Check your notifications.'), backgroundColor: AppColors.info),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to create notification: $e'), backgroundColor: Colors.red),
      );
    }
  }
  
  @override
  void dispose() {
    _displayNameController.dispose();
    _telegramUsernameController.dispose();
    _twitterHandleController.dispose();
    super.dispose();
  }
  
  Widget _buildReferralCard(ThemeData theme) {
    final bool canRefer =
        (widget.userProfile.displayName != null && widget.userProfile.displayName!.isNotEmpty) &&
        (widget.userProfile.profileImageUrl != null && widget.userProfile.profileImageUrl!.isNotEmpty);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Referral Code", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (canRefer) ...[
              SelectableText(
                widget.userProfile.referralCode ?? 'Generating...',
                style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final referralLink = "https://cabal-001.web.app/join?ref=${widget.userProfile.referralCode}";
                    Share.share('Join me on Cabal! Use my referral link to get started: $referralLink');
                  },
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text("Share Your Link"),
                ),
              ),
              const SizedBox(height: 8),
               SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                     Navigator.push(
                       context,
                       PageTransition(
                         type: PageTransitionType.rightToLeft,
                         child: KolDashboardScreen(userProfile: widget.userProfile),
                       ),
                     );
                  },
                  icon: const FaIcon(FontAwesomeIcons.chartSimple, size: 16),
                  label: const Text("View Your Referral Metrics"),
                ),
              ),
            ] else ...[
              Text(
                "Please set a display name and upload a profile picture to activate your referral code.",
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTwitterVerificationCard(ThemeData theme) {
    bool isVerified = widget.userProfile.is_twitter_verified ?? false;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("X / Twitter Verification", style: theme.textTheme.titleMedium),
                const Spacer(),
                if (isVerified)
                  Chip(
                    avatar: const FaIcon(FontAwesomeIcons.solidCircleCheck, size: 14, color: AppColors.success),
                    label: const Text("Verified"),
                    backgroundColor: AppColors.success.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  )
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _twitterHandleController,
              decoration: InputDecoration(
                labelText: 'Your Twitter Handle',
                prefixText: _twitterHandleController.text.isNotEmpty && !_twitterHandleController.text.startsWith('@') ? '@' : null,
                hintText: "your_handle",
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(
              "Connect your X account to get a verified badge on your profile and unlock exclusive quests.",
              style: theme.textTheme.bodySmall,
            ),
             if (!isVerified) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Twitter verification flow coming soon!")));
                  },
                  icon: const FaIcon(FontAwesomeIcons.twitter, size: 16),
                  label: const Text("Verify with X"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteSection(ThemeData theme) {
    return Card(
      color: theme.colorScheme.error.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.error, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danger Zone',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Deleting your account is irreversible. Please be certain before proceeding.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('Delete My Account'),
                onPressed: _isSaving ? null : _handleDeleteAccount,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                ),
              ),
            ),
            // --- NEW DEBUG BUTTON ---
            const SizedBox(height: 12),
            Text(
              'Debug Options',
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.error.withOpacity(0.9)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.notifications_active_outlined),
                label: const Text('Simulate News Notification'),
                onPressed: _isSaving ? null : _simulateNewsNotification,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                   side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    ImageProvider<Object>? avatarImageProviderForDisplay;
    if (_pickedImageXFile != null) {
       if (kIsWeb) {
         avatarImageProviderForDisplay = NetworkImage(_pickedImageXFile!.path);
       }
    } else if (_initialProfileImageUrl != null && _initialProfileImageUrl!.isNotEmpty) {
      final uri = Uri.tryParse(_initialProfileImageUrl!);
      if (uri != null && uri.isAbsolute) {
        avatarImageProviderForDisplay = NetworkImage(_initialProfileImageUrl!);
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Profile & Connections'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
            onPressed: _isSaving ? null : _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: AnimatedParticleBackground(
        baseColor: theme.scaffoldBackgroundColor,
        particleColor1: isDark ? AppColors.particleGoldSoft.withOpacity(0.25) : AppColors.particleGoldSoft.withOpacity(0.4),
        particleColor2: isDark ? AppColors.particleDarkGrey.withOpacity(0.25) : AppColors.particleDarkGrey.withOpacity(0.4),
        child: AbsorbPointer(
          absorbing: _isSaving,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top,
                    left: 16, right: 16, bottom: 40
                  ),
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 110, height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.surfaceVariant,
                                    border: Border.all(color: theme.colorScheme.primary, width: 2),
                                    image: (_pickedImageXFile == null && avatarImageProviderForDisplay != null)
                                        ? DecorationImage(image: avatarImageProviderForDisplay, fit: BoxFit.cover, onError: (e,s) => debugPrint("Error loading initial avatar for display (CircleAvatar): $e"))
                                        : null,
                                  ),
                                  child: _pickedImageXFile != null
                                    ? ClipOval(
                                        child: kIsWeb
                                            ? Image.network(_pickedImageXFile!.path, fit: BoxFit.cover, width: 110, height: 110, errorBuilder: (c,e,s) => const FaIcon(FontAwesomeIcons.userAstronaut, size: 50))
                                            : FutureBuilder<Uint8List>(
                                                future: _pickedImageXFile!.readAsBytes(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                                    return Image.memory(snapshot.data!, fit: BoxFit.cover, width: 110, height: 110);
                                                  } else if (snapshot.error != null) {
                                                    return FaIcon(FontAwesomeIcons.userAstronaut, size: 50, color: theme.colorScheme.onSurfaceVariant);
                                                  }
                                                  return const CircularProgressIndicator();
                                                },
                                              ),
                                      )
                                    : (avatarImageProviderForDisplay == null
                                        ? FaIcon(FontAwesomeIcons.userAstronaut, size: 50, color: theme.colorScheme.onSurfaceVariant)
                                        : null),
                                ),
                                Material(
                                  color: theme.colorScheme.primary,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: _isSaving ? null : _pickImage,
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: FaIcon(FontAwesomeIcons.camera, color: AppColors.offBlack, size: 20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _displayNameController,
                              decoration: const InputDecoration(
                                labelText: 'Display Name *',
                                suffixIcon: InfoTooltip(
                                  message: "Your public name throughout the Cabal platform. Make it unique!",
                                )
                              ),
                              validator: (value) => (value == null || value.trim().isEmpty) ? 'Display name cannot be empty' : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                    const SizedBox(height: 24),
                    Text('Grow Your Cabal', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 12),
                    _buildReferralCard(theme).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 24),
                    Text('Verification', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 12),
                    _buildTwitterVerificationCard(theme).animate().fadeIn(delay: 600.ms),
                    
                    const SizedBox(height: 24),
                    Text('Wallet Connections', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)).animate().fadeIn(delay: 700.ms),
                    const SizedBox(height: 8),
                    const WalletConnectorWidget().animate().fadeIn(delay: 800.ms),

                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk, size: 20),
                      label: const Text('Save Profile Changes'),
                      onPressed: _isSaving ? null : _saveProfile,
                      style: theme.elevatedButtonTheme.style?.copyWith(
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      ),
                    ).animate().fadeIn(delay: 900.ms).scaleY(begin: 0.5, curve: Curves.elasticOut),
                    const SizedBox(height: 32),
                    _buildDeleteSection(theme).animate().fadeIn(delay: 1000.ms),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              if (_isSaving)
                Container(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: theme.colorScheme.primary),
                        const SizedBox(height: 20),
                        Text("Please wait...", style: theme.textTheme.titleMedium),
                      ],
                    ),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
