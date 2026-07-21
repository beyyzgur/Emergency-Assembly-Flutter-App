import 'package:latlong2/latlong.dart';

/// Haritada çizilecek rota ve rotaya ait özet bilgiler.
class RouteResult {
  const RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  /// `flutter_map` içindeki [Polyline] için doğrudan kullanılabilecek yol çizgisi.
  final List<LatLng> points;

  /// Rota boyunca toplam mesafe.
  final double distanceMeters;

  /// Rota boyunca tahmini toplam süre.
  final double durationSeconds;
}
