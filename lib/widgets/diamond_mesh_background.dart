import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DiamondMeshBackground extends StatelessWidget {
  final Widget child;
  const DiamondMeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _MeshPainter()),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  AppColors.background.withOpacity(0.8),
                  AppColors.background,
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _MeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
    for (double i = size.height; i > -size.width; i -= spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
