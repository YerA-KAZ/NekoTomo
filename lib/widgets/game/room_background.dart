import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';

/// Fullscreen cozy room background with optional glass/dim overlay
class RoomBackground extends StatelessWidget {
  final String imagePath;
  final Widget? child;
  final double dimOpacity;
  final double blurAmount;
  final bool showCozyVignette;

  const RoomBackground({
    super.key,
    required this.imagePath,
    this.child,
    this.dimOpacity = 0.0,
    this.blurAmount = 0.0,
    this.showCozyVignette = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base room image with BoxFit.cover
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.background,
              child: const Center(
                child: Icon(Icons.broken_image_rounded, color: AppColors.primary, size: 48),
              ),
            );
          },
        ),

        // Cozy ambient light vignette / warm gradient
        if (showCozyVignette)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.18),
                ],
              ),
            ),
          ),

        // Optional blur filter (e.g. for modals or menus)
        if (blurAmount > 0)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: const SizedBox.expand(),
          ),

        // Optional dim overlay
        if (dimOpacity > 0)
          Container(
            color: Colors.black.withValues(alpha: dimOpacity),
          ),

        ?child,
      ],
    );
  }
}
