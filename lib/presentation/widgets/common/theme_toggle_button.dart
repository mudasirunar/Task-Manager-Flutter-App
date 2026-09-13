import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';

/// Animated theme toggle button featuring filled gradient icons for Sun and Moon,
/// with a springy scale effect and full spin rotation micro-animation.
class ThemeToggleButton extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggleButton({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _rotationAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    // Full 360-degree rotation with a smooth, expressive easeOutBack curve
    _rotationAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    // Springy scale: quick compress, dynamic overshoot spring, and gentle settle
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.82)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.82, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.18, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30.0,
      ),
    ]).animate(_animController);
  }

  @override
  void didUpdateWidget(covariant ThemeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animController.forward(from: 0.0);
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    // Glowing aura and borders customized for Light vs Dark modes
    final containerBg =
        isDark ? const Color(0xFF1A2332) : const Color(0xFFF1F5F9);
    final borderColor =
        isDark ? const Color(0xFF2E3D52) : const Color(0xFFE2E8F0);
    final glowColor = isDark
        ? const Color(0x35F59E0B) // Solar golden aura
        : const Color(0x3038BDF8); // Celestial sky-blue aura

    return Tooltip(
      message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          splashColor: (isDark
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF38BDF8))
              .withValues(alpha: 0.15),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: containerBg,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: glowColor,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnim.value * 2 * math.pi,
                    child: Transform.scale(
                      scale: _animController.isAnimating
                          ? _scaleAnim.value
                          : 1.0,
                      child: child,
                    ),
                  );
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeInBack,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: isDark
                      ? _buildSunIcon(key: const ValueKey('sun_icon'))
                      : _buildMoonIcon(key: const ValueKey('moon_icon')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a radiant Sun icon with warm yellow-amber gradient fill.
  Widget _buildSunIcon({required Key key}) {
    return ShaderMask(
      key: key,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFEA79), // Bright radiant yellow
            Color(0xFFF59E0B), // Vibrant amber gold
            Color(0xFFD97706), // Deep warm sun-kissed orange
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: const Icon(
        Icons.light_mode_rounded,
        size: 21,
        color: Colors.white,
      ),
    );
  }

  /// Builds a celestial Moon icon with dreamy light-blue to twilight indigo gradient fill.
  Widget _buildMoonIcon({required Key key}) {
    return ShaderMask(
      key: key,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFBAE6FD), // Ethereal light sky blue
            Color(0xFF60A5FA), // Luminous azure blue
            Color(0xFF6366F1), // Deep twilight indigo
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: const Icon(
        Icons.dark_mode_rounded,
        size: 21,
        color: Colors.white,
      ),
    );
  }
}
