// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/app_colors.dart';
import '../../widgets/app_logo_widget.dart';
import '../../widgets/diamond_mesh_background.dart';
import '../../services/supabase_service.dart';
import '../../services/ton_service.dart';
import '../../config.dart';

class LoginScreen extends StatefulWidget {
  final bool fromLogout;

  const LoginScreen({Key? key, this.fromLogout = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _loadingText = "Initializing...";

  /// Standard guest entry via Supabase Anonymous Auth
  Future<void> _entryAsGuest() async {
    setState(() {
      _isLoading = true;
      _loadingText = "Entering Cabal...";
    });

    try {
      await Supabase.instance.client.auth.signInAnonymously();
      // Navigation is handled by the AuthState listener in main.dart or AuthWrapper
    } catch (e) {
      _showError("Guest entry failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// TON Native entry: Connects wallet and then ensures a session exists
  Future<void> _connectTonWallet() async {
    final tonService = Provider.of<TonService>(context, listen: false);
    
    setState(() {
      _isLoading = true;
      _loadingText = "Connecting Wallet...";
    });

    try {
      final address = await tonService.connectWallet();
      if (address != null) {
        // If wallet connects, we ensure we have a Supabase session
        if (Supabase.instance.client.auth.currentSession == null) {
          await Supabase.instance.client.auth.signInAnonymously();
        }
        // SupabaseService handles saving the wallet to the profile
      }
    } catch (e) {
      _showError("TON Connect failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DiamondMeshBackground(
        child: Stack(
          children: [
            // --- UI CONTENT ---
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogoWidget(logoHeight: 80)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 16),
                    Text(
                      AppConfig.appName.toUpperCase(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w900,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    Text(
                      "THE GROWTH ENGINE",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.gold.withOpacity(0.7),
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 60),

                    // --- PRIMARY ACTION: TON CONNECT ---
                    _buildLoginButton(
                      label: "CONNECT TON WALLET",
                      icon: FontAwesomeIcons.gem,
                      onPressed: _connectTonWallet,
                      color: AppColors.gold,
                      textColor: Colors.black,
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),

                    const SizedBox(height: 16),

                    // --- TMA ACTION: TELEGRAM ---
                    if (AppConfig.isTelegramMiniApp)
                      _buildLoginButton(
                        label: "CONTINUE WITH TELEGRAM",
                        icon: FontAwesomeIcons.telegram,
                        onPressed: () {
                          // Placeholder for Telegram Auto-Login logic
                        },
                        color: const Color(0xFF24A1DE),
                        textColor: Colors.white,
                      ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),

                    const SizedBox(height: 32),

                    // --- SECONDARY ACTION: GUEST ---
                    TextButton(
                      onPressed: _entryAsGuest,
                      child: Text(
                        "CONTINUE AS GUEST",
                        style: TextStyle(
                          color: AppColors.lightText.withOpacity(0.6),
                          letterSpacing: 1.2,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ).animate().fadeIn(delay: 1000.ms),
                  ],
                ),
              ),
            ),

            // --- LOADING OVERLAY ---
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.gold),
                      const SizedBox(height: 24),
                      Text(
                        _loadingText,
                        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: FaIcon(icon, size: 20, color: textColor),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          shadowColor: color.withOpacity(0.4),
        ),
      ),
    );
  }
}
