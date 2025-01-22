import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HexTile extends PositionComponent {
  final int row;
  final int col;
  bool isSelected = false;
  late Paint _paint;
  late Path _hexPath;

  HexTile({
    required Vector2 position,
    required Vector2 size,
    required this.row,
    required this.col,
  }) : super(position: position, size: size) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.5);

    _hexPath = _createHexPath();
  }

  Path _createHexPath() {
    final path = Path();
    final double radius = size.x / 2;
    final double centerX = radius;
    final double centerY = radius;

    for (int i = 0; i < 6; i++) {
      final double angle = i * math.pi / 3;
      final double x = centerX + radius * math.cos(angle);
      final double y = centerY + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  void render(Canvas canvas) {
    _paint.color =
        isSelected ? Colors.red.withOpacity(0.7) : Colors.blue.withOpacity(0.5);
    canvas.drawPath(_hexPath, _paint);

    // Dessiner la bordure
    canvas.drawPath(
      _hexPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black
        ..strokeWidth = 2.0,
    );
  }

  void toggleSelection() {
    isSelected = !isSelected;
  }

  bool containsPoint(Vector2 point) {
    final localPoint = point - position;
    return _hexPath.contains(Offset(localPoint.x, localPoint.y));
  }
}
