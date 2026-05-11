// lib/screens/initial_loading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/diamond_mesh_background.dart';

class InitialLoadingScreen extends StatelessWidget {
  final Object? initializationError;

  const InitialLoadingScreen({
    Key? key, 
    this.initializationError
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.offBlack,
      body: DiamondMeshBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- 1. ANIMATED LOGO ---
                const AppLogoWidget(logoHeight: 100)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .shimmer(duration: 2000.ms, color: AppColors.gold.withOpacity(0.5))
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.05, 1.05),
                      duration: 2000.ms,
                      curve: Curves.easeInOut,
                    ),

                const SizedBox(height: 32),

                // --- 2. ERROR OR LOADING STATE ---
                if (initializationError != null)
                  _buildErrorState(theme)
                else
                  _buildLoadingState(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Column(
      children: [
        Text(
          "INITIALIZING CABAL",
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.gold,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 16),
        
        // Custom sleek progress bar
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 2,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 24),
        
        Text(
          "CONNECTING TO TON BLOCKCHAIN",
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.greyText.withOpacity(0.5),
            letterSpacing: 1.2,
          ),
        ).animate(onPlay: (c) => c.repeat())
         .fadeIn(duration: 1000.ms)
         .then(delay: 1000.ms)
         .fadeOut(duration: 1000.ms),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Column(
      children: [
        const FaIcon(
          FontAwesomeIcons.circleExclamation, 
          color: AppColors.error, 
          size: 32
        ).animate().shake(),
        const SizedBox(height: 16),
        Text(
          "INITIALIZATION FAILED",
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          initializationError.toString(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.greyText),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // Logic to restart app would go here
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkGrey),
          child: const Text("RETRY CONNECTION"),
        ),
      ],
    ).animate().fadeIn();
  }
}
