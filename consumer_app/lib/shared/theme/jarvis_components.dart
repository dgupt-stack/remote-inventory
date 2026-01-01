import 'package:flutter/material.dart';

class JarvisColors {
  // Core colors
  static const primary = Color(0xFF00D9FF); // Cyan
  static const background = Color(0xFF0A0E27); // Dark navy
  static const surface = Color(0xFF1a1f3a); // Slightly lighter navy

  // Accent colors
  static const primaryGlow = Color(0x4000D9FF); // 25% opacity cyan
  static const success = Color(0xFF00FF88); // Green for status indicators
  static const warning = Color(0xFFFFAA00);
  static const error = Color(0xFFFF4444);

  // Text colors
  static const textPrimary = Color(0xFFE0E0E0);
  static const textSecondary = Color(0xFF888888);
  static const textCyan = primary;

  // Badge/Card colors
  static const badgeBackground = Color(0xCC1a1f3a); // 80% opacity
  static const borderCyan = primary;
}

class JarvisTextStyles {
  static const header = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: JarvisColors.primary,
    letterSpacing: 4,
    shadows: [
      Shadow(
        color: JarvisColors.primaryGlow,
        blurRadius: 20,
      ),
    ],
  );

  static const statusBadge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: JarvisColors.primary,
    letterSpacing: 1,
  );

  static const time = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    color: JarvisColors.primary,
    letterSpacing: 1,
  );

  static const liveBadge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: JarvisColors.success,
    letterSpacing: 2,
  );
}

class GlassBadge extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Widget? leading;
  final EdgeInsets padding;

  const GlassBadge({
    Key? key,
    required this.text,
    this.textColor,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: JarvisColors.badgeBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: JarvisColors.borderCyan,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: JarvisColors.primaryGlow,
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: (textColor != null
                ? JarvisTextStyles.statusBadge.copyWith(color: textColor)
                : JarvisTextStyles.statusBadge),
          ),
        ],
      ),
    );
  }
}

class JarvisIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  const JarvisIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color ?? JarvisColors.primary,
        size: size,
      ),
      onPressed: onPressed,
      splashRadius: 24,
    );
  }
}

class ZoomIndicator extends StatelessWidget {
  final double zoom;
  final Function(double) onZoomChanged;

  const ZoomIndicator({
    Key? key,
    required this.zoom,
    required this.onZoomChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: JarvisColors.badgeBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: JarvisColors.borderCyan,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            color: JarvisColors.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '${zoom.toStringAsFixed(1)}x',
            style: JarvisTextStyles.statusBadge,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                activeTrackColor: JarvisColors.primary,
                inactiveTrackColor: JarvisColors.primary.withOpacity(0.3),
                thumbColor: JarvisColors.primary,
                overlayColor: JarvisColors.primaryGlow,
              ),
              child: Slider(
                value: zoom,
                min: 0.5,
                max: 3.0,
                onChanged: onZoomChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
