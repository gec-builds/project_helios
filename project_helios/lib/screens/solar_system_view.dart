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
