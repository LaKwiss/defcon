import 'package:defcon/city.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Hex extends Equatable {
  final String id;
  final int q;
  final int r;
  final int s;
  final String type;
  final List<String> connections;
  final City? city;

  const Hex(
    this.city, {
    required this.id,
    required this.q,
    required this.r,
    required this.s,
    required this.type,
    required this.connections,
  });

  factory Hex.fromJson(Map<String, dynamic> json) {
    return Hex(
      json['city'] != null ? City.fromJson(json['city']) : null,
      id: json['id'],
      q: json['q'],
      r: json['r'],
      s: json['s'],
      type: json['type'],
      connections: List<String>.from(json['connections']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'q': q,
      'r': r,
      's': s,
      'type': type,
      'connections': connections,
      'city': city?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, q, r, s, type, connections, city];

  Widget toWidget(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HexPainter(
          color: Colors.blue,
          strokeColor: Colors.black54,
          strokeWidth: 1.0,
        ),
        child: city != null
            ? Center(
                child: Icon(
                  Icons.location_city,
                  color: Colors.white,
                  size: size * 0.5,
                ),
              )
            : null,
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  final Color color;
  final Color strokeColor;
  final double strokeWidth;

  _HexPainter({
    required this.color,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.25, 0);
    path.lineTo(w * 0.75, 0);
    path.lineTo(w, h * 0.5);
    path.lineTo(w * 0.75, h);
    path.lineTo(w * 0.25, h);
    path.lineTo(0, h * 0.5);
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    paint
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
