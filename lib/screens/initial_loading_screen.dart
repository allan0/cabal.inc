// lib/screens/initial_loading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'home_nav_wrapper.dart';
import '../widgets/diamond_mesh_background.dart';
import '../widgets/app_logo_widget.dart';

class InitialLoadingScreen extends StatefulWidget {
  final Object? initializationError;

  const InitialLoadingScreen({Key? key, required this.initializationError}) : super(key: key);

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // If there's no error, navigate after a short delay to show the success animation.
    if (widget.initializationError == null) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.fade,
              duration: 800.ms,
              child: const HomeNavWrapper(showOnboarding: true),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DiamondMeshBackground(
        child: Center(
          child: widget.initializationError != null
              // If initialization failed, show the error state
              ? Card(
                  color: theme.cardColor.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.circleExclamation, size: 40, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text("Initialization Failed", style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          "Could not connect to essential services. Please check your internet connection and restart the app.",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Error: ${widget.initializationError.toString()}",
                           textAlign: TextAlign.center,
                           style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn()
              // On success, show a brief final animation before navigating
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogoWidget(logoHeight: 80)
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .then(delay: 200.ms)
                        .scale(duration: 400.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 24),
                    Text("Cabal Initialized", style: theme.textTheme.titleMedium)
                        .animate()
                        .fadeIn(delay: 400.ms),
                  ],
                ),
        ),
      ),
    );
  }
}
