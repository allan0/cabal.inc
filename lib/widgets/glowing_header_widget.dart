// lib/widgets/glowing_header_widget.dart
import 'dart:ui';
import 'dart:math';
import 'package:cabal/utils/app_colors.dart';
import 'package:flutter/material.dart';

class GlowingHeaderWidget extends StatefulWidget {
  final double shrinkProgress; // 0.0 = expanded, 1.0 = collapsed

  const GlowingHeaderWidget({
    Key? key,
    required this.shrinkProgress,
  }) : super(key: key);

  @override
  _GlowingHeaderWidgetState createState() => _GlowingHeaderWidgetState();
}

class _GlowingHeaderWidgetState extends State<GlowingHeaderWidget> with TickerProviderStateMixin {
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Interpolate values based on the shrink progress
    final double textScale = lerpDouble(1.0, 0.6, widget.shrinkProgress)!;
    final double bubbleScale = lerpDouble(1.0, 0.5, widget.shrinkProgress)!;
    final double bubbleOpacity = lerpDouble(0.3, 0.15, widget.shrinkProgress)!;
    final double textYOffset = lerpDouble(0, -15, widget.shrinkProgress)!;

    return Stack(
      alignment: Alignment.center,
      children: [
        // The Bubble Animation
        AnimatedBuilder(
          animation: _breathingController,
          builder: (context, child) {
            final breathValue = (sin(_breathingController.value * 2 * pi) + 1) / 2;
            final breathScale = 1.0 + (breathValue * 0.05);
            final finalScale = breathScale * bubbleScale;

            return Transform.scale(
              scale: finalScale,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryAccent.withOpacity(bubbleOpacity),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            );
          },
        ),
        // The "Cabal" Text
        Transform.translate(
          offset: Offset(0, textYOffset),
          child: Transform.scale(
            scale: textScale,
            child: Text(
              'Cabal',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
                shadows: [
                  Shadow(blurRadius: 20.0, color: AppColors.primaryAccent.withOpacity(0.8)),
                  const Shadow(blurRadius: 10.0, color: AppColors.offBlack),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
