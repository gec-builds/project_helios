// lib/widgets/planet_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/planet_data.dart';

class PlanetWidget extends StatelessWidget {
  final Planet planet;
  final double rotation; // angle used for orbit position (not used for layout here)
  final double zoom;
  final double sceneRotation; // small scene tilt input for parallax
  final VoidCallback onTap;

  const PlanetWidget({
    super.key,
    required this.planet,
    required this.rotation,
    required this.zoom,
    required this.sceneRotation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // small tilt derived from sceneRotation (kept tiny so it feels natural)
    final double tilt = (sceneRotation * 0.05).clamp(-0.3, 0.3);

    final Matrix4 matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateX(tilt)
      ..rotateY(-tilt / 2);

    final double size = planet.radius * 2 * zoom;
    final double inner = planet.radius * 1.1 * zoom;

    return Transform(
      transform: matrix,
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.2, -0.2),
              radius: 0.9,
              colors: [
                planet.color.withOpacity(0.98),
                planet.color.withOpacity(0.75),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: planet.color.withOpacity(0.34),
                blurRadius: 12 * zoom,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 8 * zoom,
                offset: Offset(0, 4 * zoom),
              ),
            ],
          ),
          child: Center(
            // small inner sheen to give a 3D look
            child: Container(
              width: inner,
              height: inner,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.02),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
