// lib/widgets/animated_header_widget.dart
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnimatedHeaderWidget extends StatefulWidget {
  const AnimatedHeaderWidget({Key? key}) : super(key: key);

  @override
  State<AnimatedHeaderWidget> createState() => _AnimatedHeaderWidgetState();
}

class _AnimatedHeaderWidgetState extends State<AnimatedHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _textColorAnimation;
  late Animation<double> _shadowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Use a CurvedAnimation to make the pulse feel more natural
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Animate text color from a subtle gold to a bright white and back
    _textColorAnimation = ColorTween(
      begin: AppColors.gold.withOpacity(0.8),
      end: Colors.white,
    ).animate(_animation);
    
    // Animate the shadow opacity to create a "glow"
    _shadowOpacityAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(_animation);

    _controller.repeat(reverse: true); // Loop the animation back and forth
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            // The background gradient pulse
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5 * _animation.value, // Animate the radius
              colors: [
                AppColors.gold.withOpacity(0.15 * _animation.value),
                Colors.transparent,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Center(
            child: Text(
              'Cabal',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textColorAnimation.value,
                shadows: [
                  Shadow(
                    blurRadius: 25.0 * _animation.value,
                    color: AppColors.gold.withOpacity(_shadowOpacityAnimation.value),
                  ),
                  Shadow(
                    blurRadius: 10.0,
                    color: AppColors.offBlack.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
