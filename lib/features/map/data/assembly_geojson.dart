import 'dart:convert';
import 'package:latlong2/latlong.dart';
import '../domain/assembly_area.dart';

/// GeoJSON metnini AssemblyArea listesine çevirir.
/// Top-level fonksiyon → compute() ile arka isolate'te çalıştırılabilir
/// (9063 poligonu ana thread'i dondurmadan parse etmek için).
List<AssemblyArea> parseAssemblyGeoJson(String raw) {
  final data = jsonDecode(raw) as Map<String, dynamic>;
  final features = data['features'] as List;
  final result = <AssemblyArea>[];

  for (final f in features) {
    final geom = f['geometry'] as Map<String, dynamic>?;
    if (geom == null || geom['type'] != 'Polygon') continue;

    final coords = geom['coordinates'] as List;
    if (coords.isEmpty) continue;
    final exterior = coords.first as List; // [[lng, lat], ...]

    final ring = <LatLng>[];
    double sumLat = 0, sumLng = 0;
    for (final c in exterior) {
      final lng = (c[0] as num).toDouble();
      final lat = (c[1] as num).toDouble();
      ring.add(LatLng(lat, lng)); // GeoJSON [lng,lat] → LatLng(lat,lng)
      sumLat += lat;
      sumLng += lng;
    }
    if (ring.isEmpty) continue;

    final props = (f['properties'] as Map<String, dynamic>?) ?? const {};
    final name = (props['NAME'] as String?)?.trim();
    result.add(
      AssemblyArea(
        name: (name != null && name.isNotEmpty) ? name : 'İsimsiz Alan',
        type: (props['ALAN_TUR'] as String?) ?? '',
        capacity: (props['Kapasite'] as num?)?.toInt() ?? 0,
        district: (props['ILCE_ADI'] as String?) ?? '',
        center: LatLng(sumLat / ring.length, sumLng / ring.length),
        ring: ring,
      ),
    );
  }
  return result;
}
