import 'dart:math';

import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  final double baseX;
  final double baseY;
  final double density;

  Particle({
    required this.x,
    required this.y,
    required this.baseX,
    required this.baseY,
    required this.density,
  });

  void update({Offset? dragPosition}) {
    final dx = baseX - x;
    final dy = baseY - y;
    final distance = sqrt(dx * dx + dy * dy);
    final forceDirectionX = dx / distance;
    final forceDirectionY = dy / distance;

    final maxDistance = 280.0;
    final force = (maxDistance - distance) / maxDistance;
    final directionX = forceDirectionX * force * density;
    final directionY = forceDirectionY * force * density;

    if (distance < 30) {
      x += directionX * 0.01;
      y += directionY * 0.01;
    } else if (distance < maxDistance) {
      x += directionX * 2.5;
      y += directionY * 2.5;
    } else {
      if (x != baseX) {
        final dx = x - baseX;
        x -= dx / 10;
      }
      if (y != baseY) {
        final dy = y - baseY;
        y -= dy / 10;
      }
    }

    if (dragPosition != null) {
      final dragDx = x - dragPosition.dx;
      final dragDy = y - dragPosition.dy;
      final dragDistance = sqrt(dragDx * dragDx + dragDy * dragDy);
      final dragForce = (200 - min(dragDistance, 200)) / 200;

      x += dragDx * dragForce * 0.5;
      y += dragDy * dragForce * 0.5;
    }
  }
}
