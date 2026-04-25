import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed: Not used in this file

class QuestCompleteCelebration extends StatefulWidget {
  final VoidCallback onAnimationComplete;
  const QuestCompleteCelebration({Key? key, required this.onAnimationComplete}) : super(key: key);

  @override
  State<QuestCompleteCelebration> createState() => _QuestCompleteCelebrationState();
}

class _QuestCompleteCelebrationState extends State<QuestCompleteCelebration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Widget> _emojis = [];
  final Random _random = Random();
  final List<String> _emojiChars = ['🎉', '✨', '🚀', '🌟', '💰', '👍', '💯', '🔥', '🥳'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 2500.ms, // Total duration of the celebration
    )..forward().whenComplete(() {
      if (mounted) {
        widget.onAnimationComplete();
      }
    });

    // Generate emojis at the start
    _generateEmojis();
  }

  void _generateEmojis() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < 15; i++) { // Number of emojis
      final emoji = _emojiChars[_random.nextInt(_emojiChars.length)];
      final startX = _random.nextDouble() * screenWidth * 0.6 + screenWidth * 0.2; // Center 60%
      final startY = screenHeight * 0.4 + _random.nextDouble() * screenHeight * 0.2; // Middle section
      final endY = startY - (screenHeight * (_random.nextDouble() * 0.3 + 0.3)); // Move up
      final endX = startX + (_random.nextDouble() * 100 - 50); // Slight horizontal drift
      final duration = _random.nextInt(800) + 1200; // ms
      final delay = _random.nextInt(300); //ms
      final size = _random.nextDouble() * 20 + 25.0; // Emoji size

      _emojis.add(
        Positioned(
          left: startX,
          top: startY,
          child: Text(emoji, style: TextStyle(fontSize: size))
              .animate(delay: delay.ms, controller: _controller)
              .fade(duration: (duration * 0.3).round().ms, curve: Curves.easeIn)
              .slide(
                duration: duration.ms,
                begin: Offset.zero,
                end: Offset((endX - startX) / size, (endY - startY) / size), // Normalized slide
                curve: Curves.easeOutCirc,
              )
              .then(delay: (duration * 0.6).round().ms)
              .fadeOut(duration: (duration * 0.4).round().ms)
              .scale(begin: const Offset(1,1), end: const Offset(1.5,1.5), duration: duration.ms, curve: Curves.elasticOut),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If emojis are not generated yet (because context for screen size wasn't ready)
    if (_emojis.isEmpty && mounted) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _generateEmojis();
          setState(() {});
        }
      });
    }
    return IgnorePointer( // Makes the overlay non-interactive
      child: Stack(
        children: _emojis,
      ),
    );
  }
}

// Helper to show the celebration overlay
void showQuestCompleteCelebration(BuildContext context) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => QuestCompleteCelebration(
      onAnimationComplete: () {
        overlayEntry?.remove();
      },
    ),
  );
  Overlay.of(context).insert(overlayEntry);
}
