import 'dart:math';
import 'package:flutter/material.dart';
import '../models/planet_data.dart';

class PlanetWidget extends StatelessWidget {
  final Planet planet;
  final double rotation;
  final double zoom;
  final VoidCallback onTap;

  const PlanetWidget({
    super.key,
    required this.planet,
    required this.rotation,
    required this.zoom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height / 2;

    double distance = planet.positionFromSun * 60.0 * zoom;
    double angle = rotation;

    double x = centerX + distance * cos(angle) - planet.radius;
    double y = centerY + distance * sin(angle) - planet.radius;

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: planet.radius * 2,
          height: planet.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: planet.color,
            boxShadow: [
              BoxShadow(
                color: planet.color.withOpacity(0.6),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
