import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/solar_system_view.dart';
import 'providers/solar_system_provider.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audio = AudioService();
  await audio.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SolarSystemProvider()),
        Provider<AudioService>.value(value: audio),
      ],
      child: const ProjectHeliosApp(),
    ),
  );
}

class ProjectHeliosApp extends StatelessWidget {
  const ProjectHeliosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Helios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF05060A),
      ),
      home: const SolarSystemView(),
    );
  }
}
