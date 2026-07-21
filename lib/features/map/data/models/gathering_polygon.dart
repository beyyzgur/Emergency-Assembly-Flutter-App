import 'package:latlong2/latlong.dart';

class GatheringPolygon {
  final int id;
  final String name;
  final int population; // Verideki "Kapasite" alanını temsil eder
  final double areaM2; // Verideki "Alan_m2" alanını temsil eder
  final List<LatLng> coordinates;
  final LatLng centroid;

  GatheringPolygon({
    required this.id,
    required this.name,
    required this.population,
    required this.areaM2,
    required this.coordinates,
    required this.centroid,
  });

  factory GatheringPolygon.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'];
    final geometry = json['geometry'];

    final List rawCoords = geometry['coordinates'][0][0];
    final List<LatLng> parsedCoords = rawCoords
        .map((c) => LatLng(c[1], c[0]))
        .toList();

    double sumLat = 0;
    double sumLng = 0;
    for (var coord in parsedCoords) {
      sumLat += coord.latitude;
      sumLng += coord.longitude;
    }
    final center = LatLng(
      sumLat / parsedCoords.length,
      sumLng / parsedCoords.length,
    );

    return GatheringPolygon(
      id: properties['ID'] ?? properties['POI_ID'] ?? 0,
      name: properties['NAME'] ?? 'İsimsiz Alan',
      population: properties['Kapasite'] ?? 0,
      areaM2: (properties['Alan_m2'] ?? 0).toDouble(),
      coordinates: parsedCoords,
      centroid: center,
    );
  }
}
