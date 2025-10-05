// lib/screens/solar_system_view.dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/planet_data.dart';
import '../widgets/planet_widget.dart';
import '../widgets/solar_flare_widget.dart';
import '../widgets/starfield_widget.dart';
import '../widgets/comet_widget.dart';
import '../providers/solar_system_provider.dart';

class SolarSystemView extends StatefulWidget {
  const SolarSystemView({super.key});

  @override
  State<SolarSystemView> createState() => _SolarSystemViewState();
}

class _SolarSystemViewState extends State<SolarSystemView>
    with SingleTickerProviderStateMixin {
  double zoom = 1.0;
  double dragRotation = 0.0;
  late AnimationController _controller;
  Offset pointerOffset = Offset.zero;

  // flare shake controller
  bool isShaking = false;
  late AudioPlayer audioPlayer;

  late Map<int, double> orbitOffsets;
  late Map<int, double> orbitSpeeds;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..repeat();

    final random = Random();

    orbitOffsets = {
      for (var p in planets) p.positionFromSun: random.nextDouble() * 2 * pi,
    };

    orbitSpeeds = {
      for (var p in planets) p.positionFromSun: 0.6 / (p.positionFromSun + 0.8),
    };

    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  double rotationAngle(Planet planet) {
    final speed = orbitSpeeds[planet.positionFromSun] ?? 0.2;
    final offset = orbitOffsets[planet.positionFromSun] ?? 0.0;
    final time = _controller.lastElapsedDuration?.inMilliseconds ?? 0;
    return (time * 0.0005 * speed) + dragRotation + offset;
  }

  Offset planetOffset(Planet p, Offset center, double angle, double baseOrbit) {
    final orbitR = (baseOrbit + 60.0 * p.positionFromSun) * zoom;

    // Random shake offset if flare is active
    double shakeX = 0;
    double shakeY = 0;
    if (isShaking) {
      final rand = Random();
      shakeX = (rand.nextDouble() - 0.5) * 8; // subtle shake
      shakeY = (rand.nextDouble() - 0.5) * 8;
    }

    final x = center.dx + orbitR * cos(angle) + shakeX;
    final y = center.dy + orbitR * sin(angle) * 0.6 + shakeY;
    return Offset(x - p.radius, y - p.radius);
  }

  Future<void> triggerSolarFlare(SolarSystemProvider provider) async {
    provider.triggerFlare();

    // vibration (if supported)
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100, amplitude: 50);
    }

    // play sound
    await audioPlayer.play(AssetSource('sounds/flare.mp3'));

    // start shaking effect
    setState(() => isShaking = true);

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => isShaking = false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SolarSystemProvider(),
      child: Consumer<SolarSystemProvider>(
        builder: (context, provider, _) {
          final size = MediaQuery.of(context).size;
          final center = Offset(size.width / 2, size.height / 2);
          final baseOrbit = min(size.width, size.height) * 0.12;

          return Scaffold(
            backgroundColor: const Color(0xFF05060A),
            body: Listener(
              onPointerHover: (event) =>
                  setState(() => pointerOffset = event.localPosition),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (provider.selectedPlanet != null) {
                    provider.selectPlanet(null);
                  }
                },
                onScaleUpdate: (details) {
                  setState(() {
                    zoom = (zoom * details.scale).clamp(0.5, 2.0);
                    dragRotation += details.focalPointDelta.dx * 0.01;
                  });
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final Map<Planet, Offset> planetPositions = {};
                    for (var p in planets) {
                      if (p.positionFromSun == 0) continue;
                      final angle = rotationAngle(p);
                      final pos = planetOffset(p, center, angle, baseOrbit);
                      planetPositions[p] = pos;
                    }

                    return Stack(
                      children: [
                        StarfieldWidget(rotation: dragRotation, zoom: zoom),

                        Positioned.fill(
                          child: CustomPaint(
                            painter: OrbitPainter(
                              center: center,
                              baseOrbit: baseOrbit * zoom,
                              maxIndex: planets
                                  .map((p) => p.positionFromSun)
                                  .fold<int>(0, (prev, e) => max(prev, e)),
                              t: (_controller.lastElapsedDuration
                                          ?.inMilliseconds ??
                                      0) /
                                  60000.0,
                            ),
                          ),
                        ),

                        // Static Sun
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Colors.orangeAccent,
                                  Colors.deepOrange,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orangeAccent.withOpacity(0.18),
                                  blurRadius: 30,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // planets
                        for (var p in planets)
                          if (p.positionFromSun != 0)
                            Positioned(
                              left: planetPositions[p]!.dx,
                              top: planetPositions[p]!.dy,
                              child: PlanetWidget(
                                planet: p,
                                rotation: rotationAngle(p),
                                zoom: zoom,
                                sceneRotation: dragRotation,
                                onTap: () {
                                  provider.selectPlanet(p);
                                },
                              ),
                            ),

                        // comet
                        CometWidget(zoom: zoom),

                        // solar flare visual effect
                        if (provider.flareActive)
                          SolarFlareWidget(zoom: zoom, planets: planets),

                        // floating info card
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: provider.selectedPlanet != null
                              ? _buildFloatingInfoCard(
                                  provider.selectedPlanet!,
                                  planetPositions[provider.selectedPlanet!] ??
                                      Offset(center.dx, center.dy),
                                  provider,
                                )
                              : const SizedBox.shrink(),
                        ),

                        // flare trigger button
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: FloatingActionButton(
                            backgroundColor: Colors.orangeAccent,
                            onPressed: () => triggerSolarFlare(provider),
                            child: const Icon(Icons.wb_sunny),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingInfoCard(
      Planet p, Offset planetTopLeft, SolarSystemProvider provider) {
    final cardBase = planetTopLeft + Offset(p.radius, -p.radius * 2.2);
    final screen = MediaQuery.of(context).size;
    final clampX = cardBase.dx.clamp(12.0, screen.width - 300.0);
    final clampY = cardBase.dy.clamp(60.0, screen.height - 320.0);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 420),
      curve: Curves.elasticOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, t, child) {
        final safeT = t.clamp(0.0, 1.0);
        final dx = (pointerOffset.dx - screen.width / 2) / screen.width;
        final dy = (pointerOffset.dy - screen.height / 2) / screen.height;
        final tiltX = (dy * 0.3).clamp(-0.3, 0.3);
        final tiltY = (dx * -0.3).clamp(-0.3, 0.3);

        final matrix = Matrix4.identity()
          ..translate(clampX, clampY, 0)
          ..translate(0.0, 0.0, (1 - safeT) * -30)
          ..rotateX(tiltX)
          ..rotateY(tiltY)
          ..scale(safeT, safeT, 1.0);

        return Opacity(
          opacity: safeT,
          child: Transform(
            transform: matrix,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: 280,
        child: _FloatingPlanetCard(
          planet: p,
          onClose: () => provider.selectPlanet(null),
        ),
      ),
    );
  }
}

// Orbit Painter (same as before)
class OrbitPainter extends CustomPainter {
  final Offset center;
  final double baseOrbit;
  final int maxIndex;
  final double t;

  OrbitPainter({
    required this.center,
    required this.baseOrbit,
    required this.maxIndex,
    required this.t,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i <= maxIndex; i++) {
      final r = baseOrbit + 60.0 * i;
      final rect =
          Rect.fromCenter(center: center, width: r * 2, height: r * 2 * 0.6);

      final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: 2 * pi,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          stops: [
            (t + 0.0) % 1,
            (t + 0.1) % 1,
            (t + 2.0) % 1,
          ],
          transform: GradientRotation(2 * pi * t),
        ).createShader(rect);

      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _FloatingPlanetCard extends StatelessWidget {
  final Planet planet;
  final VoidCallback onClose;
  const _FloatingPlanetCard(
      {Key? key, required this.planet, required this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                planet.color.withOpacity(0.25),
                Colors.black.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1.2, color: planet.color.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: planet.color.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: planet.color,
                      boxShadow: [
                        BoxShadow(
                          color: planet.color.withOpacity(0.25),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planet.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${planet.distanceFromSun} • ${planet.yearLength}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                planet.description,
                style: const TextStyle(fontSize: 13, height: 1.35),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Chip(
                    label: Text(
                      planet.hasMagneticField
                          ? "Has Magnetic Field."
                          : "No Magnetic Field",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      planet.flareEffectDescription,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
