// lib/widgets/shimmer_widget.dart
import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          isDark ? Colors.grey[800]! : Colors.grey[200]!,
          isDark ? Colors.grey[700]! : Colors.grey[300]!,
          isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ],
        stops: const [0.1, 0.5, 0.9],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isDark ? Colors.grey[850]! : Colors.grey[100]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  final LinearGradient gradient;
  final Widget child;

  const Shimmer({
    super.key,
    required this.gradient,
    required this.child,
  });

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1200));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return widget.gradient.createShader(
          Rect.fromLTWH(
            -bounds.width * _shimmerController.value,
            0,
            bounds.width * 3,
            bounds.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
