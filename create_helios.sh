#!/bin/zsh

# Create Flutter project
flutter create project_helios
cd project_helios || exit

# Remove default lib folder and create structured folders
rm -rf lib
mkdir -p lib/models lib/providers lib/screens lib/widgets assets/images assets/sounds

# =========================
# main.dart
# =========================
cat << 'EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/solar_system_provider.dart';
import 'screens/solar_system_view.dart';

void main() {
  runApp(const ProjectHeliosApp());
}

class ProjectHeliosApp extends StatelessWidget {
  const ProjectHeliosApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SolarSystemProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Project Helios",
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        ),
        home: const SolarSystemView(),
      ),
    );
  }
}
EOF

# =========================
# planet_data.dart
# =========================
cat << 'EOF' > lib/models/planet_data.dart
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
EOF

# =========================
# solar_system_provider.dart
# =========================
cat << 'EOF' > lib/providers/solar_system_provider.dart
import 'package:flutter/material.dart';
import '../models/planet_data.dart';

class SolarSystemProvider extends ChangeNotifier {
  Planet? selectedPlanet;
  bool flareActive = false;

  void selectPlanet(Planet? planet) {
    selectedPlanet = planet;
    notifyListeners();
  }

  void triggerFlare() {
    flareActive = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 6), () {
      flareActive = false;
      notifyListeners();
    });
  }
}
EOF

# =========================
# solar_system_view.dart
# =========================
cat << 'EOF' > lib/screens/solar_system_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/solar_system_provider.dart';
import '../models/planet_data.dart';
import '../widgets/planet_widget.dart';
import '../widgets/solar_flare_widget.dart';
import '../widgets/planet_details_panel.dart';

class SolarSystemView extends StatefulWidget {
  const SolarSystemView({super.key});
  @override
  State<SolarSystemView> createState() => _SolarSystemViewState();
}

class _SolarSystemViewState extends State<SolarSystemView> with SingleTickerProviderStateMixin {
  double rotation = 0.0;
  double zoom = 1.0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SolarSystemProvider>(context);
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (d) => setState(() => rotation += d.delta.dx * 0.01),
        onScaleUpdate: (d) => setState(() => zoom = d.scale.clamp(0.6, 1.6)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ...planets.map((p) => PlanetWidget(
                  planet: p,
                  rotation: rotation,
                  zoom: zoom,
                  onTap: () => provider.selectPlanet(p),
                )),
            const SolarFlareWidget(),
            if (provider.selectedPlanet != null)
              PlanetDetailsPanel(planet: provider.selectedPlanet!),
            Positioned(
              bottom: 60,
              child: ElevatedButton(
                onPressed: provider.triggerFlare,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent.withOpacity(0.8),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14)),
                child: const Text("Launch Solar Flare"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
EOF

# =========================
# planet_widget.dart
# =========================
cat << 'EOF' > lib/widgets/planet_widget.dart
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
EOF

# =========================
# solar_flare_widget.dart
# =========================
cat << 'EOF' > lib/widgets/solar_flare_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/solar_system_provider.dart';

class SolarFlareWidget extends StatefulWidget {
  const SolarFlareWidget({super.key});
  @override
  State<SolarFlareWidget> createState() => _SolarFlareWidgetState();
}

class _SolarFlareWidgetState extends State<SolarFlareWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> radius;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    radius = Tween(begin: 0.0, end: 600.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flareActive = context.watch<SolarSystemProvider>().flareActive;
    if (flareActive) controller.forward(from: 0);
    return AnimatedBuilder(
      animation: radius,
      builder: (context, _) {
        return CustomPaint(
          painter: _FlarePainter(radius.value),
        );
      },
    );
  }
}

class _FlarePainter extends CustomPainter {
  final double radius;
  _FlarePainter(this.radius);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.orange.withOpacity(0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _FlarePainter old) => true;
}
EOF

# =========================
# planet_details_panel.dart
# =========================
cat << 'EOF' > lib/widgets/planet_details_panel.dart
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
EOF

echo "✅ Project Helios setup complete! Run 'flutter pub get' and then 'flutter run' to start the app."

