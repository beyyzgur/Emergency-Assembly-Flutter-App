import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:emergency_assembly_app/features/map/data/route_service.dart';

void main() {
  const service = RouteService();

  test('yerel fallback iki uç noktayı çizilebilir rota olarak döndürür', () {
    const from = LatLng(0, 0);
    const to = LatLng(0, 1);

    final result = service.localFallback(from: from, to: to);

    expect(result.points, [from, to]);
    expect(result.distanceMeters, greaterThan(111000));
    expect(result.distanceMeters, lessThan(112000));
    expect(result.durationSeconds, closeTo(result.distanceMeters / 1.4, 0.001));
  });

  test('OSRM GeoJSON yanıtı ortak rota modeline çevrilir', () {
    final result = RouteService.parseOsrmRoute({
      'routes': [
        {
          'distance': 1250.5,
          'duration': 780.0,
          'geometry': {
            'coordinates': [
              [32.85, 39.93],
              [32.86, 39.94],
            ],
          },
        },
      ],
    });

    expect(result.points, [
      const LatLng(39.93, 32.85),
      const LatLng(39.94, 32.86),
    ]);
    expect(result.distanceMeters, 1250.5);
    expect(result.durationSeconds, 780.0);
  });
}
