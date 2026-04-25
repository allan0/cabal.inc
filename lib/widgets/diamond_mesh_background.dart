// lib/widgets/diamond_mesh_background.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DiamondMeshBackground extends StatefulWidget {
  final Widget child;
  const DiamondMeshBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<DiamondMeshBackground> createState() => _DiamondMeshBackgroundState();
}

class _DiamondMeshBackgroundState extends State<DiamondMeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _DiamondMeshPainter(
            progress: _controller.value,
            baseColor: AppColors.offBlack,
            lineColor: AppColors.gold.withOpacity(0.1),
            dotColor: AppColors.gold.withOpacity(0.3),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _DiamondMeshPainter extends CustomPainter {
  final double progress;
  final Color baseColor;
  final Color lineColor;
  final Color dotColor;

  _DiamondMeshPainter({
    required this.progress,
    required this.baseColor,
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // --- NEW: Animated Gradient Background for Texture ---
    final center = Alignment(sin(progress * 2 * pi) * 0.5, cos(progress * 2 * pi) * 0.5);
    final gradient = RadialGradient(
      center: center,
      radius: 1.5,
      colors: [
        AppColors.darkGrey, // Darker center
        baseColor,      // Main background color
      ],
      stops: const [0.0, 1.0],
    );
    paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    paint.shader = null; // Reset shader

    // Line Paint
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Dot Paint
    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double spacing = 50.0;
    final double diagonalSpacing = spacing / sqrt(2);

    // Draw rotated grid lines (diamonds)
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), linePaint);
    }
    for (double i = size.height; i > -size.width; i -= spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), linePaint);
    }
    
    // Draw shimmering dots at intersections
    for (double y = 0; y < size.height + diagonalSpacing; y += diagonalSpacing) {
      for (double x = (y % (2 * diagonalSpacing) == 0) ? 0 : diagonalSpacing;
          x < size.width + diagonalSpacing;
          x += 2 * diagonalSpacing) {
        // Use a hash-like function to make shimmering appear random but deterministic
        final hash = (x.toInt() * 31 + y.toInt() * 17) % 100 / 100.0;
        final localShimmer = (sin(progress * 2 * pi + hash * pi) + 1) / 2;
        dotPaint.color = dotColor.withOpacity(localShimmer * 0.5);
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DiamondMeshPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
