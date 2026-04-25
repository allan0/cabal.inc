// lib/widgets/info_tooltip.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoTooltip extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;

  const InfoTooltip({
    Key? key,
    required this.message,
    this.icon = FontAwesomeIcons.circleInfo,
    this.iconSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: message,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      showDuration: const Duration(seconds: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      textStyle: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodyMedium?.color),
      triggerMode: TooltipTriggerMode.tap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: FaIcon(
          icon,
          size: iconSize,
          color: theme.colorScheme.secondary.withOpacity(0.8),
        ),
      ),
    );
  }
}
