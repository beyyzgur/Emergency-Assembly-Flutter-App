import 'package:latlong2/latlong.dart';

/// Bir toplanma alanı (GeoJSON'daki bir poligon).
class AssemblyArea {
  final String name; // NAME
  final String type; // ALAN_TUR (OTOPARK, PARK...)
  final int capacity; // Kapasite
  final String district; // ILCE_ADI
  final LatLng center; // poligon centroid'i (clustering için)
  final List<LatLng> ring; // dış sınır (çizim için)

  const AssemblyArea({
    required this.name,
    required this.type,
    required this.capacity,
    required this.district,
    required this.center,
    required this.ring,
  });
}
