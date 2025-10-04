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
