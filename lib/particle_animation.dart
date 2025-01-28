import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_particle_animation/particle.dart';

class ParticleAnimation extends StatefulWidget {
  final String text;

  ParticleAnimation({required this.text});

  @override
  _ParticleAnimationState createState() => _ParticleAnimationState();
}

class _ParticleAnimationState extends State<ParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final int particleCount = 4000;
  Offset? dragPosition;
  Size size = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 26), // ~60 FPS
    )..addListener(() {
        setState(() {
          updateParticles();
        });
      });
    _controller.repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        size = context.size!;
        createParticles();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void createParticles() async {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: TextStyle(
          fontSize: 100,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    textPainter.paint(canvas, Offset.zero);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
        textPainter.width.toInt(), textPainter.height.toInt());
    final byteData = await image.toByteData(format: ImageByteFormat.rawRgba);

    if (byteData == null) return;

    final width = textPainter.width;
    final height = textPainter.height;
    final offsetX = (size.width - width) / 2;
    final offsetY = (size.height - height) / 2;

    particles = List.generate(particleCount, (_) {
      int x, y;
      do {
        x = Random().nextInt(width.toInt());
        y = Random().nextInt(height.toInt());
      } while (byteData.getUint8((y * width.toInt() + x) * 4 + 3) < 128);

      return Particle(
        x: Random().nextDouble() * size.width * 2 - size.width,
        y: Random().nextDouble() * size.height * 2,
        baseX: x + offsetX,
        baseY: y + offsetY,
        density: Random().nextDouble() * 15 + 5,
      );
    });
  }

  void updateParticles() {
    for (var particle in particles) {
      particle.update(dragPosition: dragPosition);
    }
  }

  void triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          dragPosition = details.localPosition;
          triggerHapticFeedback();
        });
      },
      onPanEnd: (_) {
        setState(() {
          dragPosition = null;
        });
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: ParticlePainter(particles: particles),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      canvas.drawCircle(Offset(particle.x, particle.y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
