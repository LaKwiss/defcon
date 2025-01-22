import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final int population;
  final Map<String, int> influence;
  final Map<String, int> resources;

  const City({
    required this.name,
    required this.population,
    required this.influence,
    required this.resources,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      population: json['population'],
      influence: Map<String, int>.from(json['influence']),
      resources: Map<String, int>.from(json['resources']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'population': population,
      'influence': influence,
      'resources': resources,
    };
  }

  @override
  List<Object?> get props => [name, population, influence, resources];
}
