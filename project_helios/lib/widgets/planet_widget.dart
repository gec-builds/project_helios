import 'package:flutter/material.dart';
import '../models/planet_data.dart';
import 'dart:math';

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
    final orbitRadius = 100.0 * planet.positionFromSun * zoom;
    final angle = rotation + planet.positionFromSun * 0.8;
    final x = orbitRadius * (1.2 * cos(angle));
    final y = orbitRadius * (0.6 * sin(angle));

    return Positioned(
      left: MediaQuery.of(context).size.width / 2 + x,
      top: MediaQuery.of(context).size.height / 2 + y,
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: planet.radius * zoom,
          backgroundColor: planet.color,
          backgroundImage: AssetImage(planet.textureAsset),
        ),
      ),
    );
  }
}
