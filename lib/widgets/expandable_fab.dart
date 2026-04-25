import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Removed: Not used in this file
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<ActionButton> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(theme),
          ..._buildExpandingActionButtons(theme),
          _buildTapToOpenFab(theme),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab(ThemeData theme) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          color: theme.colorScheme.secondaryContainer,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons(ThemeData theme) {
    final children = <Widget>[];
    final count = widget.children.length;
    // Angle calculation adjusted for N children to spread them correctly if count is low
    // For 3 children, this spreads them 0, 45, 90 degrees from the bottom-right origin.
    // If you need them truly circular or symmetric, this formula might need more thought.
    final step = count > 1 ? 90.0 / (count - 1) : 0.0;
    for (var i = 0; i < count; i++) {
      final angleInDegrees = 90.0 - (step * i); // Spreads buttons upwards and leftwards from 0 to 90 degrees
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab(ThemeData theme) {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: theme.colorScheme.secondary,
            onPressed: _toggle,
            child: FaIcon(FontAwesomeIcons.wandMagicSparkles, color: theme.colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final ActionButton child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: offset.dx,
          bottom: offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: FractionalTranslation(
              translation: Offset(-progress.value, 0.0), 
              child: Opacity( 
                opacity: progress.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (child.tooltip != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 4, right: 4),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0,1),
                            )
                          ]
                        ),
                        child: Text(child.tooltip!, style: theme.textTheme.bodySmall),
                      ),
                    FloatingActionButton.small(
                      heroTag: null, 
                      backgroundColor: theme.colorScheme.secondary, // <--- CHANGED HERE! More prominent gold.
                      foregroundColor: theme.colorScheme.onSecondary, // <--- CHANGED HERE! Ensure contrast.
                      onPressed: child.onPressed,
                      child: child.icon,
                      tooltip: child.tooltip,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
    this.tooltip,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    // This build method for ActionButton itself is currently just a SizedBox.shrink().
    // The actual FloatingActionButton is created within _ExpandingActionButton.
    // This is generally fine as ActionButton is more of a data model for the button.
    return const SizedBox.shrink(); 
  }
}
