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
  });
}

final List<Planet> planets = [
  Planet(
    name: "Sun",
    positionFromSun: 0,
    radius: 40,
    color: Colors.orangeAccent,
    distanceFromSun: "0 km",
    yearLength: "N/A",
    description: "The Sun is the star at the center of our Solar System.",
    flareEffectDescription: "Solar flares originate here!",
    hasMagneticField: true,
  ),
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
  ),
  Planet(
    name: "Venus",
    positionFromSun: 2,
    radius: 20,
    color: Colors.yellowAccent,
    distanceFromSun: "108.2 million km",
    yearLength: "225 Earth days",
    description: "Venus is covered in thick clouds and very hot.",
    flareEffectDescription: "Solar flares can increase radiation in its atmosphere.",
    hasMagneticField: false,
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
  ),
  Planet(
    name: "Mars",
    positionFromSun: 4,
    radius: 18,
    color: Colors.red,
    distanceFromSun: "227.9 million km",
    yearLength: "687 Earth days",
    description: "Mars is known as the Red Planet and has the tallest volcano.",
    flareEffectDescription: "Solar flares can affect its thin atmosphere.",
    hasMagneticField: false,
  ),
  Planet(
    name: "Jupiter",
    positionFromSun: 5,
    radius: 35,
    color: Colors.brown,
    distanceFromSun: "778.5 million km",
    yearLength: "12 Earth years",
    description: "Jupiter is the largest planet with a giant storm called the Great Red Spot.",
    flareEffectDescription: "Its strong magnetic field protects it from solar flares.",
    hasMagneticField: true,
  ),
  Planet(
    name: "Saturn",
    positionFromSun: 6,
    radius: 30,
    color: Colors.amber,
    distanceFromSun: "1.43 billion km",
    yearLength: "29 Earth years",
    description: "Saturn is famous for its beautiful rings.",
    flareEffectDescription: "Solar flares are deflected by its magnetic field.",
    hasMagneticField: true,
  ),
  Planet(
    name: "Uranus",
    positionFromSun: 7,
    radius: 28,
    color: Colors.lightBlueAccent,
    distanceFromSun: "2.87 billion km",
    yearLength: "84 Earth years",
    description: "Uranus rotates on its side and is very cold.",
    flareEffectDescription: "Solar flares slightly interact with its magnetic field.",
    hasMagneticField: true,
  ),
  Planet(
    name: "Neptune",
    positionFromSun: 8,
    radius: 27,
    color: Colors.blueAccent,
    distanceFromSun: "4.5 billion km",
    yearLength: "165 Earth years",
    description: "Neptune is very windy and farthest from the Sun.",
    flareEffectDescription: "Solar flares have minimal effect here.",
    hasMagneticField: true,
  ),
];
