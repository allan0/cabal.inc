import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Not directly used in this widget, can remove if not needed elsewhere

import '../utils/app_colors.dart'; // <--- ADDED THIS IMPORT

class AnimatedParticleBackground extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color particleColor1;
  final Color particleColor2;

  const AnimatedParticleBackground({
    Key? key,
    required this.child,
    this.baseColor = AppColors.offBlack, // <--- CHANGED DEFAULT to AppColors.offBlack
    this.particleColor1 = AppColors.particleGoldSoft, // <--- CHANGED DEFAULT to AppColors.particleGoldSoft
    this.particleColor2 = AppColors.particleGreySoft, // <--- CHANGED DEFAULT to AppColors.particleGreySoft
  }) : super(key: key);

  @override
  _AnimatedParticleBackgroundState createState() => _AnimatedParticleBackgroundState();
}

class _AnimatedParticleBackgroundState extends State<AnimatedParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_Particle> _particles = [];
  final int _numParticles = 60; // Increased for denser, 'textured' feel // Number of particles
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // Slower, subtle animation
      vsync: this,
    )..repeat();

    // Initialize particles after the first frame to get screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initParticles(MediaQuery.of(context).size);
        setState(() {}); // Trigger a rebuild once particles are initialized
      }
    });
  }

  void _initParticles(Size screenSize) {
    _particles = List.generate(_numParticles, (index) {
      return _Particle(
        position: Offset(
          _random.nextDouble() * screenSize.width,
          _random.nextDouble() * screenSize.height,
        ),
        radius: _random.nextDouble() * 2.0 + 0.5, // Even smaller, more numerous: 0.5 to 2.5
        color: _random.nextBool() ? widget.particleColor1 : widget.particleColor2,
        speed: Offset(
          (_random.nextDouble() - 0.5) * 0.15, // Slower speeds for calmer background // Slower speeds
          (_random.nextDouble() - 0.5) * 0.15, // Slower speeds for calmer background
        ),
        opacity: _random.nextDouble() * 0.25 + 0.05, // Even lower opacity: 0.05 to 0.3
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(
        controller: _controller,
        particles: _particles,
        baseColor: widget.baseColor,
        screenSizeCallback: () => mounted ? MediaQuery.of(context).size : Size.zero,
      ),
      child: widget.child,
    );
  }
}

class _Particle {
  Offset position;
  double radius;
  Color color;
  Offset speed;
  double opacity;

  _Particle({
    required this.position,
    required this.radius,
    required this.color,
    required this.speed,
    required this.opacity,
  });

  void update(Size screenSize) {
    position += speed;

    // Wrap around screen edges
    if (position.dx < -radius) position = Offset(screenSize.width + radius, position.dy);
    if (position.dx > screenSize.width + radius) position = Offset(-radius, position.dy);
    if (position.dy < -radius) position = Offset(position.dx, screenSize.height + radius);
    if (position.dy > screenSize.height + radius) position = Offset(position.dx, -radius);
  }
}

class _BackgroundPainter extends CustomPainter {
  final Animation<double> controller;
  final List<_Particle> particles;
  final Color baseColor;
  final Size Function() screenSizeCallback;


  _BackgroundPainter({
    required this.controller,
    required this.particles,
    required this.baseColor,
    required this.screenSizeCallback,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw base background color
    paint.color = baseColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    if (particles.isEmpty) return; // Don't draw particles if not initialized

    final screenSize = screenSizeCallback();
    if (screenSize == Size.zero) return; // If size is not available yet.


    // Draw and update particles
    for (var particle in particles) {
      particle.update(size); // Use current canvas size for updates
      paint.color = particle.color.withOpacity(particle.opacity * (0.5 + (0.5 * sin(controller.value * 2 * pi)))); // Pulsating opacity
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return particles.isNotEmpty; // Repaint if particles are there, controller handles animation repaint
  }
}
