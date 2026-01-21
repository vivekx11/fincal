import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

enum BentoSize { small, medium, large, wide, tall }

class BentoCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final BentoSize size;
  final VoidCallback onTap;

  const BentoCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.gradientColors,
    this.size = BentoSize.small,
    required this.onTap,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLarge = widget.size == BentoSize.large;
    final bool isMedium = widget.size == BentoSize.medium;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.gradientColors[0].withValues(alpha: 0.15),
                        widget.gradientColors[1].withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                    border: Border.all(
                      color: widget.gradientColors[0].withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: _isPressed
                        ? null
                        : [
                            BoxShadow(
                              color: widget.gradientColors[0].withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative gradient orb
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: isLarge ? 120 : 80,
                          height: isLarge ? 120 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                widget.gradientColors[0].withValues(alpha: 0.3),
                                widget.gradientColors[0].withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.all(isLarge ? 24 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isLarge
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon Container
                            Container(
                              padding: EdgeInsets.all(isLarge ? 16 : 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.gradientColors,
                                ),
                                borderRadius: BorderRadius.circular(isLarge ? 20 : 14),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.gradientColors[0].withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: isLarge ? 32 : isMedium ? 26 : 24,
                              ),
                            ),
                            if (isLarge) const SizedBox(height: 20),
                            // Title
                            Text(
                              widget.title,
                              style: isLarge
                                  ? AppTheme.headingMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    )
                                  : isMedium
                                      ? AppTheme.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w600,
                                        )
                                      : AppTheme.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitle!,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
