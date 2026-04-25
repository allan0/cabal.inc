// lib/widgets/info_tile_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/app_colors.dart';

class InfoTileWidget extends StatefulWidget {
  final IconData? icon;
  final Widget? leadingWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final List<Color>? gradientColors;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const InfoTileWidget({
    Key? key,
    this.icon,
    this.leadingWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.gradientColors,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
  }) : assert(icon != null || leadingWidget != null, "Either icon or leadingWidget must be provided");

  @override
  State<InfoTileWidget> createState() => _InfoTileWidgetState();
}

class _InfoTileWidgetState extends State<InfoTileWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = widget.iconColor ?? (widget.gradientColors != null ? Colors.white : theme.colorScheme.primary);
    final effectiveTitleStyle = widget.titleStyle ?? theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: widget.gradientColors != null ? Colors.white : theme.textTheme.titleMedium?.color
    );
    final effectiveSubtitleStyle = widget.subtitleStyle ?? theme.textTheme.bodySmall?.copyWith(
        color: widget.gradientColors != null ? Colors.white.withOpacity(0.8) : theme.textTheme.bodySmall?.color?.withOpacity(0.7)
    );

    // This AnimatedBuilder will handle the rotating border gradient
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), // Slightly larger radius for the border
            gradient: SweepGradient(
              center: Alignment.center,
              transform: GradientRotation(_controller.value * 2 * pi),
              colors: [
                AppColors.gold.withOpacity(0.5),
                Colors.transparent,
                Colors.transparent,
                AppColors.gold.withOpacity(0.5),
                Colors.transparent,
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.5, 0.9, 0.9, 1.0], // Creates two moving "comets"
            ),
          ),
          padding: const EdgeInsets.all(1.5), // This padding creates the border thickness
          child: child,
        );
      },
      child: Card(
        margin: EdgeInsets.zero, // Card is now inside the border container
        elevation: 0, // Elevation is handled by the parent if needed
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: widget.gradientColors != null ? widget.gradientColors![0].withOpacity(0.3) : theme.splashColor,
          highlightColor: widget.gradientColors != null ? widget.gradientColors![0].withOpacity(0.1) : theme.highlightColor,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: widget.gradientColors != null
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.gradientColors!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  )
                : BoxDecoration(color: theme.cardColor), 
            child: Row(
              children: [
                if (widget.leadingWidget != null)
                  widget.leadingWidget!
                else if (widget.icon != null)
                   FaIcon(widget.icon, size: 28, color: effectiveIconColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: effectiveTitleStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: effectiveSubtitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 18, color: effectiveIconColor.withOpacity(0.7)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
