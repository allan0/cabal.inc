import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/diamond_mesh_background.dart';
import '../../widgets/app_logo_widget.dart';
import '../../services/ton_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isConnecting = false;

  Future<void> _handleTonConnect() async {
    setState(() => _isConnecting = true);
    final ton = context.read<TonService>();
    final success = await ton.connectWallet();
    
    if (mounted) {
      setState(() => _isConnecting = false);
      if (success == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connection Failed"), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiamondMeshBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogoWidget(logoHeight: 120)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
                
                const SizedBox(height: 16),
                
                const Text(
                  "CABAL",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: AppColors.gold,
                  ),
                ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
                
                const Text(
                  "THE GROWTH ENGINE",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 4,
                    color: AppColors.greyText,
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 80),

                // Primary Action: Connect TON
                _buildActionButton(
                  label: "CONNECT TON WALLET",
                  icon: FontAwesomeIcons.gem,
                  onPressed: _handleTonConnect,
                  isLoading: _isConnecting,
                  isPrimary: true,
                ).animate().slideY(begin: 0.2, duration: 600.ms),

                const SizedBox(height: 16),

                // Secondary Action: Guest
                _buildActionButton(
                  label: "EXPLORE AS GUEST",
                  icon: Icons.visibility_outlined,
                  onPressed: () => _handleTonConnect(), // Simplified for now
                  isLoading: false,
                  isPrimary: false,
                ).animate().slideY(begin: 0.4, duration: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isLoading,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isPrimary ? AppColors.primaryGradient : null,
          color: isPrimary ? null : Colors.white.withOpacity(0.05),
          border: isPrimary ? null : Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: isPrimary ? [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ] : [],
        ),
        child: Center(
          child: isLoading 
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(icon, size: 18, color: isPrimary ? Colors.black : AppColors.gold),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: isPrimary ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
