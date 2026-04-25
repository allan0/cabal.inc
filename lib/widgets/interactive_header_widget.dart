// lib/widgets/interactive_header_widget.dart
import 'dart:async';
import 'dart:ui';
import 'package:cabal/utils/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // <-- FIX: IMPORT ADDED
import 'package:flutter_animate/flutter_animate.dart'; // <-- FIX: IMPORT ADDED

class InteractiveHeaderWidget extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onOpenSidePanel; // Callback for horizontal drag

  const InteractiveHeaderWidget({
    Key? key,
    required this.scrollController,
    required this.onOpenSidePanel,
  }) : super(key: key);

  @override
  _InteractiveHeaderWidgetState createState() => _InteractiveHeaderWidgetState();
}

class _InteractiveHeaderWidgetState extends State<InteractiveHeaderWidget> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _interactionController;
  late Animation<double> _bubbleScaleAnimation;
  late Animation<double> _bubbleOpacityAnimation;
  late Animation<Color?> _textColorAnimation;

  bool _isInteracting = false;
  double _dragStartY = 0.0;

  // Sensitivity for the scroll gesture
  static const double _scrollSensitivity = 1.5;

  @override
  void initState() {
    super.initState();
    // For the idle "breathing" animation
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // For the on-touch interaction animation
    _interactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bubbleScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _interactionController, curve: Curves.elasticOut),
    );
    _bubbleOpacityAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(_interactionController);
    _textColorAnimation = ColorTween(begin: AppColors.gold, end: Colors.white).animate(_interactionController);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _interactionController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.scrollController.hasClients) {
      setState(() {
        _isInteracting = true;
        _dragStartY = details.globalPosition.dy;
        _interactionController.forward();

        // Animate the scroll view to snap the header into place
        widget.scrollController.animateTo(
          180, // This value should be the height of your header when collapsed
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isInteracting || !widget.scrollController.hasClients) return;

    final verticalDelta = details.delta.dy;
    final horizontalDelta = details.delta.dx;

    // Prioritize vertical scroll over horizontal action
    if (verticalDelta.abs() > horizontalDelta.abs()) {
      // Dragging down (negative delta) should scroll the content up (positive offset)
      final scrollOffset = widget.scrollController.offset - (verticalDelta * _scrollSensitivity);
      widget.scrollController.jumpTo(scrollOffset.clamp(0.0, widget.scrollController.position.maxScrollExtent));
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.scrollController.hasClients) {
      setState(() {
        _isInteracting = false;
        _interactionController.reverse();
      });
    }
  }
  
  void _onHorizontalDragEnd(DragEndDetails details) {
    // Detect a "flick" to the right to open the side panel
    if (details.velocity.pixelsPerSecond.dx > 500) {
      widget.onOpenSidePanel();
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 250, // Initial expanded height of the header
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The Bubble Animation
            AnimatedBuilder(
              animation: Listenable.merge([_breathingController, _interactionController]),
              builder: (context, child) {
                final breathValue = (sin(_breathingController.value * 2 * pi) + 1) / 2; // 0 to 1 sine wave
                final breathScale = 1.0 + (breathValue * 0.05);
                final finalScale = breathScale * _bubbleScaleAnimation.value;

                return Transform.scale(
                  scale: finalScale,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryAccent.withOpacity(_bubbleOpacityAnimation.value),
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
            AnimatedBuilder(
                animation: _interactionController,
                builder: (context, child) {
                  return Text(
                    'Cabal',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textColorAnimation.value,
                      shadows: [
                        Shadow(blurRadius: _isInteracting ? 30.0 : 15.0, color: AppColors.primaryAccent.withOpacity(0.8)),
                        const Shadow(blurRadius: 10.0, color: AppColors.offBlack),
                      ],
                    ),
                  );
                }),
            // Instructional hint
            if (!_isInteracting)
              Positioned(
                bottom: 60,
                child: IgnorePointer(
                  child: Text(
                    "Touch and Drag to Explore",
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.5)),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 2000.ms),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
