import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../shared/theme/jarvis_theme.dart';

class TouchController extends StatefulWidget {
  final Widget child;
  final Function(String direction) onNavigate;
  final Function(double delta) onZoom;
  final Function(bool active, Offset? position) onLaserActive;
  final VoidCallback onStop;

  const TouchController({
    super.key,
    required this.child,
    required this.onNavigate,
    required this.onZoom,
    required this.onLaserActive,
    required this.onStop,
  });

  @override
  State<TouchController> createState() => _TouchControllerState();
}

class _TouchControllerState extends State<TouchController> {
  Offset? _longPressPosition;
  Timer? _longPressTimer;
  bool _laserActive = false;
  double _lastScale = 1.0;
  int _tapCount = 0;
  Timer? _doubleTapTimer;

  void _handlePanUpdate(DragUpdateDetails details) {
    final delta = details.delta;

    // Determine direction based on swipe
    if (delta.dx.abs() > delta.dy.abs()) {
      // Horizontal swipe
      if (delta.dx > 5) {
        widget.onNavigate('right');
        HapticFeedback.lightImpact();
      } else if (delta.dx < -5) {
        widget.onNavigate('left');
        HapticFeedback.lightImpact();
      }
    } else {
      // Vertical swipe
      if (delta.dy > 5) {
        widget.onNavigate('down');
        HapticFeedback.lightImpact();
      } else if (delta.dy < -5) {
        widget.onNavigate('up');
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final scale = details.scale;

    if ((scale - _lastScale).abs() > 0.1) {
      final delta = scale > _lastScale ? 0.2 : -0.2;
      widget.onZoom(delta);
      _lastScale = scale;
      HapticFeedback.selectionClick();
    }
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    setState(() {
      _longPressPosition = details.localPosition;
      _laserActive = true;
    });

    widget.onLaserActive(true, details.localPosition);
    HapticFeedback.mediumImpact();
  }

  void _handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    setState(() {
      _longPressPosition = details.localPosition;
    });

    widget.onLaserActive(true, details.localPosition);
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _laserActive = false;
      _longPressPosition = null;
    });

    widget.onLaserActive(false, null);
    HapticFeedback.lightImpact();
  }

  void _handleTap() {
    _tapCount++;

    if (_tapCount == 1) {
      _doubleTapTimer = Timer(const Duration(milliseconds: 300), () {
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
      _doubleTapTimer?.cancel();
      _tapCount = 0;

      // Double tap detected - trigger stop
      widget.onStop();
      HapticFeedback.heavyImpact();

      // Show visual feedback
      _showStopFeedback();
    }
  }

  void _showStopFeedback() {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: JarvisTheme.glassEffect(
            color: JarvisTheme.warningRed,
          ).copyWith(
            boxShadow: JarvisTheme.neonGlow(
              color: JarvisTheme.warningRed,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pan_tool,
                size: 64,
                color: JarvisTheme.warningRed,
              ),
              const SizedBox(height: 16),
              Text(
                'STOP SENT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: JarvisTheme.warningRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _doubleTapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onScaleUpdate: _handleScaleUpdate,
      onLongPressStart: _handleLongPressStart,
      onLongPressMoveUpdate: _handleLongPressMoveUpdate,
      onLongPressEnd: _handleLongPressEnd,
      onTap: _handleTap,
      child: Stack(
        children: [
          widget.child,

          // Laser pointer indicator
          if (_laserActive && _longPressPosition != null)
            Positioned(
              left: _longPressPosition!.dx - 40,
              top: _longPressPosition!.dy - 40,
              child: IgnorePointer(
                child: _buildLaserIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLaserIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: JarvisTheme.warningRed.withOpacity(value),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: JarvisTheme.warningRed.withOpacity(value * 0.5),
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
    );
  }
}
