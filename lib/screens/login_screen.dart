// lib/screens/login_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:provider/provider.dart';

import '../services/supabase_service.dart';
import '../features/wallet/application/wallet_provider.dart';
import 'home_nav_wrapper.dart';
import '../utils/app_colors.dart';
import '../widgets/app_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  final bool fromLogout;
  final VoidCallback? onLoginSuccess;

  const LoginScreen({
    Key? key,
    this.fromLogout = false,
    this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  bool _showEmailForm = false;
  late AnimationController _floatingIconController;
  StreamSubscription<AuthState>? _authStateSubscription;
  bool _hasNavigatedAway = false;
  bool _showVerificationMessage = false; // --- FIX: State to manage post-signup UI ---

  @override
  void initState() {
    super.initState();
    _floatingIconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    if (!widget.fromLogout && Supabase.instance.client.auth.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasNavigatedAway) {
          _hasNavigatedAway = true;
          widget.onLoginSuccess?.call();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: const HomeNavWrapper(showOnboarding: false)),
            (route) => false,
          );
        }
      });
    }

    _authStateSubscription = _supabaseService.authStateChanges.listen((state) {
      if (!mounted) return;
      if (state.session != null) {
        if (!_hasNavigatedAway) {
          _hasNavigatedAway = true;
          widget.onLoginSuccess?.call();
          bool showOnboardingForNewUser = state.event == AuthChangeEvent.signedIn;
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: HomeNavWrapper(showOnboarding: showOnboardingForNewUser)),
            (route) => false,
          );
        }
      } else if (state.session == null && state.event == AuthChangeEvent.signedOut) {
        _hasNavigatedAway = false;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _floatingIconController.dispose();
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleEmailPasswordAuth(bool isSignIn, WalletProvider wp) async {
    if (!mounted || !(_formKey.currentState?.validate() ?? false) || wp.isLoading) return;
    
    String actionText = isSignIn ? "Sign In" : "Sign Up";
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (isSignIn) {
        await _supabaseService.signInUser(_emailController.text.trim(), _passwordController.text.trim());
      } else {
        await _supabaseService.signUpUser(_emailController.text.trim(), _passwordController.text.trim());
        if (mounted) {
          // --- FIX: Change UI state instead of just showing a temporary SnackBar ---
          setState(() => _showVerificationMessage = true); 
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('$actionText Failed: ${e.message}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('$actionText - Unexpected error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }
  
  Future<void> _handleSolanaSignIn(WalletProvider walletProvider) async {
    if (!mounted || walletProvider.isLoading) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await walletProvider.connectSolanaWallet();
      if (mounted && walletProvider.isConnectedSolana) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Solana Wallet Connected: ${walletProvider.connectedSolanaAddress}. SIWS flow placeholder.'), backgroundColor: AppColors.info));
      } else if (mounted && walletProvider.solanaError != null) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Solana Connection Failed: ${walletProvider.solanaError}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Solana Connection Failed: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  Future<void> _handleOAuthSignIn(WalletProvider wp, String providerName, Future<bool> Function() signInFunction) async {
    if (!mounted || wp.isLoading) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final bool flowInitiated = await signInFunction();
      if (!flowInitiated && mounted) {
         scaffoldMessenger.showSnackBar(SnackBar(content: Text('$providerName Sign-In could not be initiated.'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('$providerName Sign-In Error: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }
  }

  Future<void> _forceLogout() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _supabaseService.signOutUser();
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Forced logout successful. Please sign up again.'), backgroundColor: AppColors.info),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Logout failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildFloatingIcon({ required IconData icon, required Color color, required double size, required Alignment alignment, Duration delay = Duration.zero, double verticalOffset = 10,}) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: _floatingIconController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, Curves.easeInOutSine.transform(_floatingIconController.value) * verticalOffset - (verticalOffset / 2)),
            child: child,
          );
        },
        child: FaIcon(icon, color: color.withOpacity(0.6), size: size),
      ),
    ).animate(delay: delay).fadeIn(duration: 900.ms, curve: Curves.easeOutCubic).slide(begin: const Offset(0, 0.3), duration: 800.ms, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const solanaGradient = LinearGradient(
      colors: [Color(0xFF9945FF), Color(0xFF14F195)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.offBlack, AppColors.darkGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingIcon(icon: FontAwesomeIcons.ethereum, color: AppColors.gold, size: screenWidth * 0.08, alignment: Alignment(screenWidth > 600 ? -0.7 : -0.6, -0.65), delay: 600.ms, verticalOffset: 15),
            _buildFloatingIcon(icon: FontAwesomeIcons.google, color: AppColors.gradientGoldStart, size: screenWidth * 0.06, alignment: Alignment(screenWidth > 600 ? 0.8 : 0.7, -0.5), delay: 800.ms, verticalOffset: -10),
            _buildFloatingIcon(icon: FontAwesomeIcons.discord, color: AppColors.goldHighlight, size: screenWidth * 0.06, alignment: Alignment(screenWidth > 600 ? 0.75 : 0.65, -0.1), delay: 1400.ms, verticalOffset: 10),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    const AppLogoWidget(logoHeight: 60).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3, duration: 600.ms, curve: Curves.easeOutExpo),
                    const SizedBox(height: 10),
                    Text(
                      'Join the Cabal',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, shadows: [Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.5), offset: const Offset(0, 2))]),
                    ).animate().fadeIn(delay: 400.ms, duration: 700.ms).slideY(begin: 0.2, curve: Curves.elasticOut),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Card(
                        elevation: 10,
                        color: theme.cardColor.withOpacity(0.95),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // --- FIX: Show verification message instead of buttons ---
                              if (_showVerificationMessage)
                                _buildVerificationMessage(theme)
                              else ...[
                                if (!kIsWeb)
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: solanaGradient,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      icon: walletProvider.isLoading ? const SizedBox.shrink() : const FaIcon(FontAwesomeIcons.wallet, size: 18),
                                      label: walletProvider.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Continue with Wallet'),
                                      onPressed: walletProvider.isLoading ? null : () => _handleSolanaSignIn(walletProvider),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 500.ms),
                                
                                if (!kIsWeb) const SizedBox(height: 12),

                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                                  label: const Text('Continue with Google'),
                                  onPressed: walletProvider.isLoading ? null : () => _handleOAuthSignIn(walletProvider, "Google", _supabaseService.signInWithGoogle),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4285F4), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                                ).animate().fadeIn(delay: 600.ms),

                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.discord, size: 18),
                                  label: const Text('Continue with Discord'),
                                  onPressed: walletProvider.isLoading ? null : () => _handleOAuthSignIn(walletProvider, "Discord", _supabaseService.signInWithDiscord),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5865F2), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                                ).animate().fadeIn(delay: 700.ms),

                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.email_outlined, size: 18),
                                  label: const Text('Continue with Email'),
                                  onPressed: walletProvider.isLoading ? null : () => setState(() => _showEmailForm = !_showEmailForm),
                                  style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.onSurface, side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 12)),
                                ).animate().fadeIn(delay: 800.ms),

                                AnimatedSize(
                                  duration: 300.ms,
                                  curve: Curves.easeInOut,
                                  child: _showEmailForm ? _buildEmailForm(theme, walletProvider) : const SizedBox(width: double.infinity),
                                ),

                                const Divider(height: 32),
                                TextButton.icon(
                                  icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                                  label: const Text('Stuck? Force Logout'),
                                  onPressed: _forceLogout,
                                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6)),
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FIX: New widget to show after signup ---
  Widget _buildVerificationMessage(ThemeData theme) {
    return Column(
      children: [
        FaIcon(FontAwesomeIcons.solidEnvelopeOpen, size: 40, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'Check Your Email!',
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a verification link to ${_emailController.text}. Please click the link to complete your sign-up.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => setState(() => _showVerificationMessage = false),
          child: const Text('Back to Sign In'),
        )
      ],
    ).animate().fadeIn();
  }

  Widget _buildEmailForm(ThemeData theme, WalletProvider wp) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 32),
          TextFormField(
            controller: _emailController,
            style: theme.textTheme.bodyLarge,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: (v) => (v == null || !v.contains('@')) ? 'Please enter a valid email' : null,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            style: theme.textTheme.bodyLarge,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: wp.isLoading ? null : () => _handleEmailPasswordAuth(true, wp),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: wp.isLoading ? null : () => _handleEmailPasswordAuth(false, wp),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(),
    );
  }
}
