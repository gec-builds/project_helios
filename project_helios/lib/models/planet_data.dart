import 'package:flutter/material.dart';

class Planet {
  final String name;
  final int positionFromSun;
  final double radius;
  final Color color;
  final String distanceFromSun;
  final String yearLength;
  final String description;
  final String flareEffectDescription;
  final bool hasMagneticField;
  final String textureAsset;

  Planet({
    required this.name,
    required this.positionFromSun,
    required this.radius,
    required this.color,
    required this.distanceFromSun,
    required this.yearLength,
    required this.description,
    required this.flareEffectDescription,
    required this.hasMagneticField,
    required this.textureAsset,
  });
}

final List<Planet> planets = [
  Planet(
    name: "Mercury",
    positionFromSun: 1,
    radius: 12,
    color: Colors.grey,
    distanceFromSun: "57.9 million km",
    yearLength: "88 Earth days",
    description: "Mercury is the smallest planet and closest to the Sun.",
    flareEffectDescription: "Solar flares cause intense radiation storms here!",
    hasMagneticField: false,
    textureAsset: "assets/images/mercury.png",
  ),
  Planet(
    name: "Earth",
    positionFromSun: 3,
    radius: 25,
    color: Colors.blue,
    distanceFromSun: "149.6 million km",
    yearLength: "365 days",
    description: "Earth is our home and the only known planet with life.",
    flareEffectDescription: "Solar flares create beautiful auroras!",
    hasMagneticField: true,
    textureAsset: "assets/images/earth.png",
  ),
];
