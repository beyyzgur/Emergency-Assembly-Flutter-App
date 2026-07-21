import 'package:latlong2/latlong.dart';

/// Bir nokta poligonun içinde mi? (ray casting algoritması)
/// Haritada bir alana dokunulduğunda hangi poligona denk geldiğini bulmak için.
bool pointInPolygon(LatLng point, List<LatLng> ring) {
  final n = ring.length;
  if (n < 3) return false;

  var inside = false;
  final px = point.longitude, py = point.latitude;
  for (var i = 0, j = n - 1; i < n; j = i++) {
    final xi = ring[i].longitude, yi = ring[i].latitude;
    final xj = ring[j].longitude, yj = ring[j].latitude;
    final intersects =
        ((yi > py) != (yj > py)) &&
        (px < (xj - xi) * (py - yi) / (yj - yi) + xi);
    if (intersects) inside = !inside;
  }
  return inside;
}
