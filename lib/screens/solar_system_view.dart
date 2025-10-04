import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/planet_data.dart';
import '../widgets/planet_widget.dart';
import '../widgets/planet_details_panel.dart';
import '../widgets/solar_flare_widget.dart';
import '../widgets/starfield_widget.dart';
import '../widgets/comet_widget.dart';

class SolarSystemProvider extends ChangeNotifier {
  Planet? selectedPlanet;
  bool flareActive = false;

void selectPlanet(Planet? p) {
  selectedPlanet = p;
  notifyListeners();
}


  void triggerFlare() {
    flareActive = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      flareActive = false;
      notifyListeners();
    });
  }
}

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

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double rotationAngle(Planet planet) {
    return _controller.value * 2 * pi / (planet.positionFromSun + 1) +
        dragRotation;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SolarSystemProvider(),
      child: Consumer<SolarSystemProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  zoom = (zoom * details.scale).clamp(0.5, 2.0);
                  dragRotation += details.focalPointDelta.dx * 0.01;
                });
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Stack(
                    children: [
                      StarfieldWidget(rotation: dragRotation, zoom: zoom),
                      // Sun pulsation
                      Center(
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (_, __) {
                            double sunRadius =
                                38 + sin(_controller.value * 2 * pi) * 4;
                            return Container(
                              width: sunRadius * 2,
                              height: sunRadius * 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.orangeAccent,
                                    Colors.deepOrange.withOpacity(0.7)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Planets
                      ...planets
                          .where((p) => p.name != "Sun")
                          .map((p) => PlanetWidget(
                                planet: p,
                                rotation: rotationAngle(p),
                                zoom: zoom,
                                onTap: () => provider.selectPlanet(p),
                              )),
                      // Comet
                      CometWidget(zoom: zoom),
                      // Solar flare
                      if (provider.flareActive)
                        SolarFlareWidget(zoom: zoom, planets: planets),
                      // Planet info panel
                      if (provider.selectedPlanet != null)
                        PlanetDetailsPanel(
                          planet: provider.selectedPlanet!,
                          onClose: () => provider.selectPlanet(null),
                        ),
                      // Flare button
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: FloatingActionButton(
                          backgroundColor: Colors.orangeAccent,
                          onPressed: provider.triggerFlare,
                          child: const Icon(Icons.wb_sunny),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
