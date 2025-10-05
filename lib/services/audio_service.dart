import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _ambient = AudioPlayer();
  bool _initialized = false;

  Future<void> init() async {
    try {
      await _ambient.setReleaseMode(ReleaseMode.loop);
      await _ambient.setSource(AssetSource('sounds/ambient_loop.mp3'));
      await _ambient.setVolume(0.2);
      await _ambient.resume();
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  Future<void> playTap() async {
    if (!_initialized) return;
    final p = AudioPlayer();
    await p.play(AssetSource('sounds/select_ping.wav'), volume: 0.9);
  }

  Future<void> playClose() async {
    if (!_initialized) return;
    final p = AudioPlayer();
    await p.play(AssetSource('sounds/close_pop.mp3'), volume: 0.9);
  }

  void dispose() {
    _ambient.dispose();
  }
}
