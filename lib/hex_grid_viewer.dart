import 'dart:math';

import 'package:flutter/material.dart';
import 'hex.dart';

class HexGridViewer extends StatelessWidget {
  final List<Hex> hexagons;
  final double hexSize;

  const HexGridViewer({
    super.key,
    required this.hexagons,
    this.hexSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.1,
      maxScale: 5.0,
      child: Stack(
        children: hexagons.map((hex) {
          final x = hexSize * (3 / 2 * hex.q);
          final y = hexSize * (sqrt(3) / 2 * hex.q + sqrt(3) * hex.r);

          return Positioned(
            left: x,
            top: y,
            child: hex.toWidget(hexSize),
          );
        }).toList(),
      ),
    );
  }
}
