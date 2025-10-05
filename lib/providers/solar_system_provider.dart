import 'package:flutter/foundation.dart';
import '../models/planet_data.dart';

class SolarSystemProvider extends ChangeNotifier {
  Planet? _selectedPlanet;
  bool _flareActive = false;

  Planet? get selectedPlanet => _selectedPlanet;
  bool get flareActive => _flareActive;

  void selectPlanet(Planet? p) {
    _selectedPlanet = p;
    notifyListeners();
  }

  void triggerFlare() {
    _flareActive = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      _flareActive = false;
      notifyListeners();
    });
  }
}
