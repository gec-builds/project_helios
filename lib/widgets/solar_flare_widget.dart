import 'package:flutter/material.dart';
import '../models/planet_data.dart';

class SolarFlareWidget extends StatelessWidget {
  final double zoom;
  final List<Planet> planets;
  const SolarFlareWidget({super.key, required this.zoom, required this.planets});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.orange.withOpacity(0.3),
                Colors.transparent,
              ],
              radius: 1.0 * zoom,
            ),
          ),
        ),
      ),
    );
  }
}
