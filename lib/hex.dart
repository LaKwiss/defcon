import 'package:defcon/city.dart';
import 'package:equatable/equatable.dart';

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
}
