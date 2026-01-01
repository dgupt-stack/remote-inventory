import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../shared/theme/jarvis_theme.dart';

enum NavigationDirection {
  none,
  left,
  right,
  up,
  down,
  forward,
  backward,
}

class GuidanceOverlay extends StatefulWidget {
  final NavigationDirection direction;
  final bool laserActive;
  final Offset laserPosition;
  final bool stopRequested;

  const GuidanceOverlay({
    super.key,
    required this.direction,
    required this.laserActive,
    required this.laserPosition,
    required this.stopRequested,
  });

  @override
  State<GuidanceOverlay> createState() => _GuidanceOverlayState();
}

class _GuidanceOverlayState extends State<GuidanceOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Directional arrows
        if (widget.direction != NavigationDirection.none &&
            !widget.stopRequested)
          _buildDirectionalArrow(),

        // Laser pointer
        if (widget.laserActive) _buildLaserPointer(),

        // Stop indicator
        if (widget.stopRequested) _buildStopIndicator(),
      ],
    );
  }

  Widget _buildDirectionalArrow() {
    IconData icon;
    Alignment alignment;
    double rotation = 0;

    switch (widget.direction) {
      case NavigationDirection.left:
        icon = Icons.arrow_back;
        alignment = Alignment.centerLeft;
        rotation = 0;
        break;
      case NavigationDirection.right:
        icon = Icons.arrow_forward;
        alignment = Alignment.centerRight;
        rotation = 0;
        break;
      case NavigationDirection.up:
        icon = Icons.arrow_upward;
        alignment = Alignment.topCenter;
        rotation = 0;
        break;
      case NavigationDirection.down:
        icon = Icons.arrow_downward;
        alignment = Alignment.bottomCenter;
        rotation = 0;
        break;
      case NavigationDirection.forward:
        icon = Icons.arrow_upward;
        alignment = Alignment.center;
        rotation = 0;
        break;
      case NavigationDirection.backward:
        icon = Icons.arrow_downward;
        alignment = Alignment.center;
        rotation = math.pi;
        break;
      default:
        return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Align(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: JarvisTheme.glassEffect(
              color: JarvisTheme.primaryCyan,
            ).copyWith(
              boxShadow: JarvisTheme.neonGlow(
                color: JarvisTheme.primaryCyan.withOpacity(
                  0.3 + (_animationController.value * 0.5),
                ),
              ),
            ),
            child: Transform.rotate(
              angle: rotation,
              child: Icon(
                icon,
                size: 64,
                color: JarvisTheme.primaryCyan,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLaserPointer() {
    return Positioned(
      left: widget.laserPosition.dx,
      top: widget.laserPosition.dy,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: JarvisTheme.warningRed,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: JarvisTheme.warningRed.withOpacity(
                    0.5 + (_animationController.value * 0.5),
                  ),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JarvisTheme.warningRed,
                  boxShadow: JarvisTheme.neonGlow(
                    color: JarvisTheme.warningRed,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStopIndicator() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: JarvisTheme.glassEffect(
              color: JarvisTheme.warningRed,
            ).copyWith(
              boxShadow: JarvisTheme.neonGlow(
                color: JarvisTheme.warningRed.withOpacity(
                  0.5 + (_animationController.value * 0.5),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.pan_tool,
                  size: 80,
                  color: JarvisTheme.warningRed,
                ),
                const SizedBox(height: 16),
                Text(
                  'STOP',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: JarvisTheme.warningRed,
                    shadows: JarvisTheme.neonGlow(
                      color: JarvisTheme.warningRed,
                    )
                        .map((shadow) => Shadow(
                              color: shadow.color,
                              blurRadius: shadow.blurRadius,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
