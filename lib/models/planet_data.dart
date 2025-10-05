import 'package:flutter/material.dart';

class Planet {
  final String name;
  final double radius;
  final int positionFromSun;
  final String description;
  final String distanceFromSun;
  final String yearLength;
  final bool hasMagneticField;
  final String flareEffectDescription;
  final Color color;
  final String textureAsset;

  const Planet({
    required this.name,
    required this.radius,
    required this.positionFromSun,
    required this.description,
    required this.distanceFromSun,
    required this.yearLength,
    required this.hasMagneticField,
    required this.flareEffectDescription,
    required this.color,
    required this.textureAsset,
  });
}

const List<Planet> planets = [
  Planet(
    name: "Sun",
    radius: 50,
    positionFromSun: 0,
    description: "The star at the center of the Solar System.",
    distanceFromSun: "0 km",
    yearLength: "-",
    hasMagneticField: true,
    flareEffectDescription: "Produces solar flares that affect all planets.",
    color: Colors.orange,
    textureAsset: "assets/textures/sun.jpg",
  ),
  Planet(
    name: "Mercury",
    radius: 10,
    positionFromSun: 1,
    description: "Smallest planet, closest to the Sun.",
    distanceFromSun: "57.9M km",
    yearLength: "88 days",
    hasMagneticField: false,
    flareEffectDescription: "Solar flares heat the thin exosphere.",
    color: Colors.grey,
    textureAsset: "assets/textures/mercury.jpg",
  ),
  Planet(
    name: "Venus",
    radius: 14,
    positionFromSun: 2,
    description: "Thick atmosphere, hottest planet.",
    distanceFromSun: "108.2M km",
    yearLength: "225 days",
    hasMagneticField: false,
    flareEffectDescription: "Clouds glow faintly during solar activity.",
    color: Colors.amber,
    textureAsset: "assets/textures/venus.jpg",
  ),
  Planet(
    name: "Earth",
    radius: 16,
    positionFromSun: 3,
    description: "Our home world, with water and life.",
    distanceFromSun: "149.6M km",
    yearLength: "365 days",
    hasMagneticField: true,
    flareEffectDescription: "Auroras intensify during solar storms.",
    color: Colors.blue,
    textureAsset: "assets/textures/earth.jpg",
  ),
  Planet(
    name: "Mars",
    radius: 12,
    positionFromSun: 4,
    description: "The red planet with canyons and volcanoes.",
    distanceFromSun: "227.9M km",
    yearLength: "687 days",
    hasMagneticField: false,
    flareEffectDescription: "Dust storms increase during solar winds.",
    color: Colors.red,
    textureAsset: "assets/textures/mars.jpg",
  ),
  Planet(
    name: "Jupiter",
    radius: 28,
    positionFromSun: 5,
    description: "Gas giant with a giant red storm",
    distanceFromSun: "778.5M km",
    yearLength: "12 years",
    hasMagneticField: true,
    flareEffectDescription: "Auroras at poles grow stronger.",
    color: Colors.brown,
    textureAsset: "assets/textures/jupiter.jpg",
  ),
  Planet(
    name: "Saturn",
    radius: 26,
    positionFromSun: 6,
    description: "Gas giant famous for its rings.",
    distanceFromSun: "1.4B km",
    yearLength: "29 years",
    hasMagneticField: true,
    flareEffectDescription: "Ring particles sparkle faintly.",
    color: Colors.yellow,
    textureAsset: "assets/textures/saturn.jpg",
  ),
  Planet(
    name: "Uranus",
    radius: 22,
    positionFromSun: 7,
    description: "Ice giant with tilted axis.",
    distanceFromSun: "2.9B km",
    yearLength: "84 years",
    hasMagneticField: true,
    flareEffectDescription: "Auroras shift sideways due to tilt.",
    color: Colors.cyan,
    textureAsset: "assets/textures/uranus.jpg",
  ),
  Planet(
    name: "Neptune",
    radius: 22,
    positionFromSun: 8,
    description: "Ice giant with strong winds.",
    distanceFromSun: "4.5B km",
    yearLength: "165 years",
    hasMagneticField: true,
    flareEffectDescription: "Dark spots intensify during flares.",
    color: Colors.blueAccent,
    textureAsset: "assets/textures/neptune.jpg",
  ),
];
