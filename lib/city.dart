class City {
  final String name;
  final int population;
  final Map<String, int> influence;
  final Map<String, int> resources;

  City({
    required this.name,
    required this.population,
    required this.influence,
    required this.resources,
  });
}
