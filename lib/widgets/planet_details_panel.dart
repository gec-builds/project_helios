// lib/widgets/planet_details_panel.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/planet_data.dart';

class PlanetDetailsPanel extends StatelessWidget {
  final Planet planet;
  final VoidCallback onClose;
  const PlanetDetailsPanel({super.key, required this.planet, required this.onClose});

  @override
  Widget build(BuildContext context) {
    // Fallback: center-screen large panel if anchor positioning not used
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.04),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 18)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(width:72, height:72, decoration: BoxDecoration(shape:BoxShape.circle, color: planet.color)),
                  const SizedBox(width:12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(planet.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height:6),
                    Text("${planet.distanceFromSun} • ${planet.yearLength}", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  ])),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white70))
                ]),
                const SizedBox(height:12),
                Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("About", style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
                  const SizedBox(height:6),
                  Text(planet.description, style: TextStyle(color: Colors.white.withOpacity(0.95))),
                  const SizedBox(height:12),
                  Text("Solar Flare Effects", style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
                  const SizedBox(height:6),
                  Text(planet.flareEffectDescription, style: TextStyle(color: Colors.white.withOpacity(0.9))),
                ]))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
