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
