// lib/widgets/comet_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';

class CometWidget extends StatefulWidget {
  final double zoom;
  const CometWidget({super.key, required this.zoom});

  @override
  State<CometWidget> createState() => _CometWidgetState();
}

class _CometWidgetState extends State<CometWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _startY;
  late double _durationSeconds;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    // random start Y and duration so multiple runs feel organic
    _startY = 80.0 + _rand.nextDouble() * 300.0;
    _durationSeconds = 3.5 + _rand.nextDouble() * 3.0;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_durationSeconds * 1000).toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double startX = -120.0;
    final double endX = size.width + 120.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value;
        final x = startX + (endX - startX) * t;
        final y = (_startY + sin(t * pi * 2) * 18.0) * widget.zoom;

        return Positioned(
          left: x * widget.zoom,
          top: y,
          child: Opacity(
            opacity: (1.0 - (t * 0.85)).clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: -0.6,
              child: Container(
                width: 10 * widget.zoom,
                height: 6 * widget.zoom,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.3)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.45),
                      blurRadius: 10 * widget.zoom,
                      spreadRadius: 1 * widget.zoom,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
