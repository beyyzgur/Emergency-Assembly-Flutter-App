import 'package:emergency_assembly_app/features/map/data/route_service.dart';
import 'package:emergency_assembly_app/features/map/domain/route_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  const service = RouteService();

  test(
    'yerel yaya fallback iki uç noktayı çizilebilir rota olarak döndürür',
    () {
      const from = LatLng(0, 0);
      const to = LatLng(0, 1);

      final result = service.localFallback(from: from, to: to);

      expect(result.points, [from, to]);
      expect(result.distanceMeters, greaterThan(111000));
      expect(result.distanceMeters, lessThan(112000));
      expect(
        result.durationSeconds,
        closeTo(result.distanceMeters / 1.4, 0.001),
      );
    },
  );

  test('araç fallbacki yaya fallbackinden daha kısa süre döndürür', () {
    const from = LatLng(39.93, 32.85);
    const to = LatLng(39.94, 32.86);

    final walking = service.localFallback(
      from: from,
      to: to,
      mode: RouteMode.walking,
    );
    final driving = service.localFallback(
      from: from,
      to: to,
      mode: RouteMode.driving,
    );

    expect(driving.points, [from, to]);
    expect(driving.durationSeconds, lessThan(walking.durationSeconds));
  });

  test('OSRM GeoJSON rota yanıtı ortak rota modeline çevrilir', () {
    final result = RouteService.parseOsrmRoute({
      'routes': [
        {
          'distance': 1250.5,
          'duration': 780.0,
          'geometry': {
            'type': 'LineString',
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

  test('varsayılan uç nokta FOSSGIS yaya profilini kullanır', () {
    final uri = RouteService.routeUri(
      from: const LatLng(39.93, 32.85),
      to: const LatLng(39.94, 32.86),
    );

    expect(uri.host, 'routing.openstreetmap.de');
    expect(uri.path, '/routed-foot/route/v1/foot/32.85,39.93;32.86,39.94');
    expect(uri.queryParameters['overview'], 'full');
    expect(uri.queryParameters['geometries'], 'geojson');
  });

  test('araç profili genel OSRM driving uç noktasını kullanır', () {
    final uri = RouteService.routeUri(
      from: const LatLng(39.93, 32.85),
      to: const LatLng(39.94, 32.86),
      mode: RouteMode.driving,
    );

    expect(uri.host, 'router.project-osrm.org');
    expect(uri.path, '/route/v1/driving/32.85,39.93;32.86,39.94');
  });
}
