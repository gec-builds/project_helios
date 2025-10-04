import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/planet_data.dart';

class PlanetDetailsPanel extends StatelessWidget {
  final Planet planet;
  const PlanetDetailsPanel({super.key, required this.planet});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.white.withOpacity(0.08),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(planet.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(planet.description),
                  const SizedBox(height: 8),
                  Text("Distance from Sun: ${planet.distanceFromSun}"),
                  Text("Year Length: ${planet.yearLength}"),
                  const SizedBox(height: 8),
                  Text(planet.flareEffectDescription, style: const TextStyle(color: Colors.orangeAccent)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
